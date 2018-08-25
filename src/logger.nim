import strformat, strutils

type Level* = enum
  TRACE, DEBUG, INFO, NOTICE, WARN, ERROR, FATAL

const table = ['T', 'D', 'I', 'N', 'W', 'E', 'F']
var logfn*: proc(level: Level, tag: cstring, data: cstring) {.cdecl.}

proc log*(level: Level, tag: string, data: varargs[string, `$`]) =
  let ch = $table[(int)level]
  let jd = data.join();
  if logfn != nil:
    logfn(level, tag, jd);
  else:
    echo fmt"{ch} [{tag}] {jd}"
  discard


template trace*(tag: string, data: varargs[string, `$`]) = log(TRACE, tag, data)
template debug*(tag: string, data: varargs[string, `$`]) = log(DEBUG, tag, data)
template info*(tag: string, data: varargs[string, `$`]) = log(INFO, tag, data)
template notice*(tag: string, data: varargs[string, `$`]) = log(NOTICE, tag, data)
template warn*(tag: string, data: varargs[string, `$`]) = log(WARN, tag, data)
template error*(tag: string, data: varargs[string, `$`]) = log(ERROR, tag, data)
template fatal*(tag: string, data: varargs[string, `$`]) = log(FATAL, tag, data)

template fatalQ*(tag: string, data: varargs[string, `$`]) =
  fatal(tag, data)
  quit(1)

import hybris
hook("mcpelauncher_log", proc(level: Level, tag: cstring, str: cstring) {.cdecl.} = log level, $tag, str)