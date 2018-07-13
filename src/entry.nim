import os, parsecfg, ospaths, sequtils

import logger, hybris, stubs, cppstring, HookManager, CrashHandler, ModLoader

var configfile = ""
var dict: Config
var modified = false

proc run() =
  setControlCHook do:
    writeStackTrace()
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
  proc write_property(name: cstring, value: cstring) {.cdecl.} =
    try:
      dict.setSectionKey("", $name, $value)
      modified = true
    except:
      fatalQ getCurrentExceptionMsg()
  proc read_property_group(group: cstring, name: cstring, value: cstring): cstring {.cdecl.} =
    try:
      let ret = dict.getSectionValue($group, $name)
      if ret == "":
        dict.setSectionKey("", $name, $value)
        modified = true
        return value
      return ret
    except:
      fatalQ getCurrentExceptionMsg()
  proc write_property_group(group: cstring, name: cstring, value: cstring) {.cdecl.} =
    try:
      dict.setSectionKey($group, $name, $value)
      modified = true
    except:
      fatalQ getCurrentExceptionMsg()

  hook "mcpelauncher_property_get", read_property
  hook "mcpelauncher_property_set", write_property
  hook "mcpelauncher_property_get_group", read_property_group
  hook "mcpelauncher_property_set_group", write_property_group
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
  var profile = "default"
  if paramCount() > 0:
    profile = paramStr(1)
  configfile = profile & ".cfg"
  info "Loading profile: " & profile
  if not existsFile configfile:
    warn "Config file is not exists, creating..."
    dict = newConfig()
  else:
    dict = loadConfig configfile

  try:
    run()
  except:
    fatalQ getCurrentExceptionMsg()
