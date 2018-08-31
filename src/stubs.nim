import macros
import dynlib

import logging
import logger

import hybris
import sym.android
import sym.fmod
import sym.egl
import sym.port
import sym.systemd
import sym.guile

macro stubAll(arr: static[openarray[string]]): untyped =
  result = nnkStmtList.newTree()
  for item in arr:
    let itemname = $item
    let identify = newIdentNode("stub" & itemname)
    result.add(
      nnkProcDef.newTree(
        identify,
        newEmptyNode(),
        newEmptyNode(),
        nnkFormalParams.newTree(
          newEmptyNode()
        ),
        newEmptyNode(),
        newEmptyNode(),
        nnkStmtList.newTree(
          nnkCommand.newTree(
            newIdentNode("warn"),
            newLit("STUB"),
            newLit(itemname)
          )
        )
      ),
      nnkCall.newTree(
        newIdentNode("hook"),
        newLit(itemname),
        identify
      )
    )

macro genLibrarySym(arr: static[openarray[string]]): untyped =
  result = nnkStmtList.newTree()
  for item in arr:
    let itemname = $item
    let itemlit = newLit(itemname)
    let identify = newIdentNode("math_" & itemname)
    result.add(
      nnkProcDef.newTree(
        identify,
        newEmptyNode(),
        newEmptyNode(),
        nnkFormalParams.newTree(
          newEmptyNode()
        ),
        nnkPragma.newTree(
          nnkExprColonExpr.newTree(
            newIdentNode("importc"),
            itemlit
          )
        ),
        newEmptyNode(),
        newEmptyNode()
      ),
      nnkCall.newTree(
        newIdentNode("hook"),
        itemlit,
        identify
      )
    )

stubAll(fmod.syms)
stubAll(android.syms)
stubAll(egl.syms)
genLibrarySym(port.syms)
genLibrarySym(systemd.syms)
genLibrarySym(guile.syms)
loadEmptyLibrary("libfmod.so")
loadEmptyLibrary("liblog.so")
loadEmptyLibrary("libc.so")
loadEmptyLibrary("libm.so")
loadEmptyLibrary("libandroid.so")
loadEmptyLibrary("libEGL.so")
loadEmptyLibrary("libGLESv2.so")
loadEmptyLibrary("libOpenSLES.so")
loadEmptyLibrary("libGLESv1_CM.so")
loadEmptyLibrary("libc++.so")
loadEmptyLibrary("libstdc++.so")
loadEmptyLibrary("libmcpelauncher_mod.so")
