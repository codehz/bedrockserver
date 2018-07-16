#include <log.h>
#include <iostream>
#include <mcpelauncher/minecraft_utils.h>
// #include <mcpelauncher/crash_handler.h>
#include <mcpelauncher/path_helper.h>
#include <minecraft/Common.h>
#include <mcpelauncher/app_platform.h>
#include <minecraft/Whitelist.h>
#include <minecraft/OpsList.h>
#include <minecraft/Api.h>
#include <minecraft/LevelSettings.h>
#include <minecraft/FilePathManager.h>
#include <minecraft/AppResourceLoader.h>
#include <minecraft/MinecraftEventing.h>
#include <minecraft/ResourcePack.h>
#include <minecraft/ResourcePackStack.h>
#include <minecraft/SaveTransactionManager.h>
#include <minecraft/AutomationClient.h>
#include <minecraft/ExternalFileLevelStorageSource.h>
#include <minecraft/ServerInstance.h>
#include <minecraft/Minecraft.h>
#include <minecraft/I18n.h>
#include <minecraft/DedicatedServerCommandOrigin.h>
#include <minecraft/MinecraftCommands.h>
#include <console.h>
#include <dlfcn.h>
#include "launcher_minecraft_api.h"
#include "stub_key_provider.h"
#include <server_properties.h>
#include "server_minecraft_app.h"

extern "C" const char *bridge_version()
{
  return "0.1.0";
}

static void empty() {}

