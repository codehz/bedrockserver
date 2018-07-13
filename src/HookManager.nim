import sequtils, tables, memfiles

import elf, unsafe, logger

type
  HookSection = object
    address, size: Elf32_Off
  HookInfo = object
    hookSections: seq[HookSection]
  LinkMap = object
    lAddr: ptr uint32
    lName: cstring
    lLd: ptr uint32
    lNext: ptr LinkMap
    lPrev: ptr LinkMap
  SoInfo = object
    name: array[128, char]
    phdr: ptr UncheckedArray[Elf32_Phdr]
    phnum: int32
    entry, base, size: uint32
    unused: int32
    dynamic: ptr uint32
    flags: uint32
    strtab: ptr UncheckedArray[char]
    symtab: ptr UncheckedArray[Elf32_Sym]
    nbucket, nchain: uint32
    bucket, chain: ptr UncheckedArray[uint32]
    plt_got: ptr UncheckedArray[uint32]
    plt_rel: ptr UncheckedArray[Elf32_Rel]
    plt_rel_count: uint32
    rel: ptr UncheckedArray[Elf32_Rel]
    rel_count: uint32
    preinit_array: ptr UncheckedArray[uint32]
    preinit_array_count: uint32
    init_array: ptr UncheckedArray[uint32]
    init_array_count: uint32
    fini_array: ptr UncheckedArray[uint32]
    fini_array_count: uint32
    init_func, fini_func: proc(): pointer {.cdecl.}
    refcount: uint32
    linkmap: LinkMap
    constructors_called: int32
    gnu_relro_start: Elf32_Addr
    gnu_relro_len: uint32
  HookDef = object
    hook: pointer
    origin: ptr pointer
    ret: int

var
  hookLibraries = newTable[pointer, HookInfo] 16
  hookChain = newTable[pointer, HookDef] 16

proc exp(name: string): string = "mcpelauncher_internal_" & name

proc patchSection(base: Elf32_Addr, offset: Elf32_Off, size: Elf32_Word, sym, override: pointer): bool =
  var address = base + offset + 4
  while address < base + offset + size:
    let xaddr = cast[ptr pointer](address)
    if xaddr[] == sym:
      xaddr[] = override
      return true
    address += (uint32)(sizeof int)
  return false

proc patchLibrary(lib, sym, override: pointer): bool =
  let si = cast[ptr SoInfo](lib)
  if si.isNil or si notin hookLibraries:
    return false
  let hi = hookLibraries[si]
  for se in hi.hookSections:
    if patchSection(si.base, se.address, se.size, sym, override):
      result = true

proc addHookLibrary*(p: pointer, pathC: cstring)
  {.exportc:exp"addHookLibrary", cdecl, dynlib.} =
  let path = $pathC
  let lib = cast[ptr SoInfo](p)
  if lib in hookLibraries:
    return
  var file = memfiles.open(path, fmRead, -1, 0, -1, true)
  defer: file.close()
  let header: ptr Elf32_Ehdr = cast[ptr Elf32_Ehdr](file.mem)
  let shdr = cast[ByteAddress](file.mem) + (int)header.e_shoff
  var strtab: ByteAddress = 0
  for i in 0..<(int)header.e_shnum:
    let entry = cast[ptr Elf32_Shdr](shdr + (int)(header.e_shentsize) * i)
    if entry.sh_type == SHT_STRTAB:
      strtab = cast[ByteAddress](file.mem) + (int)entry.sh_offset
  if strtab == 0:
    fatalQ "addHookLibrary: couldn't find strtab"
  var hi = HookInfo(hookSections: newSeqOfCap[HookSection]((int)header.e_shnum))
  for i in 0..<(int)header.e_shnum:
    let entry = cast[ptr Elf32_Shdr](shdr + (int)(header.e_shentsize) * i)
    let entryName = $cast[cstring](strtab + (int)entry.sh_name)
    case entryName:
    of ".got", ".got.plt", ".data.rel.ro":
      hi.hookSections.add HookSection(
        address: entry.sh_addr,
        size: entry.sh_size
      )
    else: discard
  hookLibraries.add lib, hi

proc hookFunctionImpl(symbol, hook: pointer, orig: ptr pointer): int =
  orig[] = symbol
  for lib, info in hookLibraries:
    if patchLibrary(lib, symbol, hook):
      result = 1
  if result == 0:
    error "Failed to hook a symbol: " & $cast[ByteAddress](symbol)

proc hookFunction*(symbol, hook: pointer, orig: ptr pointer): int
  {.exportc:exp"hookFunction", cdecl, dynlib.} =
  if symbol in hookChain:
    let def = hookChain[symbol]
    orig[] = def.origin[]
    def.origin[] = hook
    hookChain[symbol] = HookDef(hook: hook, origin: orig, ret: def.ret)
    return def.ret
  else:
    let ret = hookFunctionImpl(symbol, hook, orig)
    hookChain[symbol] = HookDef(hook: hook, origin: orig, ret: ret)
    return ret
