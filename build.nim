#!/bin/env nimake

import nimake, os

const
  COptions = [
    "-m32",
    "-O3",
    "-Ilibhybris/include"
  ].mapIt(&"-t:{it}").join " "
  LinkOptions = [
    "-m32",
    "-O3",
    "-flto",
    "-L./lib",
    "-lrt",
    "-lpthread",
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
  cc = getEnv("GCC", "i686-linux-android-gcc")

const BridgeCPPOptions = [
  "-std=c++14",
  "-Ibridge/include",
  "-Ibridge/refs/minecraft-symbols/src"
].join " "
const BridgeCOptions = [
  "-std=c99",
  "-DSQLITE_ENABLE_JSON1",
  "-DSQLITE_ENABLE_RTREE",
  "-DSQLITE_DEFAULT_MMAP_SIZE=4096",
  "-DSQLITE_DEFAULT_AUTOVACUUM=1",
  "-DSQLITE_DEFAULT_SYNCHRONOUS=0",
  "-DSQLITE_THREADSAFE=0",
  "-Ibridge/include",
].join " "

target "bin" / "bridge.so":
  depIt: walkDirRec "bridge" / "src"
  depIt: walkDirRec "bridge" / "include"
  dep: ["objs" / "sqlite.o"]
  dep: toSeq(walkDirRec "bridge" / "refs").filterIt(".git" notin it and "darwin" notin it and "sqlite3.c" notin it)
  clean:
    rm target
  receipt:
    let allcpp = deps.filterIt(it.endsWith(".cpp") or it.endsWith(".o")).join " "
    exec &"{cpp} {BridgeCPPOptions} -shared -fPIC -o {target} {allcpp}"

target "objs" / "sqlite.o":
  main = "bridge" / "refs" / "sqlite3.c"
  clean:
    rm "objs"
    rm target
  receipt:
    mkdir "objs"
    exec &"{cc} {BridgeCOptions} -c -o {target} {main}"

handleCLI()