extern "C" void bridge_init(void *handle)
{
  MinecraftUtils::workaroundLocaleBug();
  MinecraftUtils::setupForHeadless();

  Log::debug("Bridge", "Minecraft is at offset 0x%x", MinecraftUtils::getLibraryBase(handle));
  MinecraftUtils::initSymbolBindings(handle);
  Log::info("Bridge", "Game version: %s", Common::getGameVersionStringNet().c_str());

  Log::info("Bridge", "Applying patches");
  void *ptr = dlsym(handle, "_ZN5Level17_checkUserStorageEv");
  MinecraftUtils::patchCallInstruction(ptr, (void *)&empty, true);

  LauncherAppPlatform::initVtable(handle);
  std::unique_ptr<LauncherAppPlatform> appPlatform(new LauncherAppPlatform());
  appPlatform->initialize();

  Log::trace("Bridge", "Loading server properties");
  ServerProperties props;

  Whitelist whitelist;
  OpsList ops(true);
  LauncherMinecraftApi api(handle);

  LevelSettings levelSettings;
  levelSettings.seed = LevelSettings::parseSeedString(props.worldSeed.get(), Level::createRandomSeed());
  levelSettings.gametype = props.gamemode;
  levelSettings.forceGameType = props.forceGamemode;
  levelSettings.difficulty = props.difficulty;
  levelSettings.dimension = 0;
  levelSettings.generator = props.worldGenerator;
  levelSettings.edu = false;
  levelSettings.mpGame = true;
  levelSettings.lanBroadcast = true;
  levelSettings.commandsEnabled = true;
  levelSettings.texturepacksRequired = false;

  FilePathManager pathmgr(appPlatform->getCurrentStoragePath(), false);
  pathmgr.setPackagePath(appPlatform->getPackagePath());
  pathmgr.setSettingsPath(pathmgr.getRootPath());
  Log::trace("Bridge", "Initializing resource loaders");
  ResourceLoaders::registerLoader((ResourceFileSystem)1, std::unique_ptr<ResourceLoader>(new AppResourceLoader([&pathmgr] { return pathmgr.getPackagePath(); })));
  ResourceLoaders::registerLoader((ResourceFileSystem)8, std::unique_ptr<ResourceLoader>(new AppResourceLoader([&pathmgr] { return pathmgr.getUserDataPath(); })));
  ResourceLoaders::registerLoader((ResourceFileSystem)4, std::unique_ptr<ResourceLoader>(new AppResourceLoader([&pathmgr] { return pathmgr.getSettingsPath(); })));

  MinecraftEventing eventing(pathmgr.getRootPath());
  eventing.init();
  Log::trace("Bridge", "Initializing ResourcePackManager");
  ContentTierManager ctm;
  ResourcePackManager *resourcePackManager = new ResourcePackManager([&pathmgr]() { return pathmgr.getRootPath(); }, ctm);
  ResourceLoaders::registerLoader((ResourceFileSystem)0, std::unique_ptr<ResourceLoader>(resourcePackManager));
  Log::trace("Bridge", "Initializing PackManifestFactory");
  PackManifestFactory packManifestFactory(eventing);
  Log::trace("Bridge", "Initializing SkinPackKeyProvider");
  SkinPackKeyProvider skinPackKeyProvider;
  StubKeyProvider stubKeyProvider;
  Log::trace("Bridge", "Initializing PackSourceFactory");
  PackSourceFactory packSourceFactory(nullptr);
  Log::trace("Bridge", "Initializing ResourcePackRepository");
  ResourcePackRepository resourcePackRepo(eventing, packManifestFactory, skinPackKeyProvider, &pathmgr, packSourceFactory);
  Log::trace("Bridge", "Adding vanilla resource pack");
  std::unique_ptr<ResourcePackStack> stack(new ResourcePackStack());
  stack->add(PackInstance(resourcePackRepo.vanillaPack, -1, false, nullptr), resourcePackRepo, false);
  resourcePackManager->setStack(std::move(stack), (ResourcePackStackType)3, false);
  Log::trace("Bridge", "Adding world resource packs");
  resourcePackRepo.addWorldResourcePacks(pathmgr.getWorldsPath().std() + props.worldDir.get());
  resourcePackRepo.refreshPacks();
  DedicatedServerMinecraftApp minecraftApp;
  Automation::AutomationClient aclient(minecraftApp);
  minecraftApp.automationClient = &aclient;
  Log::debug("Bridge", "Initializing SaveTransactionManager");
  std::shared_ptr<SaveTransactionManager> saveTransactionManager(new SaveTransactionManager([](bool b) {
    if (b)
      Log::debug("Bridge", "Saving the world...");
    else
      Log::debug("Bridge", "World has been saved.");
  }));
  Log::debug("Bridge", "Initializing ExternalFileLevelStorageSource");
  ExternalFileLevelStorageSource levelStorage(&pathmgr, saveTransactionManager);
  Log::debug("Bridge", "Initializing ServerInstance");
  auto idleTimeout = std::chrono::seconds((int)(props.playerIdleTimeout * 60.f));
  IContentKeyProvider *keyProvider = &stubKeyProvider;
  auto createLevelStorageFunc = [&levelStorage, &props, keyProvider](Scheduler &scheduler) {
    return levelStorage.createLevelStorage(scheduler, props.worldDir.get(), mcpe::string(), *keyProvider);
  };
  ServerInstance instance(minecraftApp, whitelist, ops, &pathmgr, idleTimeout, props.worldDir.get(), props.worldName.get(), props.motd.get(), levelSettings, api, props.viewDistance, true, props.port, props.portV6, props.maxPlayers, props.onlineMode, {}, "normal", *mce::UUID::EMPTY, eventing, resourcePackRepo, ctm, *resourcePackManager, createLevelStorageFunc, pathmgr.getWorldsPath(), nullptr, nullptr, [](mcpe::string const &s) { Log::debug("Bridge", "Unloading level: %s", s.c_str()); }, [](mcpe::string const &s) { Log::debug("Bridge", "Saving level: %s", s.c_str()); });
  Log::trace("Bridge", "Loading language data");
  I18n::loadLanguages(*resourcePackManager, "en_US");
  resourcePackManager->onLanguageChanged();
  Log::info("Bridge", "Server initialized");
  instance.startServerThread();

  ConsoleReader reader;
  // reader.registerInterruptHandler();

  std::string line;
  while (reader.read(line))
  {
    if (line.empty())
      continue;
    instance.queueForServerThread([&instance, line]() {
      std::unique_ptr<DedicatedServerCommandOrigin> commandOrigin(new DedicatedServerCommandOrigin("Server", *instance.minecraft));
      instance.minecraft->getCommands()->requestCommandExecution(std::move(commandOrigin), line, 4, true);
    });
  }

  Log::info("Bridge", "Stopping...");
  instance.leaveGameSync();

  MinecraftUtils::workaroundShutdownCrash(handle);
}