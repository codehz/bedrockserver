proc cnew*[T](x: T): ptr T {.importcpp: "(new '*0#@)", nodecl.}

{.push hint[XDeclaredButNotUsed]: off.}
type
  CppString* {.importcpp:"std::string", header:"<string>".} = object
  XString* = distinct CppString
  SharedPtr* {.importcpp:"std::shared_ptr<'0>", header:"<memory>".}[T] = object
{.pop.}

proc cppString*(s: cstring): CppString {.importcpp:"std::string(#)".}

template str*(s: cstring{lit}): CppString =
  var target {.gensym.} = cppString(s)
  target

proc c_str*(str: CppString): cstring {.importcpp:"#.c_str()", nodecl.}

proc `$`*(str: CppString): string {.inline.} = $str.c_str()

converter pass*(str: CppString): XString {.importcpp:"#".}
converter pass*(str: cstring): XString {.importcpp:"#".}
proc passString(str: cstring): XString {.importcpp:"#".}
converter pass*(str: string): XString {.inline.} = passString(str)

proc `[]`*[T](p: SharedPtr[T]): var T {.importcpp:"*#".}

proc printf*(formatstr: cstring) {.importc: "printf", varargs, header: "<stdio.h>".}

when not defined(bridge):
  import hybris

  var empty: ptr CppString
  proc init*(handle: Handle) =
    empty = cast[ptr CppString](dlsym(handle, "_ZN4Util12EMPTY_STRINGE"))