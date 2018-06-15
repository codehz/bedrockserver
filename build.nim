#!/bin/env nimake

import nimake

const
  COptions = [
    "-m32",
    "-O0",
    "-g",
    "-Ilibhybris/include"
  ].mapIt(&"-t:{it}").join " "
  LinkOptions = [
    "-m32",
    "-L./lib",
    # "-rdynamic",
    # "-static",
    # "-Wl,--warn-once",
    # "-Wl,--whole-archive",
    "-lpthread",
    # "-lrt",
    # "-Wl,--no-whole-archive",
    ].mapIt(&"-l:{it}").join " "
  Options = [
    COptions,
    LinkOptions,
    "-d:noSignalHandler",
    "--cpu:i386",
    "--verbosity:0",
    "--Hint[Processing]:off",
    "--Hint[Conf]:off",
    "--Hint[Link]:off",
    "--Hint[SuccessX]:off",
  ].join " "
  BridgeCOptions = [
    "-O0",
    "-g",
    "-Ibridge/include",
    "-fno-rtti",
    "-ffast-math",
    "-std=gnu++14"
  ].mapIt(&"-t:{it}").join " "
  BridgeLinkOptions = [
    "-Lcore",
    "-lminecraftpe",
    "-nostdlib",
    "-nodefaultlibs",
    "-Wl,--gc-sections",
    "-lstdc++",
    "-ffast-math"
  ].mapIt(&"-l:{it}").join " "
  BridgeOptions = [
    BridgeCOptions,
    BridgeLinkOptions,
    "-d:noSignalHandler",
    "-d:release",
    "-d:useMalloc",
    "-d:bridge",
    "--app:lib",
    "--cpu:i386",
    "--os:android",
    "--cc:gcc",
    "--gc:regions",
    "--noCppExceptions",
    "--verbosity:0",
    "--Hint[Processing]:off",
    "--Hint[Conf]:off",
    "--Hint[Link]:off",
    "--Hint[SuccessX]:off"
  ].join " "

target "lib" / "libhybris.a":
  depIt: walkDirRec("libhybris" / "include")
  depIt: walkDirRec("libhybris" / "src")
  main = "libhybris" / "CMakeLists.txt"
  rule:
    mkdir "lib"
    withDir "libhybris-build":
      exec "cmake ../libhybris"
      exec "make -j8"
      cp "libhybris.a", target

target "bin" / "bedrockserver":
  dep: toSeq(walkDirRec("src")).filterIt("nimcache" notin it)
  dep: ["lib" / "libhybris.a"]
  main = "src" / "entry.nim"
  rule:
    mkdir "bin"
    exec &"nim cpp -o:{target} {Options} {main}"

const refs = [
  "mcpelauncher-core",
  "mcpelauncher-server",
  "minecraft-symbols",
]

for reference in refs:
  target "bridge" / "refs" / reference / "CMakeLists.txt":
    clean:
      removeDir target.parentDir
    rule:
      withDir target.parentDir.parentDir:
        exec &"git clone https://github.com/minecraft-linux/{reference} --depth 1"

# target "bin" / "bridge.so":
#   dep: toSeq(walkDirRec("bridge")).filterIt("nimcache" notin it)
#   dep: toSeq(walkDirRec("src")).filterIt("nimcache" notin it)
#   main = "bridge" / "entry.nim"
#   rule:
#     mkdir "bin"
#     exec &"nim cpp -o:{target} {BridgeOptions} {main}"

echo build()