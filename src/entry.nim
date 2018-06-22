const doc = """
Minecraft Bedrock Server Launcher

Usage:
  ./bedrockserver [<profile>]
  ./bedrockserver -h | --help
  ./bedrockserver --version

Options:
  -h --help             Show this screen
  --version             Show version
"""

import os, parsecfg, ospaths, sequtils
import docopt

import logger, hybris, stubs, cppstring, HookManager, CrashHandler, ModLoader

var configfile = ""
var dict: Config
var modified = false

proc run() =
  setControlCHook do:
    stdin.close()
  notice "Bedrock Server Loading..."
  let mcpePath = getAppDir() / "data/libs/libminecraftpe.so"
  let handle = dlopen(mcpePath)
  let debugLog = cast[ptr pointer](dlsym(handle, "_ZN6RakNet19rakDebugLogCallbackE"))
  debugLog[] = nil
  if not handle.isValid:
    fatalQ $hybris.dlerror()
  addHookLibrary (pointer)handle, mcpePath
  notice "Core Loaded"
  postInit(handle)
  cppstring.init(handle)

  proc read_property(name: cstring, value: cstring): cstring {.cdecl.} =
    try:
      let ret = dict.getSectionValue("", $name)
      if ret == "":
        dict.setSectionKey("", $name, $value)
        modified = true
        return value
      return ret
    except:
      fatalQ getCurrentExceptionMsg()

  hook "mcpelauncher_property_get", read_property
  hook "mcpelauncher_hook", hookFunction

  var world = dict.getSectionValue("", "level-dir")
  if world == "": world = "world"
  shallow world

  var mods = toSeq(walkPattern(getAppDir() / "user" / "mods" / "*.so"))
  mods.add toSeq(walkPattern(getAppDir() / "worlds" / dict.getSectionValue("", "level-dir") / "mods" / "*.so"))
  shallow mods
  loadAll mods

  let bridge = dlopen(getAppDir() / "bridge.so")
  if not bridge.isValid:
    fatalQ $hybris.dlerror()
  notice "Bridge Loaded"
  let bridge_version = cast[proc(): cstring {.cdecl.}](bridge.dlsym("bridge_version"))
  info "Bridge Version: ", bridge_version()
  let bridge_init = cast[proc(lib: Handle) {.cdecl.}](bridge.dlsym("bridge_init"))

  bridge_init handle

  if modified:
    dict.writeConfig configfile

when isMainModule:
  let args = docopt(doc, version = "0.0.1")
  var profile = "default"
  if args["<profile>"]:
    profile = $args["<profile>"]
  configfile = profile & ".cfg"
  if not existsFile configfile:
    warn "Config file is not exists"
    dict = newConfig()
  else:
    dict = loadConfig configfile

  try:
    run()
  except:
    fatalQ getCurrentExceptionMsg()
