{.passL:"-lhybris".}

import tables, macros

type
  Handle* = distinct pointer
  Hook = object
    name: cstring
    fn: pointer
  LoadFlag* {.pure.} = enum
    RTLD_LAZY = 0x00001
    RTLD_NOW = 0x00002
    RTLD_BINDING_MASK = 0x00003
    RTLD_NOLOAD = 0x00004
    RTLD_DEEPBIND = 0x00008
    RTLD_GLOBAL = 0x00100
    RTLD_NODELETE = 0x01000

proc isValid*(handle: Handle): bool = ((pointer)handle) != nil
proc `$`*(handle: Handle): string = ((pointer)handle).repr

proc dlopen*(filename: cstring, flag: LoadFlag = RTLD_LAZY): Handle {.importc: "hybris_dlopen".}
proc dlsym*(handle: Handle, symbol: cstring): pointer {.importc: "hybris_dlsym".}
proc dlerror*(): cstring {.importc: "hybris_dlerror".}
proc hook*(name: cstring, fn: pointer) {.importc: "hybris_hook".}
proc regHooks*(name: cstring, fn: ptr Hook) {.importc: "hybris_register_hooks".}
proc loadEmptyLibrary*(name: cstring) {.importc: "load_empty_library".}

var
  registry = initTable[string, pointer](256)

proc register*(sym: string, variable: ptr pointer) =
  registry.add(sym, variable)

template postInit*(mc: Handle) =
  for key, variable in registry.mpairs():
    debug "hybris", "LOAD SYMBOL", key
    let sym = dlsym(mc, key)
    if sym.isNil:
      fatalQ "hybris", "Failed to load symbol: ", key
    variable = sym

macro importmc*(sym: static[string], body: untyped): untyped =
  let id = body[0]
  let params = body[3]
  nnkStmtList.newTree(
    nnkVarSection.newTree(
      nnkIdentDefs.newTree(
        id,
        nnkPar.newTree(
          nnkProcTy.newTree(
            params,
            nnkPragma.newTree(
              newIdentNode("cdecl")
            )
          )
        ),
        newNilLit()
      )
    ),
    nnkCall.newTree(
      nnkDotExpr.newTree(
        newIdentNode("hybris"),
        newIdentNode("register")
      ),
      newLit(sym),
      nnkCast.newTree(
        nnkPtrTy.newTree(
          newIdentNode("pointer")
        ),
        nnkCall.newTree(
          newIdentNode("addr"),
          id
        )
      )
    )
  )
