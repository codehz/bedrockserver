import logger, posix, strformat, unsafe

var hasCrashed = false

type
  DLInfo {.importcpp:"Dl_info", header:"<hybris/dlfcn.h>".} = object
    dli_sname, dli_fname: cstring
    dli_saddr, dli_fbase: pointer

proc backtrace(buffer: pointer, size: int): int {.importcpp:"backtrace(@)", header:"<execinfo.h>".}
proc backtrace_symbols(buffer: pointer, size: int): cstringArray {.importcpp:"backtrace_symbols(@)", header:"<execinfo.h>".}
proc dladdr(address: pointer, info: ptr DLInfo): bool {.importcpp:"hybris_dladdr(@)".}
proc demangle(name: cstring, outp: pointer, len: ptr int, status: ptr int): pointer {.importcpp:"abi::__cxa_demangle(@)", header:"<cxxabi.h>".}

proc handleSignal(signal: cint, aptr: pointer) {.noconv.} =
  fatal "Signal ", signal, " received"
  if hasCrashed: exitnow 1
  hasCrashed = true
  var xptr = aptr.unsafeAddr
  var arr: array[25, pointer]
  let count = backtrace(arr.addr, 25)
  let symbols = backtrace_symbols(arr.addr, count)
  var nameBuf = cast[ptr array[256, char]](alloc0(256))
  var nameBufLen = 256
  fatal "Backtrace Count: ", count
  for i in 0..<count:
    let item = cast[uint](arr[i])
    let sym = symbols[i]
    if sym == nil:
      fatal fmt"#{i} UNK [0x{item:#08x}]"
      continue
    if sym[0] == '[':
      var symInfo: DLInfo
      if dladdr(arr[i], symInfo.addr):
        var status = 0
        discard demangle(symInfo.dli_sname, nameBuf, nameBufLen.addr, status.addr)
        let dname = cast[cstring](nameBuf)
        let fname = symInfo.dli_fname
        let soff = item - cast[uint](symInfo.dli_saddr)
        let boff = item - cast[uint](symInfo.dli_fbase)
        fatal fmt"#{i} HYB {dname}+{soff:#04x} {fname}+{boff:#04x} [{item:#04x}]"
        continue
    fatal fmt"#{i} {sym}"
  fatal "Dumping stack..."
  for i in 0..<1000:
    let pptr = xptr[]
    let item = cast[uint](pptr)
    var symInfo: DLInfo
    if dladdr(pptr, symInfo.addr) and symInfo.dli_sname != nil and symInfo.dli_sname.len > 0:
      var status = 0
      discard demangle(symInfo.dli_sname, nameBuf, nameBufLen.addr, status.addr)
      let dname = cast[cstring](nameBuf)
      let fname = symInfo.dli_fname
      let soff = item - cast[uint](symInfo.dli_saddr)
      let boff = item - cast[uint](symInfo.dli_fbase)
      fatal fmt"#{i} HYB {dname}+{soff:#04x} {fname}+{boff:#04x} [{item:#04x}]"
    xptr = xptr + 4
  fatal "Quiting..."
  quit 1

var sig = Sigaction(
  sa_handler: cast[proc(x:cint){.noconv.}](handleSignal)
)

discard sigaction(SIGSEGV, sig, nil)
discard sigaction(SIGABRT, sig, nil)
discard sigaction(SIGTRAP, sig, nil)