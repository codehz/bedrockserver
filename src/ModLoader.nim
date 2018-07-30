import memfiles, strutils, tables, sets, ospaths
import hybris, logger, elf, HookManager

var depCache = initTable[string, HashSet[string]] 16
var mods = initTable[string, Handle] 16

proc loadMod(path: string): Handle =
  result = dlopen path
  if not result.isValid:
    error "ModLoader", "Failed to load mod ", path, ": ", dlerror()
  let initFn = cast[proc () {.cdecl.}](result.dlsym "mod_init")
  if initFn != nil:
    initFn()

proc getModDependencies(path: string): seq[string] =
  var xfile = memfiles.open(path, fmRead)
  var base = cast[ByteAddress](xfile.mem)
  defer: xfile.close
  let header = cast[ptr Elf32_Ehdr](base)
  let phdr = base + (int)header.e_phoff
  var dynEntry: ptr Elf32_Phdr = nil
  for i in 0..<(int)header.e_phnum:
    let entry = cast[ptr Elf32_Phdr](phdr + i * (int)header.e_phentsize)
    if entry.p_type == PT_DYNAMIC:
      dynEntry = entry
  if dynEntry == nil:
    error "ModLoader", "Couldn't find PT_DYNAMIC"
    return @[]
  let dynData = cast[ptr UncheckedArray[Elf32_Dyn]](base + (int)dynEntry.p_offset)
  let dynDataCount = (int)(dynEntry.p_filesz) / sizeof(Elf32_Dyn)
  var strtab: ByteAddress = 0
  var strsz: int = 0
  for i in 0..<(int)dynDataCount:
    case dynData[i].d_tag:
    of DT_STRTAB:
      strtab = base + (int)dynData[i].d_un.d_val
    of DT_STRSZ:
      strsz = cast[int](dynData[i].d_un.d_val)
    else: continue
  if strtab == 0 or strsz == 0:
    error "ModLoader", "Couldn't find strtab"
    return @[]
  result = newSeqOfCap[string] 8
  for i in 0..<(int)dynDataCount:
    if dynData[i].d_tag == DT_NEEDED:
      result.add $cast[cstring](strtab + (int)dynData[i].d_un.d_val)

proc loadMulti(file: string, others: var HashSet[string]) =
  others.excl file
  let deps = depCache[file]
  for dep in deps:
    for oth in others:
      if extractFilename(oth) == dep:
        others.excl oth
        loadMulti oth, others
        others.excl oth
        break
  
  notice "ModLoader", "Loading mod: ", file
  let handle = loadMod file
  addHookLibrary (pointer)handle, file
  if handle.isValid:
    mods.add file, handle

proc loadAll*(srcs: seq[string]) =
  if srcs.len == 0: return
  var modsToLoad = initSet[string] 16
  for src in srcs:
    var deps = getModDependencies(src)
    if deps.len > 0:
      depCache.add src, deps.toSet
      modsToLoad.incl src
  let count = modsToLoad.len
  for m in modsToLoad:
    loadMulti m, modsToLoad
  info "ModLoader", "Loaded ", count, " Mod"
  for val in mods.values:
    let exec = cast[proc () {.cdecl.}](val.dlsym "mod_exec")
    if exec != nil:
      exec()

proc notify*(srv: pointer) {.cdecl.} =
  for val in mods.values:
    let set_server = cast[proc (srv: pointer) {.cdecl.}](val.dlsym "mod_set_server")
    if set_server != nil:
      set_server(srv)