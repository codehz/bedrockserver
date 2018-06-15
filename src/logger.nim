import logging
export logging

template fatalQ*(str: string) =
  fatal str
  quit(1)

when not defined(bridge):
  import hybris
  addHandler(newConsoleLogger(lvlAll, "$levelid "))
  hook("mcpelauncher_log", proc(level: Level, str: cstring) {.cdecl.} = log level, str)
else:
  import strutils
  proc mcpelauncher_log(level: Level, str: cstring) {.importc.}
  type
    ModLogger = ref object of Logger
  method log(logger: ModLogger, level: Level, args: varargs[string, `$`]) =
    mcpelauncher_log(level, args.join(""))
  addHandler(new ModLogger)