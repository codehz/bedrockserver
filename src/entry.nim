import os, parsecfg, ospaths, sequtils

import logger, hybris, stubs, cppstring, HookManager, CrashHandler, ModLoader

var profile = "default"
var configfile = ""
var dict: Config

var firstCrash = true

proc read_property(name: cstring, value: cstring): cstring {.cdecl.} =
  try:
    let ret = dict.getSectionValue("", $name)
    if ret == "":
      dict.setSectionKey("", $name, $value)
      dict.writeConfig configfile
      return value
    return ret
  except:
    fatalQ "core", getCurrentExceptionMsg()
proc write_property(name: cstring, value: cstring) {.cdecl.} =
  try:
    dict.setSectionKey("", $name, $value)
    dict.writeConfig configfile
  except:
    fatalQ "core", getCurrentExceptionMsg()
proc read_property_group(group: cstring, name: cstring, value: cstring): cstring {.cdecl.} =
  try:
    let ret = dict.getSectionValue($group, $name)
    if ret == "":
      dict.setSectionKey("", $name, $value)
      dict.writeConfig configfile
      return value
    return ret
  except:
    fatalQ "core", getCurrentExceptionMsg()
proc write_property_group(group: cstring, name: cstring, value: cstring) {.cdecl.} =
  try:
    dict.setSectionKey($group, $name, $value)
    dict.writeConfig configfile
  except:
    fatalQ "core", getCurrentExceptionMsg()
proc get_profile(): cstring {.cdecl.} = profile

hook "mcpelauncher_property_get", read_property
hook "mcpelauncher_property_set", write_property
hook "mcpelauncher_property_get_group", read_property_group
hook "mcpelauncher_property_set_group", write_property_group
hook "mcpelauncher_profile", get_profile
hook "mcpelauncher_hook", hookFunction
hook "mcpelauncher_sys_dlopen", loadSystemLibrary
hook "mcpelauncher_sys_dlsym", getSystemLibrarySymbol

proc run() =
  setControlCHook do:
    if not firstCrash:
      quit 1
    writeStackTrace()
    stdin.close()

  notice "core", "Loading Bridge..."
  let bridge = dlopen(getAppDir() / "bridge.so")
  if not bridge.isValid:
    fatalQ "core", $hybris.dlerror()
  let bridge_version = cast[proc(): cstring {.cdecl.}](bridge.dlsym("bridge_version"))
  info "core", "Bridge Version: ", bridge_version()
  info "core", "Request DBUS Name: ", "one.codehz.bedrockserver.", profile
  cast[proc(name: cstring) {.cdecl.}](bridge.dlsym("bridge_init"))("one.codehz.bedrockserver." & profile)
  cast[proc(name: cstring) {.cdecl.}](bridge.dlsym("openDB"))(profile & ".db")
  hook "mcpelauncher_get_dbus", bridge.dlsym("get_dbus")
  hook "mcpelauncher_exec_command", bridge.dlsym("_exec_command")
  hook "mcpelauncher_server_thread", bridge.dlsym("_server_thread")
  logfn = cast[proc(level: Level, tag: cstring, data: cstring) {.cdecl.}](bridge.dlsym("writeLog"))

  notice "core", "Loading Bedrock Server..."
  let mcpePath = getCurrentDir() / "data/libs/libminecraftpe.so"
  let handle = dlopen(mcpePath)
  let debugLog = cast[ptr pointer](dlsym(handle, "_ZN6RakNet19rakDebugLogCallbackE"))
  debugLog[] = nil
  if not handle.isValid:
    fatalQ "core", hybris.dlerror()
  addHookLibrary (pointer)handle, mcpePath
  postInit(handle)
  cppstring.init(handle)

  var world = dict.getSectionValue("", "level-dir")
  if world == "": world = "world"
  shallow world

  var mods = toSeq(walkPattern(getCurrentDir() / "user" / "mods" / "*.so"))
  mods.add toSeq(walkPattern(getCurrentDir() / "worlds" / dict.getSectionValue("", "level-dir") / "mods" / "*.so"))
  shallow mods
  loadAll mods

  let bridge_start = cast[proc(lib: Handle, srvcb: proc(srv: pointer) {.cdecl.}) {.cdecl.}](bridge.dlsym("bridge_start"))

  bridge_start(handle, notify)

when isMainModule:
  if paramCount() > 0:
    profile = paramStr(1)
  configfile = profile & ".cfg"
  info "core", "Loading profile: " & profile
  if not existsFile configfile:
    warn "core", "Config file is not exists, creating..."
    dict = newConfig()
  else:
    dict = loadConfig configfile

  try:
    run()
  except:
    fatalQ "core", getCurrentExceptionMsg()
