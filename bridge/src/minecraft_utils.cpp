#include <mcpelauncher/minecraft_utils.h>
#include <cstdlib>
#include <dlfcn.h>
#include <soinfo.h>
#include <minecraft/symbols.h>
#include <minecraft/std/string.h>
#include <mcpelauncher/path_helper.h>
#include <log.h>

void MinecraftUtils::workaroundLocaleBug()
{
  setenv("LC_ALL", "C", 1); // HACK: Force set locale to one recognized by MCPE so that the outdated C++ standard library MCPE uses doesn't fail to find one
}

void MinecraftUtils::setupForHeadless() {}

unsigned int MinecraftUtils::getLibraryBase(void *handle)
{
  return ((soinfo *)handle)->base;
}

static void AutomationClientDummySender(void *th, std::string &&result)
{
}

void MinecraftUtils::initSymbolBindings(void *handle)
{
  mcpe::string::empty = (mcpe::string *)dlsym(handle, "_ZN4Util12EMPTY_STRINGE");
  minecraft_symbols_init(handle);
  void *patchOff = (void *)dlsym(handle, "_ZNK15FilePathManager15getUserDataPathEv");
  patchCallInstruction(patchOff, (void *)&PathHelper::getUserDirectory, true);
  patchOff = (void *)dlsym(handle, "_ZNK15FilePathManager13getWorldsPathEv");
  patchCallInstruction(patchOff, (void *)&PathHelper::getWorldsDirectory, true);
  patchOff = (void *)dlsym(handle, "_ZN10Automation16AutomationClient4sendERKNS_8ResponseE");
  patchCallInstruction((void *)patchOff, (void *)&AutomationClientDummySender, true);
}

static void workerPoolDestroy(void *th)
{
  Log::trace("Fixme", "WorkerPool-related class destroy 0x%08X", (unsigned long)th);
}

void MinecraftUtils::workaroundShutdownCrash(void *handle)
{
  // this is an ugly hack to workaround the close app crashes MCPE causes
  unsigned int patchOff = (unsigned int)dlsym(handle, "_ZN9TaskGroupD2Ev");
  patchCallInstruction((void *)patchOff, (void *)&workerPoolDestroy, true);
  patchOff = (unsigned int)dlsym(handle, "_ZN10WorkerPoolD2Ev");
  patchCallInstruction((void *)patchOff, (void *)&workerPoolDestroy, true);
  patchOff = (unsigned int)dlsym(handle, "_ZN9SchedulerD2Ev");
  patchCallInstruction((void *)patchOff, (void *)&workerPoolDestroy, true);
  patchOff = (unsigned int)dlsym(handle, "_ZN9TaskGroup5flushEv");
  patchCallInstruction((void *)patchOff, (void *)&workerPoolDestroy, true);
}

void MinecraftUtils::patchCallInstruction(void *patchOff, void *func, bool jump)
{
  unsigned char *data = (unsigned char *)patchOff;
  data[0] = (unsigned char)(jump ? 0xe9 : 0xe8);
  int ptr = ((int)func) - (int)patchOff - 5;
  memcpy(&data[1], &ptr, sizeof(int));
}