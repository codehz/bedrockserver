#!/bin/env nimake

import nimake, os

const
  COptions = [
    "-m32",
    "-Os",
    "-fno-rtti",
    "-Ilibhybris/include"
  ].mapIt(&"-t:{it}").join " "
  LinkOptions = [
    "-m32",
    "-Os",
    "-L./lib",
    "-static",
    "-lrt",
    "-lpthread",
    "-fno-rtti",
    "-fno-exceptions",
    "-ffunction-sections",
    "-fdata-sections",
    "-Wl,--gc-sections",
    "-w",
    "-s"
    ].mapIt(&"-l:{it}").join " "
  Options = [
    COptions,
    LinkOptions,
    "-d:noSignalHandler",
    "-d:release",
    "-d:useMalloc",
    "--deadCodeElim:on",
    "--opt:size",
    "--cpu:i386",
    "--verbosity:0",
    "--Hint[Processing]:off",
    "--Hint[Conf]:off",
    "--Hint[Link]:off",
    "--Hint[SuccessX]:off",
  ].join " "

target "lib" / "libhybris.a":
  depIt: walkDirRec("libhybris" / "include")
  depIt: walkDirRec("libhybris" / "src")
  main = "libhybris" / "CMakeLists.txt"
  clean:
    rm target
    rm "libhybris-build"
  receipt:
    mkdir "lib"
    withDir "libhybris-build":
      exec "cmake ../libhybris"
      exec "make -j8"
      cp "libhybris.a", target

target "bin" / "bedrockserver":
  dep: toSeq(walkDirRec("src")).filterIt("nimcache" notin it)
  dep: ["lib" / "libhybris.a"]
  main = "src" / "entry.nim"
  clean:
    rm main.parentDir / "nimcache"
    rm target
  receipt:
    mkdir "bin"
    exec &"nim cpp -o:{target} {Options} {main}"

let
  cpp = getEnv("CPP", "i686-linux-android-g++")

const BridgeCOptions = [
  "-shared",
  "-std=c++14",
  "-Os",
  "-fPIC",
  "-Ibridge/include",
  "-Ibridge/refs/minecraft-symbols/src"
].join " "

target "bin" / "bridge.so":
  depIt: walkDirRec "bridge" / "src"
  depIt: walkDirRec "bridge" / "include"
  dep: toSeq(walkDirRec "bridge" / "refs").filterIt(".git" notin it).filterIt("darwin" notin it)
  receipt:
    let allsrc = deps.filterIt(it.endsWith ".cpp").join " "
    exec &"{cpp} {BridgeCOptions} -shared -std=c++14 -fPIC -o {target} {allsrc}"
    exec &"strip {target}"

handleCLI()