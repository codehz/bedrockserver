import os

import logger, hybris, stubs, cppstring, HookManager, CrashHandler

notice "Bedrock Server Loading..."
let mcpePath = getCurrentDir().parentDir / "core" / "libminecraftpe.so"
let handle = dlopen(getCurrentDir().parentDir / "core" / "libminecraftpe.so")
if not handle.isValid:
  fatalQ $dlerror()
addHookLibrary (pointer)handle, mcpePath
notice "Core Loaded"
postInit(handle)
cppstring.init(handle)

let bridge = dlopen(getCurrentDir() / "bridge.so")
if not bridge.isValid:
  fatalQ $dlerror()
notice "Bridge Loaded"
let bridge_version = cast[proc(): cstring {.cdecl.}](bridge.dlsym("bridge_version"))
info "Bridge Version: ", bridge_version()
let bridge_init = cast[proc() {.cdecl.}](bridge.dlsym("bridge_init"))
bridge_init()