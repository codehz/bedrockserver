##  This file defines standard ELF types, structures, and macros.
##    Copyright (C) 1995-2014 Free Software Foundation, Inc.
##    This file is part of the GNU C Library.
## 
##    The GNU C Library is free software; you can redistribute it and/or
##    modify it under the terms of the GNU Lesser General Public
##    License as published by the Free Software Foundation; either
##    version 2.1 of the License, or (at your option) any later version.
## 
##    The GNU C Library is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
##    Lesser General Public License for more details.
## 
##    You should have received a copy of the GNU Lesser General Public
##    License along with the GNU C Library; if not, see
##    <http://www.gnu.org/licenses/>.

##  #include <features.h>
##  __BEGIN_DECLS
##  Standard ELF types.

##  Type for a 16-bit quantity.

type
  Elf32_Half* = uint16
  Elf64_Half* = uint16

##  Types for signed and unsigned 32-bit quantities.

type
  Elf32_Word* = uint32
  Elf32_Sword* = int32
  Elf64_Word* = uint32
  Elf64_Sword* = int32

##  Types for signed and unsigned 64-bit quantities.

type
  Elf32_Xword* = uint64
  Elf32_Sxword* = int64
  Elf64_Xword* = uint64
  Elf64_Sxword* = int64

##  Type of addresses.

type
  Elf32_Addr* = uint32
  Elf64_Addr* = uint64

##  Type of file offsets.

type
  Elf32_Off* = uint32
  Elf64_Off* = uint64

##  Type for section indices, which are 16-bit quantities.

type
  Elf32_Section* = uint16
  Elf64_Section* = uint16

##  Type for version symbol information.

type
  Elf32_Versym* = Elf32_Half
  Elf64_Versym* = Elf64_Half

##  The ELF file header.  This appears at the start of every ELF file.

const
  EI_NIDENT* = (16)

type
  Elf32_Ehdr* {.bycopy.} = object
    e_ident*: array[EI_NIDENT, cuchar] ##  Magic number and other info
    e_type*: Elf32_Half        ##  Object file type
    e_machine*: Elf32_Half     ##  Architecture
    e_version*: Elf32_Word     ##  Object file version
    e_entry*: Elf32_Addr       ##  Entry point virtual address
    e_phoff*: Elf32_Off        ##  Program header table file offset
    e_shoff*: Elf32_Off        ##  Section header table file offset
    e_flags*: Elf32_Word       ##  Processor-specific flags
    e_ehsize*: Elf32_Half      ##  ELF header size in bytes
    e_phentsize*: Elf32_Half   ##  Program header table entry size
    e_phnum*: Elf32_Half       ##  Program header table entry count
    e_shentsize*: Elf32_Half   ##  Section header table entry size
    e_shnum*: Elf32_Half       ##  Section header table entry count
    e_shstrndx*: Elf32_Half    ##  Section header string table index
  
  Elf64_Ehdr* {.bycopy.} = object
    e_ident*: array[EI_NIDENT, cuchar] ##  Magic number and other info
    e_type*: Elf64_Half        ##  Object file type
    e_machine*: Elf64_Half     ##  Architecture
    e_version*: Elf64_Word     ##  Object file version
    e_entry*: Elf64_Addr       ##  Entry point virtual address
    e_phoff*: Elf64_Off        ##  Program header table file offset
    e_shoff*: Elf64_Off        ##  Section header table file offset
    e_flags*: Elf64_Word       ##  Processor-specific flags
    e_ehsize*: Elf64_Half      ##  ELF header size in bytes
    e_phentsize*: Elf64_Half   ##  Program header table entry size
    e_phnum*: Elf64_Half       ##  Program header table entry count
    e_shentsize*: Elf64_Half   ##  Section header table entry size
    e_shnum*: Elf64_Half       ##  Section header table entry count
    e_shstrndx*: Elf64_Half    ##  Section header string table index
  

##  Fields in the e_ident array.  The EI_* macros are indices into the
##    array.  The macros under each EI_* macro are the values the byte
##    may have.

const
  EI_MAG0* = 0
  ELFMAG0* = 0x0000007F
  EI_MAG1* = 1
  ELFMAG1* = 'E'
  EI_MAG2* = 2
  ELFMAG2* = 'L'
  EI_MAG3* = 3
  ELFMAG3* = 'F'

##  Conglomeration of the identification bytes, for easy testing as a word.

const
  ELFMAG* = "ELF"
  SELFMAG* = 4
  EI_CLASS* = 4
  ELFCLASSNONE* = 0
  ELFCLASS32* = 1
  ELFCLASS64* = 2
  ELFCLASSNUM* = 3
  EI_DATA* = 5
  ELFDATANONE* = 0
  ELFDATA2LSB* = 1
  ELFDATA2MSB* = 2
  ELFDATANUM* = 3
  EI_VERSION* = 6

##  Value must be EV_CURRENT

const
  EI_OSABI* = 7
  ELFOSABI_NONE* = 0
  ELFOSABI_SYSV* = 0
  ELFOSABI_HPUX* = 1
  ELFOSABI_NETBSD* = 2
  ELFOSABI_GNU* = 3
  ELFOSABI_LINUX* = ELFOSABI_GNU
  ELFOSABI_SOLARIS* = 6
  ELFOSABI_AIX* = 7
  ELFOSABI_IRIX* = 8
  ELFOSABI_FREEBSD* = 9
  ELFOSABI_TRU64* = 10
  ELFOSABI_MODESTO* = 11
  ELFOSABI_OPENBSD* = 12
  ELFOSABI_ARM_AEABI* = 64
  ELFOSABI_ARM* = 97
  ELFOSABI_STANDALONE* = 255
  EI_ABIVERSION* = 8
  EI_PAD* = 9

##  Legal values for e_type (object file type).

const
  ET_NONE* = 0
  ET_REL* = 1
  ET_EXEC* = 2
  ET_DYN* = 3
  ET_CORE* = 4
  ET_NUM* = 5
  ET_LOOS* = 0x0000FE00
  ET_HIOS* = 0x0000FEFF
  ET_LOPROC* = 0x0000FF00
  ET_HIPROC* = 0x0000FFFF

##  Legal values for e_machine (architecture).

const
  EM_NONE* = 0
  EM_M32* = 1
  EM_SPARC* = 2
  EM_386* = 3
  EM_68K* = 4
  EM_88K* = 5
  EM_860* = 7
  EM_MIPS* = 8
  EM_S370* = 9
  EM_MIPS_RS3_LE* = 10
  EM_PARISC* = 15
  EM_VPP500* = 17
  EM_SPARC32PLUS* = 18
  EM_960* = 19
  EM_PPC* = 20
  EM_PPC64* = 21
  EM_S390* = 22
  EM_V800* = 36
  EM_FR20* = 37
  EM_RH32* = 38
  EM_RCE* = 39
  EM_ARM* = 40
  EM_FAKE_ALPHA* = 41
  EM_SH* = 42
  EM_SPARCV9* = 43
  EM_TRICORE* = 44
  EM_ARC* = 45
  EM_H8_300* = 46
  EM_H8_300H* = 47
  EM_H8S* = 48
  EM_H8_500* = 49
  EM_IA_64* = 50
  EM_MIPS_X* = 51
  EM_COLDFIRE* = 52
  EM_68HC12* = 53
  EM_MMA* = 54
  EM_PCP* = 55
  EM_NCPU* = 56
  EM_NDR1* = 57
  EM_STARCORE* = 58
  EM_ME16* = 59
  EM_ST100* = 60
  EM_TINYJ* = 61
  EM_X86_64* = 62
  EM_PDSP* = 63
  EM_FX66* = 66
  EM_ST9PLUS* = 67
  EM_ST7* = 68
  EM_68HC16* = 69
  EM_68HC11* = 70
  EM_68HC08* = 71
  EM_68HC05* = 72
  EM_SVX* = 73
  EM_ST19* = 74
  EM_VAX* = 75
  EM_CRIS* = 76
  EM_JAVELIN* = 77
  EM_FIREPATH* = 78
  EM_ZSP* = 79
  EM_MMIX* = 80
  EM_HUANY* = 81
  EM_PRISM* = 82
  EM_AVR* = 83
  EM_FR30* = 84
  EM_D10V* = 85
  EM_D30V* = 86
  EM_V850* = 87
  EM_M32R* = 88
  EM_MN10300* = 89
  EM_MN10200* = 90
  EM_PJ* = 91
  EM_OPENRISC* = 92
  EM_ARC_A5* = 93
  EM_XTENSA* = 94
  EM_AARCH64* = 183
  EM_TILEPRO* = 188
  EM_MICROBLAZE* = 189
  EM_TILEGX* = 191
  EM_NUM* = 192

##  If it is necessary to assign new unofficial EM_* values, please
##    pick large random numbers (0x8523, 0xa7f2, etc.) to minimize the
##    chances of collision with official or non-GNU unofficial values.

const
  EM_ALPHA* = 0x00009026

##  Legal values for e_version (version).

const
  EV_NONE* = 0
  EV_CURRENT* = 1
  EV_NUM* = 2

##  Section header.

type
  Elf32_Shdr* {.bycopy.} = object
    sh_name*: Elf32_Word       ##  Section name (string tbl index)
    sh_type*: Elf32_Word       ##  Section type
    sh_flags*: Elf32_Word      ##  Section flags
    sh_addr*: Elf32_Addr       ##  Section virtual addr at execution
    sh_offset*: Elf32_Off      ##  Section file offset
    sh_size*: Elf32_Word       ##  Section size in bytes
    sh_link*: Elf32_Word       ##  Link to another section
    sh_info*: Elf32_Word       ##  Additional section information
    sh_addralign*: Elf32_Word  ##  Section alignment
    sh_entsize*: Elf32_Word    ##  Entry size if section holds table
  
  Elf64_Shdr* {.bycopy.} = object
    sh_name*: Elf64_Word       ##  Section name (string tbl index)
    sh_type*: Elf64_Word       ##  Section type
    sh_flags*: Elf64_Xword     ##  Section flags
    sh_addr*: Elf64_Addr       ##  Section virtual addr at execution
    sh_offset*: Elf64_Off      ##  Section file offset
    sh_size*: Elf64_Xword      ##  Section size in bytes
    sh_link*: Elf64_Word       ##  Link to another section
    sh_info*: Elf64_Word       ##  Additional section information
    sh_addralign*: Elf64_Xword ##  Section alignment
    sh_entsize*: Elf64_Xword   ##  Entry size if section holds table
  

##  Special section indices.

const
  SHN_UNDEF* = 0
  SHN_LORESERVE* = 0x0000FF00
  SHN_LOPROC* = 0x0000FF00
  SHN_BEFORE* = 0x0000FF00
  SHN_AFTER* = 0x0000FF01
  SHN_HIPROC* = 0x0000FF1F
  SHN_LOOS* = 0x0000FF20
  SHN_HIOS* = 0x0000FF3F
  SHN_ABS* = 0x0000FFF1
  SHN_COMMON* = 0x0000FFF2
  SHN_XINDEX* = 0x0000FFFF
  SHN_HIRESERVE* = 0x0000FFFF

##  Legal values for sh_type (section type).

const
  SHT_NULL* = 0
  SHT_PROGBITS* = 1
  SHT_SYMTAB* = 2
  SHT_STRTAB* = 3
  SHT_RELA* = 4
  SHT_HASH* = 5
  SHT_DYNAMIC* = 6
  SHT_NOTE* = 7
  SHT_NOBITS* = 8
  SHT_REL* = 9
  SHT_SHLIB* = 10
  SHT_DYNSYM* = 11
  SHT_INIT_ARRAY* = 14
  SHT_FINI_ARRAY* = 15
  SHT_PREINIT_ARRAY* = 16
  SHT_GROUP* = 17
  SHT_SYMTAB_SHNDX* = 18
  SHT_NUM* = 19
  SHT_LOOS* = 0x60000000
  SHT_GNU_ATTRIBUTES* = 0x6FFFFFF5
  SHT_GNU_HASH* = 0x6FFFFFF6
  SHT_GNU_LIBLIST* = 0x6FFFFFF7
  SHT_CHECKSUM* = 0x6FFFFFF8
  SHT_LOSUNW* = 0x6FFFFFFA
  SHT_SUNW_move* = 0x6FFFFFFA
  SHT_SUNW_COMDAT* = 0x6FFFFFFB
  SHT_SUNW_syminfo* = 0x6FFFFFFC
  SHT_GNU_verdef* = 0x6FFFFFFD
  SHT_GNU_verneed* = 0x6FFFFFFE
  SHT_GNU_versym* = 0x6FFFFFFF
  SHT_HISUNW* = 0x6FFFFFFF
  SHT_HIOS* = 0x6FFFFFFF
  SHT_LOPROC* = 0x70000000
  SHT_HIPROC* = 0x7FFFFFFF
  SHT_LOUSER* = 0x80000000
  SHT_HIUSER* = 0x8FFFFFFF

##  Legal values for sh_flags (section flags).

const
  SHF_WRITE* = (1 shl 0)          ##  Writable
  SHF_ALLOC* = (1 shl 1)          ##  Occupies memory during execution
  SHF_EXECINSTR* = (1 shl 2)      ##  Executable
  SHF_MERGE* = (1 shl 4)          ##  Might be merged
  SHF_STRINGS* = (1 shl 5)        ##  Contains nul-terminated strings
  SHF_INFO_LINK* = (1 shl 6)      ##  `sh_info' contains SHT index
  SHF_LINK_ORDER* = (1 shl 7)     ##  Preserve order after combining
  SHF_OS_NONCONFORMING* = (1 shl 8) ##  Non-standard OS specific handling
                               ## 					   required
  SHF_GROUP* = (1 shl 9)          ##  Section is member of a group.
  SHF_TLS* = (1 shl 10)           ##  Section hold thread-local data.
  SHF_MASKOS* = 0x0FF00000
  SHF_MASKPROC* = 0xF0000000
  SHF_ORDERED* = (1 shl 30)       ##  Special ordering requirement
                       ## 					   (Solaris).
  SHF_EXCLUDE* = (1 shl 31)       ##  Section is excluded unless
                       ## 					   referenced or allocated (Solaris).

##  Section group handling.

const
  GRP_COMDAT* = 0x00000001

##  Symbol table entry.

type
  Elf32_Sym* {.bycopy.} = object
    st_name*: Elf32_Word       ##  Symbol name (string tbl index)
    st_value*: Elf32_Addr      ##  Symbol value
    st_size*: Elf32_Word       ##  Symbol size
    st_info*: cuchar           ##  Symbol type and binding
    st_other*: cuchar          ##  Symbol visibility
    st_shndx*: Elf32_Section   ##  Section index
  
  Elf64_Sym* {.bycopy.} = object
    st_name*: Elf64_Word       ##  Symbol name (string tbl index)
    st_info*: cuchar           ##  Symbol type and binding
    st_other*: cuchar          ##  Symbol visibility
    st_shndx*: Elf64_Section   ##  Section index
    st_value*: Elf64_Addr      ##  Symbol value
    st_size*: Elf64_Xword      ##  Symbol size
  

##  The syminfo section if available contains additional information about
##    every dynamic symbol.

type
  Elf32_Syminfo* {.bycopy.} = object
    si_boundto*: Elf32_Half    ##  Direct bindings, symbol bound to
    si_flags*: Elf32_Half      ##  Per symbol flags
  
  Elf64_Syminfo* {.bycopy.} = object
    si_boundto*: Elf64_Half    ##  Direct bindings, symbol bound to
    si_flags*: Elf64_Half      ##  Per symbol flags
  

##  Possible values for si_boundto.

const
  SYMINFO_BT_SELF* = 0x0000FFFF
  SYMINFO_BT_PARENT* = 0x0000FFFE
  SYMINFO_BT_LOWRESERVE* = 0x0000FF00

##  Possible bitmasks for si_flags.

const
  SYMINFO_FLG_DIRECT* = 0x00000001
  SYMINFO_FLG_PASSTHRU* = 0x00000002
  SYMINFO_FLG_COPY* = 0x00000004
  SYMINFO_FLG_LAZYLOAD* = 0x00000008

##  Syminfo version values.

const
  SYMINFO_NONE* = 0
  SYMINFO_CURRENT* = 1
  SYMINFO_NUM* = 2

##  How to extract and insert information held in the st_info field.

template ELF32_ST_BIND*(val: untyped): untyped =
  ((cast[cuchar]((val))) shr 4)

template ELF32_ST_TYPE*(val: untyped): untyped =
  ((val) and 0x0000000F)

template ELF32_ST_INFO*(`bind`, `type`: untyped): untyped =
  (((`bind`) shl 4) + ((`type`) and 0x0000000F))

##  Both Elf32_Sym and Elf64_Sym use the same one-byte st_info field.

template ELF64_ST_BIND*(val: untyped): untyped =
  ELF32_ST_BIND(val)

template ELF64_ST_TYPE*(val: untyped): untyped =
  ELF32_ST_TYPE(val)

template ELF64_ST_INFO*(`bind`, `type`: untyped): untyped =
  ELF32_ST_INFO((`bind`), (`type`))

##  Legal values for ST_BIND subfield of st_info (symbol binding).

const
  STB_LOCAL* = 0
  STB_GLOBAL* = 1
  STB_WEAK* = 2
  STB_NUM* = 3
  STB_LOOS* = 10
  STB_GNU_UNIQUE* = 10
  STB_HIOS* = 12
  STB_LOPROC* = 13
  STB_HIPROC* = 15

##  Legal values for ST_TYPE subfield of st_info (symbol type).

const
  STT_NOTYPE* = 0
  STT_OBJECT* = 1
  STT_FUNC* = 2
  STT_SECTION* = 3
  STT_FILE* = 4
  STT_COMMON* = 5
  STT_TLS* = 6
  STT_NUM* = 7
  STT_LOOS* = 10
  STT_GNU_IFUNC* = 10
  STT_HIOS* = 12
  STT_LOPROC* = 13
  STT_HIPROC* = 15

##  Symbol table indices are found in the hash buckets and chain table
##    of a symbol hash table section.  This special index value indicates
##    the end of a chain, meaning no further symbols are found in that bucket.

const
  STN_UNDEF* = 0

##  How to extract and insert information held in the st_other field.

template ELF32_ST_VISIBILITY*(o: untyped): untyped =
  ((o) and 0x00000003)

##  For ELF64 the definitions are the same.

template ELF64_ST_VISIBILITY*(o: untyped): untyped =
  ELF32_ST_VISIBILITY(o)

##  Symbol visibility specification encoded in the st_other field.

const
  STV_DEFAULT* = 0
  STV_INTERNAL* = 1
  STV_HIDDEN* = 2
  STV_PROTECTED* = 3

##  Relocation table entry without addend (in section of type SHT_REL).

type
  Elf32_Rel* {.bycopy.} = object
    r_offset*: Elf32_Addr      ##  Address
    r_info*: Elf32_Word        ##  Relocation type and symbol index
  

##  I have seen two different definitions of the Elf64_Rel and
##    Elf64_Rela structures, so we'll leave them out until Novell (or
##    whoever) gets their act together.
##  The following, at least, is used on Sparc v9, MIPS, and Alpha.

type
  Elf64_Rel* {.bycopy.} = object
    r_offset*: Elf64_Addr      ##  Address
    r_info*: Elf64_Xword       ##  Relocation type and symbol index
  

##  Relocation table entry with addend (in section of type SHT_RELA).

type
  Elf32_Rela* {.bycopy.} = object
    r_offset*: Elf32_Addr      ##  Address
    r_info*: Elf32_Word        ##  Relocation type and symbol index
    r_addend*: Elf32_Sword     ##  Addend
  
  Elf64_Rela* {.bycopy.} = object
    r_offset*: Elf64_Addr      ##  Address
    r_info*: Elf64_Xword       ##  Relocation type and symbol index
    r_addend*: Elf64_Sxword    ##  Addend
  

##  How to extract and insert information held in the r_info field.

template ELF32_R_SYM*(val: untyped): untyped =
  ((val) shr 8)

template ELF32_R_TYPE*(val: untyped): untyped =
  ((val) and 0x000000FF)

template ELF32_R_INFO*(sym, `type`: untyped): untyped =
  (((sym) shl 8) + ((`type`) and 0x000000FF))

template ELF64_R_SYM*(i: untyped): untyped =
  ((i) shr 32)

template ELF64_R_TYPE*(i: untyped): untyped =
  ((i) and 0xFFFFFFFF)

template ELF64_R_INFO*(sym, `type`: untyped): untyped =
  ((((Elf64_Xword)(sym)) shl 32) + (`type`))

##  Program segment header.

type
  Elf32_Phdr* {.bycopy.} = object
    p_type*: Elf32_Word        ##  Segment type
    p_offset*: Elf32_Off       ##  Segment file offset
    p_vaddr*: Elf32_Addr       ##  Segment virtual address
    p_paddr*: Elf32_Addr       ##  Segment physical address
    p_filesz*: Elf32_Word      ##  Segment size in file
    p_memsz*: Elf32_Word       ##  Segment size in memory
    p_flags*: Elf32_Word       ##  Segment flags
    p_align*: Elf32_Word       ##  Segment alignment
  
  Elf64_Phdr* {.bycopy.} = object
    p_type*: Elf64_Word        ##  Segment type
    p_flags*: Elf64_Word       ##  Segment flags
    p_offset*: Elf64_Off       ##  Segment file offset
    p_vaddr*: Elf64_Addr       ##  Segment virtual address
    p_paddr*: Elf64_Addr       ##  Segment physical address
    p_filesz*: Elf64_Xword     ##  Segment size in file
    p_memsz*: Elf64_Xword      ##  Segment size in memory
    p_align*: Elf64_Xword      ##  Segment alignment
  

##  Special value for e_phnum.  This indicates that the real number of
##    program headers is too large to fit into e_phnum.  Instead the real
##    value is in the field sh_info of section 0.

const
  PN_XNUM* = 0x0000FFFF

##  Legal values for p_type (segment type).

const
  PT_NULL* = 0
  PT_LOAD* = 1
  PT_DYNAMIC* = 2
  PT_INTERP* = 3
  PT_NOTE* = 4
  PT_SHLIB* = 5
  PT_PHDR* = 6
  PT_TLS* = 7
  PT_NUM* = 8
  PT_LOOS* = 0x60000000
  PT_GNU_EH_FRAME* = 0x6474E550
  PT_GNU_STACK* = 0x6474E551
  PT_GNU_RELRO* = 0x6474E552
  PT_LOSUNW* = 0x6FFFFFFA
  PT_SUNWBSS* = 0x6FFFFFFA
  PT_SUNWSTACK* = 0x6FFFFFFB
  PT_HISUNW* = 0x6FFFFFFF
  PT_HIOS* = 0x6FFFFFFF
  PT_LOPROC* = 0x70000000
  PT_HIPROC* = 0x7FFFFFFF

##  Legal values for p_flags (segment flags).

const
  PF_X* = (1 shl 0)               ##  Segment is executable
  PF_W* = (1 shl 1)               ##  Segment is writable
  PF_R* = (1 shl 2)               ##  Segment is readable
  PF_MASKOS* = 0x0FF00000
  PF_MASKPROC* = 0xF0000000

##  Legal values for note segment descriptor types for core files.

const
  NT_PRSTATUS* = 1
  NT_FPREGSET* = 2
  NT_PRPSINFO* = 3
  NT_PRXREG* = 4
  NT_TASKSTRUCT* = 4
  NT_PLATFORM* = 5
  NT_AUXV* = 6
  NT_GWINDOWS* = 7
  NT_ASRS* = 8
  NT_PSTATUS* = 10
  NT_PSINFO* = 13
  NT_PRCRED* = 14
  NT_UTSNAME* = 15
  NT_LWPSTATUS* = 16
  NT_LWPSINFO* = 17
  NT_PRFPXREG* = 20
  NT_SIGINFO* = 0x53494749
  NT_FILE* = 0x46494C45
  NT_PRXFPREG* = 0x46E62B7F
  NT_PPC_VMX* = 0x00000100
  NT_PPC_SPE* = 0x00000101
  NT_PPC_VSX* = 0x00000102
  NT_386_TLS* = 0x00000200
  NT_386_IOPERM* = 0x00000201
  NT_X86_XSTATE* = 0x00000202
  NT_S390_HIGH_GPRS* = 0x00000300
  NT_S390_TIMER* = 0x00000301
  NT_S390_TODCMP* = 0x00000302
  NT_S390_TODPREG* = 0x00000303
  NT_S390_CTRS* = 0x00000304
  NT_S390_PREFIX* = 0x00000305
  NT_S390_LAST_BREAK* = 0x00000306
  NT_S390_SYSTEM_CALL* = 0x00000307
  NT_S390_TDB* = 0x00000308
  NT_ARM_VFP* = 0x00000400
  NT_ARM_TLS* = 0x00000401
  NT_ARM_HW_BREAK* = 0x00000402
  NT_ARM_HW_WATCH* = 0x00000403

##  Legal values for the note segment descriptor types for object files.

const
  NT_VERSION* = 1

##  Dynamic section entry.

type
  INNER_C_UNION_1307210022* {.bycopy.} = object {.union.}
    d_val*: Elf32_Word         ##  Integer value
    d_ptr*: Elf32_Addr         ##  Address value
  
  INNER_C_UNION_2446774312* {.bycopy.} = object {.union.}
    d_val*: Elf64_Xword        ##  Integer value
    d_ptr*: Elf64_Addr         ##  Address value
  
  Elf32_Dyn* {.bycopy.} = object
    d_tag*: Elf32_Sword        ##  Dynamic entry type
    d_un*: INNER_C_UNION_1307210022

  Elf64_Dyn* {.bycopy.} = object
    d_tag*: Elf64_Sxword       ##  Dynamic entry type
    d_un*: INNER_C_UNION_2446774312


##  Legal values for d_tag (dynamic entry type).

const
  DT_NULL* = 0
  DT_NEEDED* = 1
  DT_PLTRELSZ* = 2
  DT_PLTGOT* = 3
  DT_HASH* = 4
  DT_STRTAB* = 5
  DT_SYMTAB* = 6
  DT_RELA* = 7
  DT_RELASZ* = 8
  DT_RELAENT* = 9
  DT_STRSZ* = 10
  DT_SYMENT* = 11
  DT_INIT* = 12
  DT_FINI* = 13
  DT_SONAME* = 14
  DT_RPATH* = 15
  DT_SYMBOLIC* = 16
  DT_REL* = 17
  DT_RELSZ* = 18
  DT_RELENT* = 19
  DT_PLTREL* = 20
  DT_DEBUG* = 21
  DT_TEXTREL* = 22
  DT_JMPREL* = 23
  DT_BIND_NOW* = 24
  DT_INIT_ARRAY* = 25
  DT_FINI_ARRAY* = 26
  DT_INIT_ARRAYSZ* = 27
  DT_FINI_ARRAYSZ* = 28
  DT_RUNPATH* = 29
  DT_FLAGS* = 30
  DT_ENCODING* = 32
  DT_PREINIT_ARRAY* = 32
  DT_PREINIT_ARRAYSZ* = 33
  DT_NUM* = 34
  DT_LOOS* = 0x6000000D
  DT_HIOS* = 0x6FFFF000
  DT_LOPROC* = 0x70000000
  DT_HIPROC* = 0x7FFFFFFF
  DT_PROCNUM* = 0x00000035

##  DT_* entries which fall between DT_VALRNGHI & DT_VALRNGLO use the
##    Dyn.d_un.d_val field of the Elf*_Dyn structure.  This follows Sun's
##    approach.

const
  DT_VALRNGLO* = 0x6FFFFD00
  DT_GNU_PRELINKED* = 0x6FFFFDF5
  DT_GNU_CONFLICTSZ* = 0x6FFFFDF6
  DT_GNU_LIBLISTSZ* = 0x6FFFFDF7
  DT_CHECKSUM* = 0x6FFFFDF8
  DT_PLTPADSZ* = 0x6FFFFDF9
  DT_MOVEENT* = 0x6FFFFDFA
  DT_MOVESZ* = 0x6FFFFDFB
  DT_FEATURE_1* = 0x6FFFFDFC
  DT_POSFLAG_1* = 0x6FFFFDFD
  DT_SYMINSZ* = 0x6FFFFDFE
  DT_SYMINENT* = 0x6FFFFDFF
  DT_VALRNGHI* = 0x6FFFFDFF

template DT_VALTAGIDX*(tag: untyped): untyped =
  (DT_VALRNGHI - (tag))         ##  Reverse order!
  
const
  DT_VALNUM* = 12

##  DT_* entries which fall between DT_ADDRRNGHI & DT_ADDRRNGLO use the
##    Dyn.d_un.d_ptr field of the Elf*_Dyn structure.
## 
##    If any adjustment is made to the ELF object after it has been
##    built these entries will need to be adjusted.

const
  DT_ADDRRNGLO* = 0x6FFFFE00
  DT_GNU_HASH* = 0x6FFFFEF5
  DT_TLSDESC_PLT* = 0x6FFFFEF6
  DT_TLSDESC_GOT* = 0x6FFFFEF7
  DT_GNU_CONFLICT* = 0x6FFFFEF8
  DT_GNU_LIBLIST* = 0x6FFFFEF9
  DT_CONFIG* = 0x6FFFFEFA
  DT_DEPAUDIT* = 0x6FFFFEFB
  DT_AUDIT* = 0x6FFFFEFC
  DT_PLTPAD* = 0x6FFFFEFD
  DT_MOVETAB* = 0x6FFFFEFE
  DT_SYMINFO* = 0x6FFFFEFF
  DT_ADDRRNGHI* = 0x6FFFFEFF

template DT_ADDRTAGIDX*(tag: untyped): untyped =
  (DT_ADDRRNGHI - (tag))        ##  Reverse order!
  
const
  DT_ADDRNUM* = 11

##  The versioning entry types.  The next are defined as part of the
##    GNU extension.

const
  DT_VERSYM* = 0x6FFFFFF0
  DT_RELACOUNT* = 0x6FFFFFF9
  DT_RELCOUNT* = 0x6FFFFFFA

##  These were chosen by Sun.

const
  DT_FLAGS_1* = 0x6FFFFFFB
  DT_VERDEF* = 0x6FFFFFFC
  DT_VERDEFNUM* = 0x6FFFFFFD
  DT_VERNEED* = 0x6FFFFFFE
  DT_VERNEEDNUM* = 0x6FFFFFFF

template DT_VERSIONTAGIDX*(tag: untyped): untyped =
  (DT_VERNEEDNUM - (tag))       ##  Reverse order!
  
const
  DT_VERSIONTAGNUM* = 16

##  Sun added these machine-independent extensions in the "processor-specific"
##    range.  Be compatible.

const
  DT_AUXILIARY* = 0x7FFFFFFD
  DT_FILTER* = 0x7FFFFFFF

template DT_EXTRATAGIDX*(tag: untyped): untyped =
  ((Elf32_Word) - ((Elf32_Sword)(tag) shl 1 shr 1) - 1)

const
  DT_EXTRANUM* = 3

##  Values of `d_un.d_val' in the DT_FLAGS entry.

const
  DF_ORIGIN* = 0x00000001
  DF_SYMBOLIC* = 0x00000002
  DF_TEXTREL* = 0x00000004
  DF_BIND_NOW* = 0x00000008
  DF_STATIC_TLS* = 0x00000010

##  State flags selectable in the `d_un.d_val' element of the DT_FLAGS_1
##    entry in the dynamic section.

const
  DF_1_NOW* = 0x00000001
  DF_1_GLOBAL* = 0x00000002
  DF_1_GROUP* = 0x00000004
  DF_1_NODELETE* = 0x00000008
  DF_1_LOADFLTR* = 0x00000010
  DF_1_INITFIRST* = 0x00000020
  DF_1_NOOPEN* = 0x00000040
  DF_1_ORIGIN* = 0x00000080
  DF_1_DIRECT* = 0x00000100
  DF_1_TRANS* = 0x00000200
  DF_1_INTERPOSE* = 0x00000400
  DF_1_NODEFLIB* = 0x00000800
  DF_1_NODUMP* = 0x00001000
  DF_1_CONFALT* = 0x00002000
  DF_1_ENDFILTEE* = 0x00004000
  DF_1_DISPRELDNE* = 0x00008000
  DF_1_DISPRELPND* = 0x00010000
  DF_1_NODIRECT* = 0x00020000
  DF_1_IGNMULDEF* = 0x00040000
  DF_1_NOKSYMS* = 0x00080000
  DF_1_NOHDR* = 0x00100000
  DF_1_EDITED* = 0x00200000
  DF_1_NORELOC* = 0x00400000
  DF_1_SYMINTPOSE* = 0x00800000
  DF_1_GLOBAUDIT* = 0x01000000
  DF_1_SINGLETON* = 0x02000000

##  Flags for the feature selection in DT_FEATURE_1.

const
  DTF_1_PARINIT* = 0x00000001
  DTF_1_CONFEXP* = 0x00000002

##  Flags in the DT_POSFLAG_1 entry effecting only the next DT_* entry.

const
  DF_P1_LAZYLOAD* = 0x00000001
  DF_P1_GROUPPERM* = 0x00000002

##  Version definition sections.

type
  Elf32_Verdef* {.bycopy.} = object
    vd_version*: Elf32_Half    ##  Version revision
    vd_flags*: Elf32_Half      ##  Version information
    vd_ndx*: Elf32_Half        ##  Version Index
    vd_cnt*: Elf32_Half        ##  Number of associated aux entries
    vd_hash*: Elf32_Word       ##  Version name hash value
    vd_aux*: Elf32_Word        ##  Offset in bytes to verdaux array
    vd_next*: Elf32_Word       ##  Offset in bytes to next verdef
                       ## 					   entry
  
  Elf64_Verdef* {.bycopy.} = object
    vd_version*: Elf64_Half    ##  Version revision
    vd_flags*: Elf64_Half      ##  Version information
    vd_ndx*: Elf64_Half        ##  Version Index
    vd_cnt*: Elf64_Half        ##  Number of associated aux entries
    vd_hash*: Elf64_Word       ##  Version name hash value
    vd_aux*: Elf64_Word        ##  Offset in bytes to verdaux array
    vd_next*: Elf64_Word       ##  Offset in bytes to next verdef
                       ## 					   entry
  

##  Legal values for vd_version (version revision).

const
  VER_DEF_NONE* = 0
  VER_DEF_CURRENT* = 1
  VER_DEF_NUM* = 2

##  Legal values for vd_flags (version information flags).

const
  VER_FLG_BASE* = 0x00000001
  VER_FLG_WEAK* = 0x00000002

##  Versym symbol index values.

const
  VER_NDX_LOCAL* = 0
  VER_NDX_GLOBAL* = 1
  VER_NDX_LORESERVE* = 0x0000FF00
  VER_NDX_ELIMINATE* = 0x0000FF01

##  Auxialiary version information.

type
  Elf32_Verdaux* {.bycopy.} = object
    vda_name*: Elf32_Word      ##  Version or dependency names
    vda_next*: Elf32_Word      ##  Offset in bytes to next verdaux
                        ## 					   entry
  
  Elf64_Verdaux* {.bycopy.} = object
    vda_name*: Elf64_Word      ##  Version or dependency names
    vda_next*: Elf64_Word      ##  Offset in bytes to next verdaux
                        ## 					   entry
  

##  Version dependency section.

type
  Elf32_Verneed* {.bycopy.} = object
    vn_version*: Elf32_Half    ##  Version of structure
    vn_cnt*: Elf32_Half        ##  Number of associated aux entries
    vn_file*: Elf32_Word       ##  Offset of filename for this
                       ## 					   dependency
    vn_aux*: Elf32_Word        ##  Offset in bytes to vernaux array
    vn_next*: Elf32_Word       ##  Offset in bytes to next verneed
                       ## 					   entry
  
  Elf64_Verneed* {.bycopy.} = object
    vn_version*: Elf64_Half    ##  Version of structure
    vn_cnt*: Elf64_Half        ##  Number of associated aux entries
    vn_file*: Elf64_Word       ##  Offset of filename for this
                       ## 					   dependency
    vn_aux*: Elf64_Word        ##  Offset in bytes to vernaux array
    vn_next*: Elf64_Word       ##  Offset in bytes to next verneed
                       ## 					   entry
  

##  Legal values for vn_version (version revision).

const
  VER_NEED_NONE* = 0
  VER_NEED_CURRENT* = 1
  VER_NEED_NUM* = 2

##  Auxiliary needed version information.

type
  Elf32_Vernaux* {.bycopy.} = object
    vna_hash*: Elf32_Word      ##  Hash value of dependency name
    vna_flags*: Elf32_Half     ##  Dependency specific information
    vna_other*: Elf32_Half     ##  Unused
    vna_name*: Elf32_Word      ##  Dependency name string offset
    vna_next*: Elf32_Word      ##  Offset in bytes to next vernaux
                        ## 					   entry
  
  Elf64_Vernaux* {.bycopy.} = object
    vna_hash*: Elf64_Word      ##  Hash value of dependency name
    vna_flags*: Elf64_Half     ##  Dependency specific information
    vna_other*: Elf64_Half     ##  Unused
    vna_name*: Elf64_Word      ##  Dependency name string offset
    vna_next*: Elf64_Word      ##  Offset in bytes to next vernaux
                        ## 					   entry
  

##  Auxiliary vector.
##  This vector is normally only used by the program interpreter.  The
##    usual definition in an ABI supplement uses the name auxv_t.  The
##    vector is not usually defined in a standard <elf.h> file, but it
##    can't hurt.  We rename it to avoid conflicts.  The sizes of these
##    types are an arrangement between the exec server and the program
##    interpreter, so we don't fully specify them here.

type
  INNER_C_UNION_1642644514* {.bycopy.} = object {.union.}
    a_val*: uint32 ##  Integer value
                   ##  We use to have pointer elements added here.  We cannot do that,
                   ## 	 though, since it does not work when using 32-bit definitions
                   ## 	 on 64-bit platforms and vice versa.
  
  INNER_C_UNION_48415905* {.bycopy.} = object {.union.}
    a_val*: uint64 ##  Integer value
                   ##  We use to have pointer elements added here.  We cannot do that,
                   ## 	 though, since it does not work when using 32-bit definitions
                   ## 	 on 64-bit platforms and vice versa.
  
  Elf32_auxv_t* {.bycopy.} = object
    a_type*: uint32          ##  Entry type
    a_un*: INNER_C_UNION_1642644514

  Elf64_auxv_t* {.bycopy.} = object
    a_type*: uint64          ##  Entry type
    a_un*: INNER_C_UNION_48415905


##  #include <bits/auxv.h>
##  Note section contents.  Each entry in the note section begins with
##    a header of a fixed form.

type
  Elf32_Nhdr* {.bycopy.} = object
    n_namesz*: Elf32_Word      ##  Length of the note's name.
    n_descsz*: Elf32_Word      ##  Length of the note's descriptor.
    n_type*: Elf32_Word        ##  Type of the note.
  
  Elf64_Nhdr* {.bycopy.} = object
    n_namesz*: Elf64_Word      ##  Length of the note's name.
    n_descsz*: Elf64_Word      ##  Length of the note's descriptor.
    n_type*: Elf64_Word        ##  Type of the note.
  

##  Known names of notes.
##  Solaris entries in the note section have this name.

const
  ELF_NOTE_SOLARIS* = "SUNW Solaris"

##  Note entries for GNU systems have this name.

const
  ELF_NOTE_GNU* = "GNU"

##  Defined types of notes for Solaris.
##  Value of descriptor (one word) is desired pagesize for the binary.

const
  ELF_NOTE_PAGESIZE_HINT* = 1

##  Defined note types for GNU systems.
##  ABI information.  The descriptor consists of words:
##    word 0: OS descriptor
##    word 1: major version of the ABI
##    word 2: minor version of the ABI
##    word 3: subminor version of the ABI
## 

const
  NT_GNU_ABI_TAG* = 1
  ELF_NOTE_ABI* = NT_GNU_ABI_TAG

##  Known OSes.  These values can appear in word 0 of an
##    NT_GNU_ABI_TAG note section entry.

const
  ELF_NOTE_OS_LINUX* = 0
  ELF_NOTE_OS_GNU* = 1
  ELF_NOTE_OS_SOLARIS2* = 2
  ELF_NOTE_OS_FREEBSD* = 3

##  Synthetic hwcap information.  The descriptor begins with two words:
##    word 0: number of entries
##    word 1: bitmask of enabled entries
##    Then follow variable-length entries, one byte followed by a
##    '\0'-terminated hwcap name string.  The byte gives the bit
##    number to test if enabled, (1U << bit) & bitmask.

const
  NT_GNU_HWCAP* = 2

##  Build ID bits as generated by ld --build-id.
##    The descriptor consists of any nonzero number of bytes.

const
  NT_GNU_BUILD_ID* = 3

##  Version note generated by GNU gold containing a version string.

const
  NT_GNU_GOLD_VERSION* = 4

##  Move records.

type
  Elf32_Move* {.bycopy.} = object
    m_value*: Elf32_Xword      ##  Symbol value.
    m_info*: Elf32_Word        ##  Size and index.
    m_poffset*: Elf32_Word     ##  Symbol offset.
    m_repeat*: Elf32_Half      ##  Repeat count.
    m_stride*: Elf32_Half      ##  Stride info.
  
  Elf64_Move* {.bycopy.} = object
    m_value*: Elf64_Xword      ##  Symbol value.
    m_info*: Elf64_Xword       ##  Size and index.
    m_poffset*: Elf64_Xword    ##  Symbol offset.
    m_repeat*: Elf64_Half      ##  Repeat count.
    m_stride*: Elf64_Half      ##  Stride info.
  

##  Macro to construct move records.

template ELF32_M_SYM*(info: untyped): untyped =
  ((info) shr 8)

template ELF32_M_SIZE*(info: untyped): untyped =
  (cast[cuchar]((info)))

template ELF32_M_INFO*(sym, size: untyped): untyped =
  (((sym) shl 8) + cast[cuchar]((size)))

template ELF64_M_SYM*(info: untyped): untyped =
  ELF32_M_SYM(info)

template ELF64_M_SIZE*(info: untyped): untyped =
  ELF32_M_SIZE(info)

template ELF64_M_INFO*(sym, size: untyped): untyped =
  ELF32_M_INFO(sym, size)

##  Motorola 68k specific definitions.
##  Values for Elf32_Ehdr.e_flags.

const
  EF_CPU32* = 0x00810000

##  m68k relocs.

const
  R_68K_NONE* = 0
  R_68K_32* = 1
  R_68K_16* = 2
  R_68K_8* = 3
  R_68K_PC32* = 4
  R_68K_PC16* = 5
  R_68K_PC8* = 6
  R_68K_GOT32* = 7
  R_68K_GOT16* = 8
  R_68K_GOT8* = 9
  R_68K_GOT32O* = 10
  R_68K_GOT16O* = 11
  R_68K_GOT8O* = 12
  R_68K_PLT32* = 13
  R_68K_PLT16* = 14
  R_68K_PLT8* = 15
  R_68K_PLT32O* = 16
  R_68K_PLT16O* = 17
  R_68K_PLT8O* = 18
  R_68K_COPY* = 19
  R_68K_GLOB_DAT* = 20
  R_68K_JMP_SLOT* = 21
  R_68K_RELATIVE* = 22
  R_68K_TLS_GD32* = 25
  R_68K_TLS_GD16* = 26
  R_68K_TLS_GD8* = 27
  R_68K_TLS_LDM32* = 28
  R_68K_TLS_LDM16* = 29
  R_68K_TLS_LDM8* = 30
  R_68K_TLS_LDO32* = 31
  R_68K_TLS_LDO16* = 32
  R_68K_TLS_LDO8* = 33
  R_68K_TLS_IE32* = 34
  R_68K_TLS_IE16* = 35
  R_68K_TLS_IE8* = 36
  R_68K_TLS_LE32* = 37
  R_68K_TLS_LE16* = 38
  R_68K_TLS_LE8* = 39
  R_68K_TLS_DTPMOD32* = 40
  R_68K_TLS_DTPREL32* = 41
  R_68K_TLS_TPREL32* = 42

##  Keep this the last entry.

const
  R_68K_NUM* = 43

##  Intel 80386 specific definitions.
##  i386 relocs.

const
  R_386_NONE* = 0
  R_386_32* = 1
  R_386_PC32* = 2
  R_386_GOT32* = 3
  R_386_PLT32* = 4
  R_386_COPY* = 5
  R_386_GLOB_DAT* = 6
  R_386_JMP_SLOT* = 7
  R_386_RELATIVE* = 8
  R_386_GOTOFF* = 9
  R_386_GOTPC* = 10
  R_386_32PLT* = 11
  R_386_TLS_TPOFF* = 14
  R_386_TLS_IE* = 15
  R_386_TLS_GOTIE* = 16
  R_386_TLS_LE* = 17
  R_386_TLS_GD* = 18
  R_386_TLS_LDM* = 19
  R_386_16* = 20
  R_386_PC16* = 21
  R_386_8* = 22
  R_386_PC8* = 23
  R_386_TLS_GD_32* = 24
  R_386_TLS_GD_PUSH* = 25
  R_386_TLS_GD_CALL* = 26
  R_386_TLS_GD_POP* = 27
  R_386_TLS_LDM_32* = 28
  R_386_TLS_LDM_PUSH* = 29
  R_386_TLS_LDM_CALL* = 30
  R_386_TLS_LDM_POP* = 31
  R_386_TLS_LDO_32* = 32
  R_386_TLS_IE_32* = 33
  R_386_TLS_LE_32* = 34
  R_386_TLS_DTPMOD32* = 35
  R_386_TLS_DTPOFF32* = 36
  R_386_TLS_TPOFF32* = 37
  R_386_SIZE32* = 38
  R_386_TLS_GOTDESC* = 39
  R_386_TLS_DESC_CALL* = 40
  R_386_TLS_DESC* = 41
  R_386_IRELATIVE* = 42

##  Keep this the last entry.

const
  R_386_NUM* = 43

##  SUN SPARC specific definitions.
##  Legal values for ST_TYPE subfield of st_info (symbol type).

const
  STT_SPARC_REGISTER* = 13

##  Values for Elf64_Ehdr.e_flags.

const
  EF_SPARCV9_MM* = 3
  EF_SPARCV9_TSO* = 0
  EF_SPARCV9_PSO* = 1
  EF_SPARCV9_RMO* = 2
  EF_SPARC_LEDATA* = 0x00800000
  EF_SPARC_EXT_MASK* = 0x00FFFF00
  EF_SPARC_32PLUS* = 0x00000100
  EF_SPARC_SUN_US1* = 0x00000200
  EF_SPARC_HAL_R1* = 0x00000400
  EF_SPARC_SUN_US3* = 0x00000800

##  SPARC relocs.

const
  R_SPARC_NONE* = 0
  R_SPARC_8* = 1
  R_SPARC_16* = 2
  R_SPARC_32* = 3
  R_SPARC_DISP8* = 4
  R_SPARC_DISP16* = 5
  R_SPARC_DISP32* = 6
  R_SPARC_WDISP30* = 7
  R_SPARC_WDISP22* = 8
  R_SPARC_HI22* = 9
  R_SPARC_22* = 10
  R_SPARC_13* = 11
  R_SPARC_LO10* = 12
  R_SPARC_GOT10* = 13
  R_SPARC_GOT13* = 14
  R_SPARC_GOT22* = 15
  R_SPARC_PC10* = 16
  R_SPARC_PC22* = 17
  R_SPARC_WPLT30* = 18
  R_SPARC_COPY* = 19
  R_SPARC_GLOB_DAT* = 20
  R_SPARC_JMP_SLOT* = 21
  R_SPARC_RELATIVE* = 22
  R_SPARC_UA32* = 23

##  Additional Sparc64 relocs.

const
  R_SPARC_PLT32* = 24
  R_SPARC_HIPLT22* = 25
  R_SPARC_LOPLT10* = 26
  R_SPARC_PCPLT32* = 27
  R_SPARC_PCPLT22* = 28
  R_SPARC_PCPLT10* = 29
  R_SPARC_10* = 30
  R_SPARC_11* = 31
  R_SPARC_64* = 32
  R_SPARC_OLO10* = 33
  R_SPARC_HH22* = 34
  R_SPARC_HM10* = 35
  R_SPARC_LM22* = 36
  R_SPARC_PC_HH22* = 37
  R_SPARC_PC_HM10* = 38
  R_SPARC_PC_LM22* = 39
  R_SPARC_WDISP16* = 40
  R_SPARC_WDISP19* = 41
  R_SPARC_GLOB_JMP* = 42
  R_SPARC_7* = 43
  R_SPARC_5* = 44
  R_SPARC_6* = 45
  R_SPARC_DISP64* = 46
  R_SPARC_PLT64* = 47
  R_SPARC_HIX22* = 48
  R_SPARC_LOX10* = 49
  R_SPARC_H44* = 50
  R_SPARC_M44* = 51
  R_SPARC_L44* = 52
  R_SPARC_REGISTER* = 53
  R_SPARC_UA64* = 54
  R_SPARC_UA16* = 55
  R_SPARC_TLS_GD_HI22* = 56
  R_SPARC_TLS_GD_LO10* = 57
  R_SPARC_TLS_GD_ADD* = 58
  R_SPARC_TLS_GD_CALL* = 59
  R_SPARC_TLS_LDM_HI22* = 60
  R_SPARC_TLS_LDM_LO10* = 61
  R_SPARC_TLS_LDM_ADD* = 62
  R_SPARC_TLS_LDM_CALL* = 63
  R_SPARC_TLS_LDO_HIX22* = 64
  R_SPARC_TLS_LDO_LOX10* = 65
  R_SPARC_TLS_LDO_ADD* = 66
  R_SPARC_TLS_IE_HI22* = 67
  R_SPARC_TLS_IE_LO10* = 68
  R_SPARC_TLS_IE_LD* = 69
  R_SPARC_TLS_IE_LDX* = 70
  R_SPARC_TLS_IE_ADD* = 71
  R_SPARC_TLS_LE_HIX22* = 72
  R_SPARC_TLS_LE_LOX10* = 73
  R_SPARC_TLS_DTPMOD32* = 74
  R_SPARC_TLS_DTPMOD64* = 75
  R_SPARC_TLS_DTPOFF32* = 76
  R_SPARC_TLS_DTPOFF64* = 77
  R_SPARC_TLS_TPOFF32* = 78
  R_SPARC_TLS_TPOFF64* = 79
  R_SPARC_GOTDATA_HIX22* = 80
  R_SPARC_GOTDATA_LOX10* = 81
  R_SPARC_GOTDATA_OP_HIX22* = 82
  R_SPARC_GOTDATA_OP_LOX10* = 83
  R_SPARC_GOTDATA_OP* = 84
  R_SPARC_H34* = 85
  R_SPARC_SIZE32* = 86
  R_SPARC_SIZE64* = 87
  R_SPARC_WDISP10* = 88
  R_SPARC_JMP_IREL* = 248
  R_SPARC_IRELATIVE* = 249
  R_SPARC_GNU_VTINHERIT* = 250
  R_SPARC_GNU_VTENTRY* = 251
  R_SPARC_REV32* = 252

##  Keep this the last entry.

const
  R_SPARC_NUM* = 253

##  For Sparc64, legal values for d_tag of Elf64_Dyn.

const
  DT_SPARC_REGISTER* = 0x70000001
  DT_SPARC_NUM* = 2

##  MIPS R3000 specific definitions.
##  Legal values for e_flags field of Elf32_Ehdr.

const
  EF_MIPS_NOREORDER* = 1
  EF_MIPS_PIC* = 2
  EF_MIPS_CPIC* = 4
  EF_MIPS_XGOT* = 8
  EF_MIPS_64BIT_WHIRL* = 16
  EF_MIPS_ABI2* = 32
  EF_MIPS_ABI_ON32* = 64
  EF_MIPS_NAN2008* = 1024
  EF_MIPS_ARCH* = 0xF0000000

##  Legal values for MIPS architecture level.

const
  EF_MIPS_ARCH_1* = 0x00000000
  EF_MIPS_ARCH_2* = 0x10000000
  EF_MIPS_ARCH_3* = 0x20000000
  EF_MIPS_ARCH_4* = 0x30000000
  EF_MIPS_ARCH_5* = 0x40000000
  EF_MIPS_ARCH_32* = 0x50000000
  EF_MIPS_ARCH_64* = 0x60000000
  EF_MIPS_ARCH_32R2* = 0x70000000
  EF_MIPS_ARCH_64R2* = 0x80000000

##  The following are unofficial names and should not be used.

const
  E_MIPS_ARCH_1* = EF_MIPS_ARCH_1
  E_MIPS_ARCH_2* = EF_MIPS_ARCH_2
  E_MIPS_ARCH_3* = EF_MIPS_ARCH_3
  E_MIPS_ARCH_4* = EF_MIPS_ARCH_4
  E_MIPS_ARCH_5* = EF_MIPS_ARCH_5
  E_MIPS_ARCH_32* = EF_MIPS_ARCH_32
  E_MIPS_ARCH_64* = EF_MIPS_ARCH_64

##  Special section indices.

const
  SHN_MIPS_ACOMMON* = 0x0000FF00
  SHN_MIPS_TEXT* = 0x0000FF01
  SHN_MIPS_DATA* = 0x0000FF02
  SHN_MIPS_SCOMMON* = 0x0000FF03
  SHN_MIPS_SUNDEFINED* = 0x0000FF04

##  Legal values for sh_type field of Elf32_Shdr.

const
  SHT_MIPS_LIBLIST* = 0x70000000
  SHT_MIPS_MSYM* = 0x70000001
  SHT_MIPS_CONFLICT* = 0x70000002
  SHT_MIPS_GPTAB* = 0x70000003
  SHT_MIPS_UCODE* = 0x70000004
  SHT_MIPS_DEBUG* = 0x70000005
  SHT_MIPS_REGINFO* = 0x70000006
  SHT_MIPS_PACKAGE* = 0x70000007
  SHT_MIPS_PACKSYM* = 0x70000008
  SHT_MIPS_RELD* = 0x70000009
  SHT_MIPS_IFACE* = 0x7000000B
  SHT_MIPS_CONTENT* = 0x7000000C
  SHT_MIPS_OPTIONS* = 0x7000000D
  SHT_MIPS_SHDR* = 0x70000010
  SHT_MIPS_FDESC* = 0x70000011
  SHT_MIPS_EXTSYM* = 0x70000012
  SHT_MIPS_DENSE* = 0x70000013
  SHT_MIPS_PDESC* = 0x70000014
  SHT_MIPS_LOCSYM* = 0x70000015
  SHT_MIPS_AUXSYM* = 0x70000016
  SHT_MIPS_OPTSYM* = 0x70000017
  SHT_MIPS_LOCSTR* = 0x70000018
  SHT_MIPS_LINE* = 0x70000019
  SHT_MIPS_RFDESC* = 0x7000001A
  SHT_MIPS_DELTASYM* = 0x7000001B
  SHT_MIPS_DELTAINST* = 0x7000001C
  SHT_MIPS_DELTACLASS* = 0x7000001D
  SHT_MIPS_DWARF* = 0x7000001E
  SHT_MIPS_DELTADECL* = 0x7000001F
  SHT_MIPS_SYMBOL_LIB* = 0x70000020
  SHT_MIPS_EVENTS* = 0x70000021
  SHT_MIPS_TRANSLATE* = 0x70000022
  SHT_MIPS_PIXIE* = 0x70000023
  SHT_MIPS_XLATE* = 0x70000024
  SHT_MIPS_XLATE_DEBUG* = 0x70000025
  SHT_MIPS_WHIRL* = 0x70000026
  SHT_MIPS_EH_REGION* = 0x70000027
  SHT_MIPS_XLATE_OLD* = 0x70000028
  SHT_MIPS_PDR_EXCEPTION* = 0x70000029

##  Legal values for sh_flags field of Elf32_Shdr.

const
  SHF_MIPS_GPREL* = 0x10000000
  SHF_MIPS_MERGE* = 0x20000000
  SHF_MIPS_ADDR* = 0x40000000
  SHF_MIPS_STRINGS* = 0x80000000
  SHF_MIPS_NOSTRIP* = 0x08000000
  SHF_MIPS_LOCAL* = 0x04000000
  SHF_MIPS_NAMES* = 0x02000000
  SHF_MIPS_NODUPE* = 0x01000000

##  Symbol tables.
##  MIPS specific values for `st_other'.

const
  STO_MIPS_DEFAULT* = 0x00000000
  STO_MIPS_INTERNAL* = 0x00000001
  STO_MIPS_HIDDEN* = 0x00000002
  STO_MIPS_PROTECTED* = 0x00000003
  STO_MIPS_PLT* = 0x00000008
  STO_MIPS_SC_ALIGN_UNUSED* = 0x000000FF

##  MIPS specific values for `st_info'.

const
  STB_MIPS_SPLIT_COMMON* = 13

##  Entries found in sections of type SHT_MIPS_GPTAB.

type
  INNER_C_STRUCT_1620654567* {.bycopy.} = object
    gt_current_g_value*: Elf32_Word ##  -G value used for compilation.
    gt_unused*: Elf32_Word     ##  Not used.
  
  INNER_C_STRUCT_1228623266* {.bycopy.} = object
    gt_g_value*: Elf32_Word    ##  If this value were used for -G.
    gt_bytes*: Elf32_Word      ##  This many bytes would be used.
  
  Elf32_gptab* {.bycopy.} = object {.union.}
    gt_header*: INNER_C_STRUCT_1620654567 ##  First entry in section.
    gt_entry*: INNER_C_STRUCT_1228623266 ##  Subsequent entries in section.
  

##  Entry found in sections of type SHT_MIPS_REGINFO.

type
  Elf32_RegInfo* {.bycopy.} = object
    ri_gprmask*: Elf32_Word    ##  General registers used.
    ri_cprmask*: array[4, Elf32_Word] ##  Coprocessor registers used.
    ri_gp_value*: Elf32_Sword  ##  $gp register value.
  

##  Entries found in sections of type SHT_MIPS_OPTIONS.

type
  Elf_Options* {.bycopy.} = object
    kind*: cuchar              ##  Determines interpretation of the
                ## 				   variable part of descriptor.
    size*: cuchar              ##  Size of descriptor, including header.
    section*: Elf32_Section    ##  Section header index of section affected,
                          ## 				   0 for global options.
    info*: Elf32_Word          ##  Kind-specific information.
  

##  Values for `kind' field in Elf_Options.

const
  ODK_NULL* = 0
  ODK_REGINFO* = 1
  ODK_EXCEPTIONS* = 2
  ODK_PAD* = 3
  ODK_HWPATCH* = 4
  ODK_FILL* = 5
  ODK_TAGS* = 6
  ODK_HWAND* = 7
  ODK_HWOR* = 8

##  Values for `info' in Elf_Options for ODK_EXCEPTIONS entries.

const
  OEX_FPU_MIN* = 0x0000001F
  OEX_FPU_MAX* = 0x00001F00
  OEX_PAGE0* = 0x00010000
  OEX_SMM* = 0x00020000
  OEX_FPDBUG* = 0x00040000
  OEX_PRECISEFP* = OEX_FPDBUG
  OEX_DISMISS* = 0x00080000
  OEX_FPU_INVAL* = 0x00000010
  OEX_FPU_DIV0* = 0x00000008
  OEX_FPU_OFLO* = 0x00000004
  OEX_FPU_UFLO* = 0x00000002
  OEX_FPU_INEX* = 0x00000001

##  Masks for `info' in Elf_Options for an ODK_HWPATCH entry.

const
  OHW_R4KEOP* = 0x00000001
  OHW_R8KPFETCH* = 0x00000002
  OHW_R5KEOP* = 0x00000004
  OHW_R5KCVTL* = 0x00000008
  OPAD_PREFIX* = 0x00000001
  OPAD_POSTFIX* = 0x00000002
  OPAD_SYMBOL* = 0x00000004

##  Entry found in `.options' section.

type
  Elf_Options_Hw* {.bycopy.} = object
    hwp_flags1*: Elf32_Word    ##  Extra flags.
    hwp_flags2*: Elf32_Word    ##  Extra flags.
  

##  Masks for `info' in ElfOptions for ODK_HWAND and ODK_HWOR entries.

const
  OHWA0_R4KEOP_CHECKED* = 0x00000001
  OHWA1_R4KEOP_CLEAN* = 0x00000002

##  MIPS relocs.

const
  R_MIPS_NONE* = 0
  R_MIPS_16* = 1
  R_MIPS_32* = 2
  R_MIPS_REL32* = 3
  R_MIPS_26* = 4
  R_MIPS_HI16* = 5
  R_MIPS_LO16* = 6
  R_MIPS_GPREL16* = 7
  R_MIPS_LITERAL* = 8
  R_MIPS_GOT16* = 9
  R_MIPS_PC16* = 10
  R_MIPS_CALL16* = 11
  R_MIPS_GPREL32* = 12
  R_MIPS_SHIFT5* = 16
  R_MIPS_SHIFT6* = 17
  R_MIPS_64* = 18
  R_MIPS_GOT_DISP* = 19
  R_MIPS_GOT_PAGE* = 20
  R_MIPS_GOT_OFST* = 21
  R_MIPS_GOT_HI16* = 22
  R_MIPS_GOT_LO16* = 23
  R_MIPS_SUB* = 24
  R_MIPS_INSERT_A* = 25
  R_MIPS_INSERT_B* = 26
  R_MIPS_DELETE* = 27
  R_MIPS_HIGHER* = 28
  R_MIPS_HIGHEST* = 29
  R_MIPS_CALL_HI16* = 30
  R_MIPS_CALL_LO16* = 31
  R_MIPS_SCN_DISP* = 32
  R_MIPS_REL16* = 33
  R_MIPS_ADD_IMMEDIATE* = 34
  R_MIPS_PJUMP* = 35
  R_MIPS_RELGOT* = 36
  R_MIPS_JALR* = 37
  R_MIPS_TLS_DTPMOD32* = 38
  R_MIPS_TLS_DTPREL32* = 39
  R_MIPS_TLS_DTPMOD64* = 40
  R_MIPS_TLS_DTPREL64* = 41
  R_MIPS_TLS_GD* = 42
  R_MIPS_TLS_LDM* = 43
  R_MIPS_TLS_DTPREL_HI16* = 44
  R_MIPS_TLS_DTPREL_LO16* = 45
  R_MIPS_TLS_GOTTPREL* = 46
  R_MIPS_TLS_TPREL32* = 47
  R_MIPS_TLS_TPREL64* = 48
  R_MIPS_TLS_TPREL_HI16* = 49
  R_MIPS_TLS_TPREL_LO16* = 50
  R_MIPS_GLOB_DAT* = 51
  R_MIPS_COPY* = 126
  R_MIPS_JUMP_SLOT* = 127

##  Keep this the last entry.

const
  R_MIPS_NUM* = 128

##  Legal values for p_type field of Elf32_Phdr.

const
  PT_MIPS_REGINFO* = 0x70000000
  PT_MIPS_RTPROC* = 0x70000001
  PT_MIPS_OPTIONS* = 0x70000002

##  Special program header types.

const
  PF_MIPS_LOCAL* = 0x10000000

##  Legal values for d_tag field of Elf32_Dyn.

const
  DT_MIPS_RLD_VERSION* = 0x70000001
  DT_MIPS_TIME_STAMP* = 0x70000002
  DT_MIPS_ICHECKSUM* = 0x70000003
  DT_MIPS_IVERSION* = 0x70000004
  DT_MIPS_FLAGS* = 0x70000005
  DT_MIPS_BASE_ADDRESS* = 0x70000006
  DT_MIPS_MSYM* = 0x70000007
  DT_MIPS_CONFLICT* = 0x70000008
  DT_MIPS_LIBLIST* = 0x70000009
  DT_MIPS_LOCAL_GOTNO* = 0x7000000A
  DT_MIPS_CONFLICTNO* = 0x7000000B
  DT_MIPS_LIBLISTNO* = 0x70000010
  DT_MIPS_SYMTABNO* = 0x70000011
  DT_MIPS_UNREFEXTNO* = 0x70000012
  DT_MIPS_GOTSYM* = 0x70000013
  DT_MIPS_HIPAGENO* = 0x70000014
  DT_MIPS_RLD_MAP* = 0x70000016
  DT_MIPS_DELTA_CLASS* = 0x70000017
  DT_MIPS_DELTA_CLASS_NO* = 0x70000018
  DT_MIPS_DELTA_INSTANCE* = 0x70000019
  DT_MIPS_DELTA_INSTANCE_NO* = 0x7000001A
  DT_MIPS_DELTA_RELOC* = 0x7000001B
  DT_MIPS_DELTA_RELOC_NO* = 0x7000001C
  DT_MIPS_DELTA_SYM* = 0x7000001D
  DT_MIPS_DELTA_SYM_NO* = 0x7000001E
  DT_MIPS_DELTA_CLASSSYM* = 0x70000020
  DT_MIPS_DELTA_CLASSSYM_NO* = 0x70000021
  DT_MIPS_CXX_FLAGS* = 0x70000022
  DT_MIPS_PIXIE_INIT* = 0x70000023
  DT_MIPS_SYMBOL_LIB* = 0x70000024
  DT_MIPS_LOCALPAGE_GOTIDX* = 0x70000025
  DT_MIPS_LOCAL_GOTIDX* = 0x70000026
  DT_MIPS_HIDDEN_GOTIDX* = 0x70000027
  DT_MIPS_PROTECTED_GOTIDX* = 0x70000028
  DT_MIPS_OPTIONS* = 0x70000029
  DT_MIPS_INTERFACE* = 0x7000002A
  DT_MIPS_DYNSTR_ALIGN* = 0x7000002B
  DT_MIPS_INTERFACE_SIZE* = 0x7000002C
  DT_MIPS_RLD_TEXT_RESOLVE_ADDR* = 0x7000002D
  DT_MIPS_PERF_SUFFIX* = 0x7000002E
  DT_MIPS_COMPACT_SIZE* = 0x7000002F
  DT_MIPS_GP_VALUE* = 0x70000030
  DT_MIPS_AUX_DYNAMIC* = 0x70000031

##  The address of .got.plt in an executable using the new non-PIC ABI.

const
  DT_MIPS_PLTGOT* = 0x70000032

##  The base of the PLT in an executable using the new non-PIC ABI if that
##    PLT is writable.  For a non-writable PLT, this is omitted or has a zero
##    value.

const
  DT_MIPS_RWPLT* = 0x70000034
  DT_MIPS_NUM* = 0x00000035

##  Legal values for DT_MIPS_FLAGS Elf32_Dyn entry.

const
  RHF_NONE* = 0
  RHF_QUICKSTART* = (1 shl 0)     ##  Use quickstart
  RHF_NOTPOT* = (1 shl 1)         ##  Hash size not power of 2
  RHF_NO_LIBRARY_REPLACEMENT* = (1 shl 2) ##  Ignore LD_LIBRARY_PATH
  RHF_NO_MOVE* = (1 shl 3)
  RHF_SGI_ONLY* = (1 shl 4)
  RHF_GUARANTEE_INIT* = (1 shl 5)
  RHF_DELTA_C_PLUS_PLUS* = (1 shl 6)
  RHF_GUARANTEE_START_INIT* = (1 shl 7)
  RHF_PIXIE* = (1 shl 8)
  RHF_DEFAULT_DELAY_LOAD* = (1 shl 9)
  RHF_REQUICKSTART* = (1 shl 10)
  RHF_REQUICKSTARTED* = (1 shl 11)
  RHF_CORD* = (1 shl 12)
  RHF_NO_UNRES_UNDEF* = (1 shl 13)
  RHF_RLD_ORDER_SAFE* = (1 shl 14)

##  Entries found in sections of type SHT_MIPS_LIBLIST.

type
  Elf32_Lib* {.bycopy.} = object
    l_name*: Elf32_Word        ##  Name (string table index)
    l_time_stamp*: Elf32_Word  ##  Timestamp
    l_checksum*: Elf32_Word    ##  Checksum
    l_version*: Elf32_Word     ##  Interface version
    l_flags*: Elf32_Word       ##  Flags
  
  Elf64_Lib* {.bycopy.} = object
    l_name*: Elf64_Word        ##  Name (string table index)
    l_time_stamp*: Elf64_Word  ##  Timestamp
    l_checksum*: Elf64_Word    ##  Checksum
    l_version*: Elf64_Word     ##  Interface version
    l_flags*: Elf64_Word       ##  Flags
  

##  Legal values for l_flags.

const
  LL_NONE* = 0
  LL_EXACT_MATCH* = (1 shl 0)     ##  Require exact match
  LL_IGNORE_INT_VER* = (1 shl 1)  ##  Ignore interface version
  LL_REQUIRE_MINOR* = (1 shl 2)
  LL_EXPORTS* = (1 shl 3)
  LL_DELAY_LOAD* = (1 shl 4)
  LL_DELTA* = (1 shl 5)

##  Entries found in sections of type SHT_MIPS_CONFLICT.

type
  Elf32_Conflict* = Elf32_Addr

##  HPPA specific definitions.
##  Legal values for e_flags field of Elf32_Ehdr.

const
  EF_PARISC_TRAPNIL* = 0x00010000
  EF_PARISC_EXT* = 0x00020000
  EF_PARISC_LSB* = 0x00040000
  EF_PARISC_WIDE* = 0x00080000
  EF_PARISC_NO_KABP* = 0x00100000
  EF_PARISC_LAZYSWAP* = 0x00400000
  EF_PARISC_ARCH* = 0x0000FFFF

##  Defined values for `e_flags & EF_PARISC_ARCH' are:

const
  EFA_PARISC_1_0* = 0x0000020B
  EFA_PARISC_1_1* = 0x00000210
  EFA_PARISC_2_0* = 0x00000214

##  Additional section indeces.

const
  SHN_PARISC_ANSI_COMMON* = 0x0000FF00
  SHN_PARISC_HUGE_COMMON* = 0x0000FF01

##  Legal values for sh_type field of Elf32_Shdr.

const
  SHT_PARISC_EXT* = 0x70000000
  SHT_PARISC_UNWIND* = 0x70000001
  SHT_PARISC_DOC* = 0x70000002

##  Legal values for sh_flags field of Elf32_Shdr.

const
  SHF_PARISC_SHORT* = 0x20000000
  SHF_PARISC_HUGE* = 0x40000000
  SHF_PARISC_SBP* = 0x80000000

##  Legal values for ST_TYPE subfield of st_info (symbol type).

const
  STT_PARISC_MILLICODE* = 13
  STT_HP_OPAQUE* = (STT_LOOS + 0x00000001)
  STT_HP_STUB* = (STT_LOOS + 0x00000002)

##  HPPA relocs.

const
  R_PARISC_NONE* = 0
  R_PARISC_DIR32* = 1
  R_PARISC_DIR21L* = 2
  R_PARISC_DIR17R* = 3
  R_PARISC_DIR17F* = 4
  R_PARISC_DIR14R* = 6
  R_PARISC_PCREL32* = 9
  R_PARISC_PCREL21L* = 10
  R_PARISC_PCREL17R* = 11
  R_PARISC_PCREL17F* = 12
  R_PARISC_PCREL14R* = 14
  R_PARISC_DPREL21L* = 18
  R_PARISC_DPREL14R* = 22
  R_PARISC_GPREL21L* = 26
  R_PARISC_GPREL14R* = 30
  R_PARISC_LTOFF21L* = 34
  R_PARISC_LTOFF14R* = 38
  R_PARISC_SECREL32* = 41
  R_PARISC_SEGBASE* = 48
  R_PARISC_SEGREL32* = 49
  R_PARISC_PLTOFF21L* = 50
  R_PARISC_PLTOFF14R* = 54
  R_PARISC_LTOFF_FPTR32* = 57
  R_PARISC_LTOFF_FPTR21L* = 58
  R_PARISC_LTOFF_FPTR14R* = 62
  R_PARISC_FPTR64* = 64
  R_PARISC_PLABEL32* = 65
  R_PARISC_PLABEL21L* = 66
  R_PARISC_PLABEL14R* = 70
  R_PARISC_PCREL64* = 72
  R_PARISC_PCREL22F* = 74
  R_PARISC_PCREL14WR* = 75
  R_PARISC_PCREL14DR* = 76
  R_PARISC_PCREL16F* = 77
  R_PARISC_PCREL16WF* = 78
  R_PARISC_PCREL16DF* = 79
  R_PARISC_DIR64* = 80
  R_PARISC_DIR14WR* = 83
  R_PARISC_DIR14DR* = 84
  R_PARISC_DIR16F* = 85
  R_PARISC_DIR16WF* = 86
  R_PARISC_DIR16DF* = 87
  R_PARISC_GPREL64* = 88
  R_PARISC_GPREL14WR* = 91
  R_PARISC_GPREL14DR* = 92
  R_PARISC_GPREL16F* = 93
  R_PARISC_GPREL16WF* = 94
  R_PARISC_GPREL16DF* = 95
  R_PARISC_LTOFF64* = 96
  R_PARISC_LTOFF14WR* = 99
  R_PARISC_LTOFF14DR* = 100
  R_PARISC_LTOFF16F* = 101
  R_PARISC_LTOFF16WF* = 102
  R_PARISC_LTOFF16DF* = 103
  R_PARISC_SECREL64* = 104
  R_PARISC_SEGREL64* = 112
  R_PARISC_PLTOFF14WR* = 115
  R_PARISC_PLTOFF14DR* = 116
  R_PARISC_PLTOFF16F* = 117
  R_PARISC_PLTOFF16WF* = 118
  R_PARISC_PLTOFF16DF* = 119
  R_PARISC_LTOFF_FPTR64* = 120
  R_PARISC_LTOFF_FPTR14WR* = 123
  R_PARISC_LTOFF_FPTR14DR* = 124
  R_PARISC_LTOFF_FPTR16F* = 125
  R_PARISC_LTOFF_FPTR16WF* = 126
  R_PARISC_LTOFF_FPTR16DF* = 127
  R_PARISC_LORESERVE* = 128
  R_PARISC_COPY* = 128
  R_PARISC_IPLT* = 129
  R_PARISC_EPLT* = 130
  R_PARISC_TPREL32* = 153
  R_PARISC_TPREL21L* = 154
  R_PARISC_TPREL14R* = 158
  R_PARISC_LTOFF_TP21L* = 162
  R_PARISC_LTOFF_TP14R* = 166
  R_PARISC_LTOFF_TP14F* = 167
  R_PARISC_TPREL64* = 216
  R_PARISC_TPREL14WR* = 219
  R_PARISC_TPREL14DR* = 220
  R_PARISC_TPREL16F* = 221
  R_PARISC_TPREL16WF* = 222
  R_PARISC_TPREL16DF* = 223
  R_PARISC_LTOFF_TP64* = 224
  R_PARISC_LTOFF_TP14WR* = 227
  R_PARISC_LTOFF_TP14DR* = 228
  R_PARISC_LTOFF_TP16F* = 229
  R_PARISC_LTOFF_TP16WF* = 230
  R_PARISC_LTOFF_TP16DF* = 231
  R_PARISC_GNU_VTENTRY* = 232
  R_PARISC_GNU_VTINHERIT* = 233
  R_PARISC_TLS_GD21L* = 234
  R_PARISC_TLS_GD14R* = 235
  R_PARISC_TLS_GDCALL* = 236
  R_PARISC_TLS_LDM21L* = 237
  R_PARISC_TLS_LDM14R* = 238
  R_PARISC_TLS_LDMCALL* = 239
  R_PARISC_TLS_LDO21L* = 240
  R_PARISC_TLS_LDO14R* = 241
  R_PARISC_TLS_DTPMOD32* = 242
  R_PARISC_TLS_DTPMOD64* = 243
  R_PARISC_TLS_DTPOFF32* = 244
  R_PARISC_TLS_DTPOFF64* = 245
  R_PARISC_TLS_LE21L* = R_PARISC_TPREL21L
  R_PARISC_TLS_LE14R* = R_PARISC_TPREL14R
  R_PARISC_TLS_IE21L* = R_PARISC_LTOFF_TP21L
  R_PARISC_TLS_IE14R* = R_PARISC_LTOFF_TP14R
  R_PARISC_TLS_TPREL32* = R_PARISC_TPREL32
  R_PARISC_TLS_TPREL64* = R_PARISC_TPREL64
  R_PARISC_HIRESERVE* = 255

##  Legal values for p_type field of Elf32_Phdr/Elf64_Phdr.

const
  PT_HP_TLS* = (PT_LOOS + 0x00000000)
  PT_HP_CORE_NONE* = (PT_LOOS + 0x00000001)
  PT_HP_CORE_VERSION* = (PT_LOOS + 0x00000002)
  PT_HP_CORE_KERNEL* = (PT_LOOS + 0x00000003)
  PT_HP_CORE_COMM* = (PT_LOOS + 0x00000004)
  PT_HP_CORE_PROC* = (PT_LOOS + 0x00000005)
  PT_HP_CORE_LOADABLE* = (PT_LOOS + 0x00000006)
  PT_HP_CORE_STACK* = (PT_LOOS + 0x00000007)
  PT_HP_CORE_SHM* = (PT_LOOS + 0x00000008)
  PT_HP_CORE_MMF* = (PT_LOOS + 0x00000009)
  PT_HP_PARALLEL* = (PT_LOOS + 0x00000010)
  PT_HP_FASTBIND* = (PT_LOOS + 0x00000011)
  PT_HP_OPT_ANNOT* = (PT_LOOS + 0x00000012)
  PT_HP_HSL_ANNOT* = (PT_LOOS + 0x00000013)
  PT_HP_STACK* = (PT_LOOS + 0x00000014)
  PT_PARISC_ARCHEXT* = 0x70000000
  PT_PARISC_UNWIND* = 0x70000001

##  Legal values for p_flags field of Elf32_Phdr/Elf64_Phdr.

const
  PF_PARISC_SBP* = 0x08000000
  PF_HP_PAGE_SIZE* = 0x00100000
  PF_HP_FAR_SHARED* = 0x00200000
  PF_HP_NEAR_SHARED* = 0x00400000
  PF_HP_CODE* = 0x01000000
  PF_HP_MODIFY* = 0x02000000
  PF_HP_LAZYSWAP* = 0x04000000
  PF_HP_SBP* = 0x08000000

##  Alpha specific definitions.
##  Legal values for e_flags field of Elf64_Ehdr.

const
  EF_ALPHA_32BIT* = 1
  EF_ALPHA_CANRELAX* = 2

##  Legal values for sh_type field of Elf64_Shdr.
##  These two are primerily concerned with ECOFF debugging info.

const
  SHT_ALPHA_DEBUG* = 0x70000001
  SHT_ALPHA_REGINFO* = 0x70000002

##  Legal values for sh_flags field of Elf64_Shdr.

const
  SHF_ALPHA_GPREL* = 0x10000000

##  Legal values for st_other field of Elf64_Sym.

const
  STO_ALPHA_NOPV* = 0x00000080
  STO_ALPHA_STD_GPLOAD* = 0x00000088

##  Alpha relocs.

const
  R_ALPHA_NONE* = 0
  R_ALPHA_REFLONG* = 1
  R_ALPHA_REFQUAD* = 2
  R_ALPHA_GPREL32* = 3
  R_ALPHA_LITERAL* = 4
  R_ALPHA_LITUSE* = 5
  R_ALPHA_GPDISP* = 6
  R_ALPHA_BRADDR* = 7
  R_ALPHA_HINT* = 8
  R_ALPHA_SREL16* = 9
  R_ALPHA_SREL32* = 10
  R_ALPHA_SREL64* = 11
  R_ALPHA_GPRELHIGH* = 17
  R_ALPHA_GPRELLOW* = 18
  R_ALPHA_GPREL16* = 19
  R_ALPHA_COPY* = 24
  R_ALPHA_GLOB_DAT* = 25
  R_ALPHA_JMP_SLOT* = 26
  R_ALPHA_RELATIVE* = 27
  R_ALPHA_TLS_GD_HI* = 28
  R_ALPHA_TLSGD* = 29
  R_ALPHA_TLS_LDM* = 30
  R_ALPHA_DTPMOD64* = 31
  R_ALPHA_GOTDTPREL* = 32
  R_ALPHA_DTPREL64* = 33
  R_ALPHA_DTPRELHI* = 34
  R_ALPHA_DTPRELLO* = 35
  R_ALPHA_DTPREL16* = 36
  R_ALPHA_GOTTPREL* = 37
  R_ALPHA_TPREL64* = 38
  R_ALPHA_TPRELHI* = 39
  R_ALPHA_TPRELLO* = 40
  R_ALPHA_TPREL16* = 41

##  Keep this the last entry.

const
  R_ALPHA_NUM* = 46

##  Magic values of the LITUSE relocation addend.

const
  LITUSE_ALPHA_ADDR* = 0
  LITUSE_ALPHA_BASE* = 1
  LITUSE_ALPHA_BYTOFF* = 2
  LITUSE_ALPHA_JSR* = 3
  LITUSE_ALPHA_TLS_GD* = 4
  LITUSE_ALPHA_TLS_LDM* = 5

##  Legal values for d_tag of Elf64_Dyn.

const
  DT_ALPHA_PLTRO* = (DT_LOPROC + 0)
  DT_ALPHA_NUM* = 1

##  PowerPC specific declarations
##  Values for Elf32/64_Ehdr.e_flags.

const
  EF_PPC_EMB* = 0x80000000

##  Cygnus local bits below

const
  EF_PPC_RELOCATABLE* = 0x00010000
  EF_PPC_RELOCATABLE_LIB* = 0x00008000

##  PowerPC relocations defined by the ABIs

const
  R_PPC_NONE* = 0
  R_PPC_ADDR32* = 1
  R_PPC_ADDR24* = 2
  R_PPC_ADDR16* = 3
  R_PPC_ADDR16_LO* = 4
  R_PPC_ADDR16_HI* = 5
  R_PPC_ADDR16_HA* = 6
  R_PPC_ADDR14* = 7
  R_PPC_ADDR14_BRTAKEN* = 8
  R_PPC_ADDR14_BRNTAKEN* = 9
  R_PPC_REL24* = 10
  R_PPC_REL14* = 11
  R_PPC_REL14_BRTAKEN* = 12
  R_PPC_REL14_BRNTAKEN* = 13
  R_PPC_GOT16* = 14
  R_PPC_GOT16_LO* = 15
  R_PPC_GOT16_HI* = 16
  R_PPC_GOT16_HA* = 17
  R_PPC_PLTREL24* = 18
  R_PPC_COPY* = 19
  R_PPC_GLOB_DAT* = 20
  R_PPC_JMP_SLOT* = 21
  R_PPC_RELATIVE* = 22
  R_PPC_LOCAL24PC* = 23
  R_PPC_UADDR32* = 24
  R_PPC_UADDR16* = 25
  R_PPC_REL32* = 26
  R_PPC_PLT32* = 27
  R_PPC_PLTREL32* = 28
  R_PPC_PLT16_LO* = 29
  R_PPC_PLT16_HI* = 30
  R_PPC_PLT16_HA* = 31
  R_PPC_SDAREL16* = 32
  R_PPC_SECTOFF* = 33
  R_PPC_SECTOFF_LO* = 34
  R_PPC_SECTOFF_HI* = 35
  R_PPC_SECTOFF_HA* = 36

##  PowerPC relocations defined for the TLS access ABI.

const
  R_PPC_TLS* = 67
  R_PPC_DTPMOD32* = 68
  R_PPC_TPREL16* = 69
  R_PPC_TPREL16_LO* = 70
  R_PPC_TPREL16_HI* = 71
  R_PPC_TPREL16_HA* = 72
  R_PPC_TPREL32* = 73
  R_PPC_DTPREL16* = 74
  R_PPC_DTPREL16_LO* = 75
  R_PPC_DTPREL16_HI* = 76
  R_PPC_DTPREL16_HA* = 77
  R_PPC_DTPREL32* = 78
  R_PPC_GOT_TLSGD16* = 79
  R_PPC_GOT_TLSGD16_LO* = 80
  R_PPC_GOT_TLSGD16_HI* = 81
  R_PPC_GOT_TLSGD16_HA* = 82
  R_PPC_GOT_TLSLD16* = 83
  R_PPC_GOT_TLSLD16_LO* = 84
  R_PPC_GOT_TLSLD16_HI* = 85
  R_PPC_GOT_TLSLD16_HA* = 86
  R_PPC_GOT_TPREL16* = 87
  R_PPC_GOT_TPREL16_LO* = 88
  R_PPC_GOT_TPREL16_HI* = 89
  R_PPC_GOT_TPREL16_HA* = 90
  R_PPC_GOT_DTPREL16* = 91
  R_PPC_GOT_DTPREL16_LO* = 92
  R_PPC_GOT_DTPREL16_HI* = 93
  R_PPC_GOT_DTPREL16_HA* = 94

##  The remaining relocs are from the Embedded ELF ABI, and are not
##    in the SVR4 ELF ABI.

const
  R_PPC_EMB_NADDR32* = 101
  R_PPC_EMB_NADDR16* = 102
  R_PPC_EMB_NADDR16_LO* = 103
  R_PPC_EMB_NADDR16_HI* = 104
  R_PPC_EMB_NADDR16_HA* = 105
  R_PPC_EMB_SDAI16* = 106
  R_PPC_EMB_SDA2I16* = 107
  R_PPC_EMB_SDA2REL* = 108
  R_PPC_EMB_SDA21* = 109
  R_PPC_EMB_MRKREF* = 110
  R_PPC_EMB_RELSEC16* = 111
  R_PPC_EMB_RELST_LO* = 112
  R_PPC_EMB_RELST_HI* = 113
  R_PPC_EMB_RELST_HA* = 114
  R_PPC_EMB_BIT_FLD* = 115
  R_PPC_EMB_RELSDA* = 116

##  Diab tool relocations.

const
  R_PPC_DIAB_SDA21_LO* = 180
  R_PPC_DIAB_SDA21_HI* = 181
  R_PPC_DIAB_SDA21_HA* = 182
  R_PPC_DIAB_RELSDA_LO* = 183
  R_PPC_DIAB_RELSDA_HI* = 184
  R_PPC_DIAB_RELSDA_HA* = 185

##  GNU extension to support local ifunc.

const
  R_PPC_IRELATIVE* = 248

##  GNU relocs used in PIC code sequences.

const
  R_PPC_REL16* = 249
  R_PPC_REL16_LO* = 250
  R_PPC_REL16_HI* = 251
  R_PPC_REL16_HA* = 252

##  This is a phony reloc to handle any old fashioned TOC16 references
##    that may still be in object files.

const
  R_PPC_TOC16* = 255

##  PowerPC specific values for the Dyn d_tag field.

const
  DT_PPC_GOT* = (DT_LOPROC + 0)
  DT_PPC_NUM* = 1

##  PowerPC64 relocations defined by the ABIs

const
  R_PPC64_NONE* = R_PPC_NONE
  R_PPC64_ADDR32* = R_PPC_ADDR32
  R_PPC64_ADDR24* = R_PPC_ADDR24
  R_PPC64_ADDR16* = R_PPC_ADDR16
  R_PPC64_ADDR16_LO* = R_PPC_ADDR16_LO
  R_PPC64_ADDR16_HI* = R_PPC_ADDR16_HI
  R_PPC64_ADDR16_HA* = R_PPC_ADDR16_HA
  R_PPC64_ADDR14* = R_PPC_ADDR14
  R_PPC64_ADDR14_BRTAKEN* = R_PPC_ADDR14_BRTAKEN
  R_PPC64_ADDR14_BRNTAKEN* = R_PPC_ADDR14_BRNTAKEN
  R_PPC64_REL24* = R_PPC_REL24
  R_PPC64_REL14* = R_PPC_REL14
  R_PPC64_REL14_BRTAKEN* = R_PPC_REL14_BRTAKEN
  R_PPC64_REL14_BRNTAKEN* = R_PPC_REL14_BRNTAKEN
  R_PPC64_GOT16* = R_PPC_GOT16
  R_PPC64_GOT16_LO* = R_PPC_GOT16_LO
  R_PPC64_GOT16_HI* = R_PPC_GOT16_HI
  R_PPC64_GOT16_HA* = R_PPC_GOT16_HA
  R_PPC64_COPY* = R_PPC_COPY
  R_PPC64_GLOB_DAT* = R_PPC_GLOB_DAT
  R_PPC64_JMP_SLOT* = R_PPC_JMP_SLOT
  R_PPC64_RELATIVE* = R_PPC_RELATIVE
  R_PPC64_UADDR32* = R_PPC_UADDR32
  R_PPC64_UADDR16* = R_PPC_UADDR16
  R_PPC64_REL32* = R_PPC_REL32
  R_PPC64_PLT32* = R_PPC_PLT32
  R_PPC64_PLTREL32* = R_PPC_PLTREL32
  R_PPC64_PLT16_LO* = R_PPC_PLT16_LO
  R_PPC64_PLT16_HI* = R_PPC_PLT16_HI
  R_PPC64_PLT16_HA* = R_PPC_PLT16_HA
  R_PPC64_SECTOFF* = R_PPC_SECTOFF
  R_PPC64_SECTOFF_LO* = R_PPC_SECTOFF_LO
  R_PPC64_SECTOFF_HI* = R_PPC_SECTOFF_HI
  R_PPC64_SECTOFF_HA* = R_PPC_SECTOFF_HA
  R_PPC64_ADDR30* = 37
  R_PPC64_ADDR64* = 38
  R_PPC64_ADDR16_HIGHER* = 39
  R_PPC64_ADDR16_HIGHERA* = 40
  R_PPC64_ADDR16_HIGHEST* = 41
  R_PPC64_ADDR16_HIGHESTA* = 42
  R_PPC64_UADDR64* = 43
  R_PPC64_REL64* = 44
  R_PPC64_PLT64* = 45
  R_PPC64_PLTREL64* = 46
  R_PPC64_TOC16* = 47
  R_PPC64_TOC16_LO* = 48
  R_PPC64_TOC16_HI* = 49
  R_PPC64_TOC16_HA* = 50
  R_PPC64_TOC* = 51
  R_PPC64_PLTGOT16* = 52
  R_PPC64_PLTGOT16_LO* = 53
  R_PPC64_PLTGOT16_HI* = 54
  R_PPC64_PLTGOT16_HA* = 55
  R_PPC64_ADDR16_DS* = 56
  R_PPC64_ADDR16_LO_DS* = 57
  R_PPC64_GOT16_DS* = 58
  R_PPC64_GOT16_LO_DS* = 59
  R_PPC64_PLT16_LO_DS* = 60
  R_PPC64_SECTOFF_DS* = 61
  R_PPC64_SECTOFF_LO_DS* = 62
  R_PPC64_TOC16_DS* = 63
  R_PPC64_TOC16_LO_DS* = 64
  R_PPC64_PLTGOT16_DS* = 65
  R_PPC64_PLTGOT16_LO_DS* = 66

##  PowerPC64 relocations defined for the TLS access ABI.

const
  R_PPC64_TLS* = 67
  R_PPC64_DTPMOD64* = 68
  R_PPC64_TPREL16* = 69
  R_PPC64_TPREL16_LO* = 70
  R_PPC64_TPREL16_HI* = 71
  R_PPC64_TPREL16_HA* = 72
  R_PPC64_TPREL64* = 73
  R_PPC64_DTPREL16* = 74
  R_PPC64_DTPREL16_LO* = 75
  R_PPC64_DTPREL16_HI* = 76
  R_PPC64_DTPREL16_HA* = 77
  R_PPC64_DTPREL64* = 78
  R_PPC64_GOT_TLSGD16* = 79
  R_PPC64_GOT_TLSGD16_LO* = 80
  R_PPC64_GOT_TLSGD16_HI* = 81
  R_PPC64_GOT_TLSGD16_HA* = 82
  R_PPC64_GOT_TLSLD16* = 83
  R_PPC64_GOT_TLSLD16_LO* = 84
  R_PPC64_GOT_TLSLD16_HI* = 85
  R_PPC64_GOT_TLSLD16_HA* = 86
  R_PPC64_GOT_TPREL16_DS* = 87
  R_PPC64_GOT_TPREL16_LO_DS* = 88
  R_PPC64_GOT_TPREL16_HI* = 89
  R_PPC64_GOT_TPREL16_HA* = 90
  R_PPC64_GOT_DTPREL16_DS* = 91
  R_PPC64_GOT_DTPREL16_LO_DS* = 92
  R_PPC64_GOT_DTPREL16_HI* = 93
  R_PPC64_GOT_DTPREL16_HA* = 94
  R_PPC64_TPREL16_DS* = 95
  R_PPC64_TPREL16_LO_DS* = 96
  R_PPC64_TPREL16_HIGHER* = 97
  R_PPC64_TPREL16_HIGHERA* = 98
  R_PPC64_TPREL16_HIGHEST* = 99
  R_PPC64_TPREL16_HIGHESTA* = 100
  R_PPC64_DTPREL16_DS* = 101
  R_PPC64_DTPREL16_LO_DS* = 102
  R_PPC64_DTPREL16_HIGHER* = 103
  R_PPC64_DTPREL16_HIGHERA* = 104
  R_PPC64_DTPREL16_HIGHEST* = 105
  R_PPC64_DTPREL16_HIGHESTA* = 106
  R_PPC64_TLSGD* = 107
  R_PPC64_TLSLD* = 108
  R_PPC64_TOCSAVE* = 109

##  Added when HA and HI relocs were changed to report overflows.

const
  R_PPC64_ADDR16_HIGH* = 110
  R_PPC64_ADDR16_HIGHA* = 111
  R_PPC64_TPREL16_HIGH* = 112
  R_PPC64_TPREL16_HIGHA* = 113
  R_PPC64_DTPREL16_HIGH* = 114
  R_PPC64_DTPREL16_HIGHA* = 115

##  GNU extension to support local ifunc.

const
  R_PPC64_JMP_IREL* = 247
  R_PPC64_IRELATIVE* = 248
  R_PPC64_REL16* = 249
  R_PPC64_REL16_LO* = 250
  R_PPC64_REL16_HI* = 251
  R_PPC64_REL16_HA* = 252

##  e_flags bits specifying ABI.
##    1 for original function descriptor using ABI,
##    2 for revised ABI without function descriptors,
##    0 for unspecified or not using any features affected by the differences.

const
  EF_PPC64_ABI* = 3

##  PowerPC64 specific values for the Dyn d_tag field.

const
  DT_PPC64_GLINK* = (DT_LOPROC + 0)
  DT_PPC64_OPD* = (DT_LOPROC + 1)
  DT_PPC64_OPDSZ* = (DT_LOPROC + 2)
  DT_PPC64_OPT* = (DT_LOPROC + 3)
  DT_PPC64_NUM* = 3

##  PowerPC64 specific values for the DT_PPC64_OPT Dyn entry.

const
  PPC64_OPT_TLS* = 1
  PPC64_OPT_MULTI_TOC* = 2

##  PowerPC64 specific values for the Elf64_Sym st_other field.

const
  STO_PPC64_LOCAL_BIT* = 5
  STO_PPC64_LOCAL_MASK* = (7 shl STO_PPC64_LOCAL_BIT)

template PPC64_LOCAL_ENTRY_OFFSET*(other: untyped): untyped =
  (((1 shl (((other) and STO_PPC64_LOCAL_MASK) shr STO_PPC64_LOCAL_BIT)) shr 2) shl 2)

##  ARM specific declarations
##  Processor specific flags for the ELF header e_flags field.

const
  EF_ARM_RELEXEC* = 0x00000001
  EF_ARM_HASENTRY* = 0x00000002
  EF_ARM_INTERWORK* = 0x00000004
  EF_ARM_APCS_26* = 0x00000008
  EF_ARM_APCS_FLOAT* = 0x00000010
  EF_ARM_PIC* = 0x00000020
  EF_ARM_ALIGN8* = 0x00000040
  EF_ARM_NEW_ABI* = 0x00000080
  EF_ARM_OLD_ABI* = 0x00000100
  EF_ARM_SOFT_FLOAT* = 0x00000200
  EF_ARM_VFP_FLOAT* = 0x00000400
  EF_ARM_MAVERICK_FLOAT* = 0x00000800
  EF_ARM_ABI_FLOAT_SOFT* = 0x00000200
  EF_ARM_ABI_FLOAT_HARD* = 0x00000400

##  Other constants defined in the ARM ELF spec. version B-01.
##  NB. These conflict with values defined above.

const
  EF_ARM_SYMSARESORTED* = 0x00000004
  EF_ARM_DYNSYMSUSESEGIDX* = 0x00000008
  EF_ARM_MAPSYMSFIRST* = 0x00000010
  EF_ARM_EABIMASK* = 0xFF000000

##  Constants defined in AAELF.

const
  EF_ARM_BE8* = 0x00800000
  EF_ARM_LE8* = 0x00400000

template EF_ARM_EABI_VERSION*(flags: untyped): untyped =
  ((flags) and EF_ARM_EABIMASK)

const
  EF_ARM_EABI_UNKNOWN* = 0x00000000
  EF_ARM_EABI_VER1* = 0x01000000
  EF_ARM_EABI_VER2* = 0x02000000
  EF_ARM_EABI_VER3* = 0x03000000
  EF_ARM_EABI_VER4* = 0x04000000
  EF_ARM_EABI_VER5* = 0x05000000

##  Additional symbol types for Thumb.

const
  STT_ARM_TFUNC* = STT_LOPROC
  STT_ARM_16BIT* = STT_HIPROC

##  ARM-specific values for sh_flags

const
  SHF_ARM_ENTRYSECT* = 0x10000000
  SHF_ARM_COMDEF* = 0x80000000

##  ARM-specific program header flags

const
  PF_ARM_SB* = 0x10000000
  PF_ARM_PI* = 0x20000000
  PF_ARM_ABS* = 0x40000000

##  Processor specific values for the Phdr p_type field.

const
  PT_ARM_EXIDX* = (PT_LOPROC + 1) ##  ARM unwind segment.

##  Processor specific values for the Shdr sh_type field.

const
  SHT_ARM_EXIDX* = (SHT_LOPROC + 1) ##  ARM unwind section.
  SHT_ARM_PREEMPTMAP* = (SHT_LOPROC + 2) ##  Preemption details.
  SHT_ARM_ATTRIBUTES* = (SHT_LOPROC + 3) ##  ARM attributes section.

##  AArch64 relocs.

const
  R_AARCH64_NONE* = 0
  R_AARCH64_ABS64* = 257
  R_AARCH64_ABS32* = 258
  R_AARCH64_ABS16* = 259
  R_AARCH64_PREL64* = 260
  R_AARCH64_PREL32* = 261
  R_AARCH64_PREL16* = 262
  R_AARCH64_MOVW_UABS_G0* = 263
  R_AARCH64_MOVW_UABS_G0_NC* = 264
  R_AARCH64_MOVW_UABS_G1* = 265
  R_AARCH64_MOVW_UABS_G1_NC* = 266
  R_AARCH64_MOVW_UABS_G2* = 267
  R_AARCH64_MOVW_UABS_G2_NC* = 268
  R_AARCH64_MOVW_UABS_G3* = 269
  R_AARCH64_MOVW_SABS_G0* = 270
  R_AARCH64_MOVW_SABS_G1* = 271
  R_AARCH64_MOVW_SABS_G2* = 272
  R_AARCH64_LD_PREL_LO19* = 273
  R_AARCH64_ADR_PREL_LO21* = 274
  R_AARCH64_ADR_PREL_PG_HI21* = 275
  R_AARCH64_ADR_PREL_PG_HI21_NC* = 276
  R_AARCH64_ADD_ABS_LO12_NC* = 277
  R_AARCH64_LDST8_ABS_LO12_NC* = 278
  R_AARCH64_TSTBR14* = 279
  R_AARCH64_CONDBR19* = 280
  R_AARCH64_JUMP26* = 282
  R_AARCH64_CALL26* = 283
  R_AARCH64_LDST16_ABS_LO12_NC* = 284
  R_AARCH64_LDST32_ABS_LO12_NC* = 285
  R_AARCH64_LDST64_ABS_LO12_NC* = 286
  R_AARCH64_MOVW_PREL_G0* = 287
  R_AARCH64_MOVW_PREL_G0_NC* = 288
  R_AARCH64_MOVW_PREL_G1* = 289
  R_AARCH64_MOVW_PREL_G1_NC* = 290
  R_AARCH64_MOVW_PREL_G2* = 291
  R_AARCH64_MOVW_PREL_G2_NC* = 292
  R_AARCH64_MOVW_PREL_G3* = 293
  R_AARCH64_LDST128_ABS_LO12_NC* = 299
  R_AARCH64_MOVW_GOTOFF_G0* = 300
  R_AARCH64_MOVW_GOTOFF_G0_NC* = 301
  R_AARCH64_MOVW_GOTOFF_G1* = 302
  R_AARCH64_MOVW_GOTOFF_G1_NC* = 303
  R_AARCH64_MOVW_GOTOFF_G2* = 304
  R_AARCH64_MOVW_GOTOFF_G2_NC* = 305
  R_AARCH64_MOVW_GOTOFF_G3* = 306
  R_AARCH64_GOTREL64* = 307
  R_AARCH64_GOTREL32* = 308
  R_AARCH64_GOT_LD_PREL19* = 309
  R_AARCH64_LD64_GOTOFF_LO15* = 310
  R_AARCH64_ADR_GOT_PAGE* = 311
  R_AARCH64_LD64_GOT_LO12_NC* = 312
  R_AARCH64_LD64_GOTPAGE_LO15* = 313
  R_AARCH64_TLSGD_ADR_PREL21* = 512
  R_AARCH64_TLSGD_ADR_PAGE21* = 513
  R_AARCH64_TLSGD_ADD_LO12_NC* = 514
  R_AARCH64_TLSGD_MOVW_G1* = 515
  R_AARCH64_TLSGD_MOVW_G0_NC* = 516
  R_AARCH64_TLSLD_ADR_PREL21* = 517
  R_AARCH64_TLSLD_ADR_PAGE21* = 518
  R_AARCH64_TLSLD_ADD_LO12_NC* = 519
  R_AARCH64_TLSLD_MOVW_G1* = 520
  R_AARCH64_TLSLD_MOVW_G0_NC* = 521
  R_AARCH64_TLSLD_LD_PREL19* = 522
  R_AARCH64_TLSLD_MOVW_DTPREL_G2* = 523
  R_AARCH64_TLSLD_MOVW_DTPREL_G1* = 524
  R_AARCH64_TLSLD_MOVW_DTPREL_G1_NC* = 525
  R_AARCH64_TLSLD_MOVW_DTPREL_G0* = 526
  R_AARCH64_TLSLD_MOVW_DTPREL_G0_NC* = 527
  R_AARCH64_TLSLD_ADD_DTPREL_HI12* = 528
  R_AARCH64_TLSLD_ADD_DTPREL_LO12* = 529
  R_AARCH64_TLSLD_ADD_DTPREL_LO12_NC* = 530
  R_AARCH64_TLSLD_LDST8_DTPREL_LO12* = 531
  R_AARCH64_TLSLD_LDST8_DTPREL_LO12_NC* = 532
  R_AARCH64_TLSLD_LDST16_DTPREL_LO12* = 533
  R_AARCH64_TLSLD_LDST16_DTPREL_LO12_NC* = 534
  R_AARCH64_TLSLD_LDST32_DTPREL_LO12* = 535
  R_AARCH64_TLSLD_LDST32_DTPREL_LO12_NC* = 536
  R_AARCH64_TLSLD_LDST64_DTPREL_LO12* = 537
  R_AARCH64_TLSLD_LDST64_DTPREL_LO12_NC* = 538
  R_AARCH64_TLSIE_MOVW_GOTTPREL_G1* = 539
  R_AARCH64_TLSIE_MOVW_GOTTPREL_G0_NC* = 540
  R_AARCH64_TLSIE_ADR_GOTTPREL_PAGE21* = 541
  R_AARCH64_TLSIE_LD64_GOTTPREL_LO12_NC* = 542
  R_AARCH64_TLSIE_LD_GOTTPREL_PREL19* = 543
  R_AARCH64_TLSLE_MOVW_TPREL_G2* = 544
  R_AARCH64_TLSLE_MOVW_TPREL_G1* = 545
  R_AARCH64_TLSLE_MOVW_TPREL_G1_NC* = 546
  R_AARCH64_TLSLE_MOVW_TPREL_G0* = 547
  R_AARCH64_TLSLE_MOVW_TPREL_G0_NC* = 548
  R_AARCH64_TLSLE_ADD_TPREL_HI12* = 549
  R_AARCH64_TLSLE_ADD_TPREL_LO12* = 550
  R_AARCH64_TLSLE_ADD_TPREL_LO12_NC* = 551
  R_AARCH64_TLSLE_LDST8_TPREL_LO12* = 552
  R_AARCH64_TLSLE_LDST8_TPREL_LO12_NC* = 553
  R_AARCH64_TLSLE_LDST16_TPREL_LO12* = 554
  R_AARCH64_TLSLE_LDST16_TPREL_LO12_NC* = 555
  R_AARCH64_TLSLE_LDST32_TPREL_LO12* = 556
  R_AARCH64_TLSLE_LDST32_TPREL_LO12_NC* = 557
  R_AARCH64_TLSLE_LDST64_TPREL_LO12* = 558
  R_AARCH64_TLSLE_LDST64_TPREL_LO12_NC* = 559
  R_AARCH64_TLSDESC_LD_PREL19* = 560
  R_AARCH64_TLSDESC_ADR_PREL21* = 561
  R_AARCH64_TLSDESC_ADR_PAGE21* = 562
  R_AARCH64_TLSDESC_LD64_LO12* = 563
  R_AARCH64_TLSDESC_ADD_LO12* = 564
  R_AARCH64_TLSDESC_OFF_G1* = 565
  R_AARCH64_TLSDESC_OFF_G0_NC* = 566
  R_AARCH64_TLSDESC_LDR* = 567
  R_AARCH64_TLSDESC_ADD* = 568
  R_AARCH64_TLSDESC_CALL* = 569
  R_AARCH64_TLSLE_LDST128_TPREL_LO12* = 570
  R_AARCH64_TLSLE_LDST128_TPREL_LO12_NC* = 571
  R_AARCH64_TLSLD_LDST128_DTPREL_LO12* = 572
  R_AARCH64_TLSLD_LDST128_DTPREL_LO12_NC* = 573
  R_AARCH64_COPY* = 1024
  R_AARCH64_GLOB_DAT* = 1025
  R_AARCH64_JUMP_SLOT* = 1026
  R_AARCH64_RELATIVE* = 1027
  R_AARCH64_TLS_DTPMOD64* = 1028
  R_AARCH64_TLS_DTPREL64* = 1029
  R_AARCH64_TLS_TPREL64* = 1030
  R_AARCH64_TLSDESC* = 1031
  R_AARCH64_IRELATIVE* = 1032

##  ARM relocs.

const
  R_ARM_NONE* = 0
  R_ARM_PC24* = 1
  R_ARM_ABS32* = 2
  R_ARM_REL32* = 3
  R_ARM_PC13* = 4
  R_ARM_ABS16* = 5
  R_ARM_ABS12* = 6
  R_ARM_THM_ABS5* = 7
  R_ARM_ABS8* = 8
  R_ARM_SBREL32* = 9
  R_ARM_THM_PC22* = 10
  R_ARM_THM_PC8* = 11
  R_ARM_AMP_VCALL9* = 12
  R_ARM_SWI24* = 13
  R_ARM_TLS_DESC* = 13
  R_ARM_THM_SWI8* = 14
  R_ARM_XPC25* = 15
  R_ARM_THM_XPC22* = 16
  R_ARM_TLS_DTPMOD32* = 17
  R_ARM_TLS_DTPOFF32* = 18
  R_ARM_TLS_TPOFF32* = 19
  R_ARM_COPY* = 20
  R_ARM_GLOB_DAT* = 21
  R_ARM_JUMP_SLOT* = 22
  R_ARM_RELATIVE* = 23
  R_ARM_GOTOFF* = 24
  R_ARM_GOTPC* = 25
  R_ARM_GOT32* = 26
  R_ARM_PLT32* = 27
  R_ARM_CALL* = 28
  R_ARM_JUMP24* = 29
  R_ARM_THM_JUMP24* = 30
  R_ARM_BASE_ABS* = 31
  R_ARM_ALU_PCREL_7_0* = 32
  R_ARM_ALU_PCREL_15_8* = 33
  R_ARM_ALU_PCREL_23_15* = 34
  R_ARM_LDR_SBREL_11_0* = 35
  R_ARM_ALU_SBREL_19_12* = 36
  R_ARM_ALU_SBREL_27_20* = 37
  R_ARM_TARGET1* = 38
  R_ARM_SBREL31* = 39
  R_ARM_V4BX* = 40
  R_ARM_TARGET2* = 41
  R_ARM_PREL31* = 42
  R_ARM_MOVW_ABS_NC* = 43
  R_ARM_MOVT_ABS* = 44
  R_ARM_MOVW_PREL_NC* = 45
  R_ARM_MOVT_PREL* = 46
  R_ARM_THM_MOVW_ABS_NC* = 47
  R_ARM_THM_MOVT_ABS* = 48
  R_ARM_THM_MOVW_PREL_NC* = 49
  R_ARM_THM_MOVT_PREL* = 50
  R_ARM_THM_JUMP19* = 51
  R_ARM_THM_JUMP6* = 52
  R_ARM_THM_ALU_PREL_11_0* = 53
  R_ARM_THM_PC12* = 54
  R_ARM_ABS32_NOI* = 55
  R_ARM_REL32_NOI* = 56
  R_ARM_ALU_PC_G0_NC* = 57
  R_ARM_ALU_PC_G0* = 58
  R_ARM_ALU_PC_G1_NC* = 59
  R_ARM_ALU_PC_G1* = 60
  R_ARM_ALU_PC_G2* = 61
  R_ARM_LDR_PC_G1* = 62
  R_ARM_LDR_PC_G2* = 63
  R_ARM_LDRS_PC_G0* = 64
  R_ARM_LDRS_PC_G1* = 65
  R_ARM_LDRS_PC_G2* = 66
  R_ARM_LDC_PC_G0* = 67
  R_ARM_LDC_PC_G1* = 68
  R_ARM_LDC_PC_G2* = 69
  R_ARM_ALU_SB_G0_NC* = 70
  R_ARM_ALU_SB_G0* = 71
  R_ARM_ALU_SB_G1_NC* = 72
  R_ARM_ALU_SB_G1* = 73
  R_ARM_ALU_SB_G2* = 74
  R_ARM_LDR_SB_G0* = 75
  R_ARM_LDR_SB_G1* = 76
  R_ARM_LDR_SB_G2* = 77
  R_ARM_LDRS_SB_G0* = 78
  R_ARM_LDRS_SB_G1* = 79
  R_ARM_LDRS_SB_G2* = 80
  R_ARM_LDC_SB_G0* = 81
  R_ARM_LDC_SB_G1* = 82
  R_ARM_LDC_SB_G2* = 83
  R_ARM_MOVW_BREL_NC* = 84
  R_ARM_MOVT_BREL* = 85
  R_ARM_MOVW_BREL* = 86
  R_ARM_THM_MOVW_BREL_NC* = 87
  R_ARM_THM_MOVT_BREL* = 88
  R_ARM_THM_MOVW_BREL* = 89
  R_ARM_TLS_GOTDESC* = 90
  R_ARM_TLS_CALL* = 91
  R_ARM_TLS_DESCSEQ* = 92
  R_ARM_THM_TLS_CALL* = 93
  R_ARM_PLT32_ABS* = 94
  R_ARM_GOT_ABS* = 95
  R_ARM_GOT_PREL* = 96
  R_ARM_GOT_BREL12* = 97
  R_ARM_GOTOFF12* = 98
  R_ARM_GOTRELAX* = 99
  R_ARM_GNU_VTENTRY* = 100
  R_ARM_GNU_VTINHERIT* = 101
  R_ARM_THM_PC11* = 102
  R_ARM_THM_PC9* = 103
  R_ARM_TLS_GD32* = 104
  R_ARM_TLS_LDM32* = 105
  R_ARM_TLS_LDO32* = 106
  R_ARM_TLS_IE32* = 107
  R_ARM_TLS_LE32* = 108
  R_ARM_TLS_LDO12* = 109
  R_ARM_TLS_LE12* = 110
  R_ARM_TLS_IE12GP* = 111
  R_ARM_ME_TOO* = 128
  R_ARM_THM_TLS_DESCSEQ* = 129
  R_ARM_THM_TLS_DESCSEQ16* = 129
  R_ARM_THM_TLS_DESCSEQ32* = 130
  R_ARM_THM_GOT_BREL12* = 131
  R_ARM_IRELATIVE* = 160
  R_ARM_RXPC25* = 249
  R_ARM_RSBREL32* = 250
  R_ARM_THM_RPC22* = 251
  R_ARM_RREL32* = 252
  R_ARM_RABS22* = 253
  R_ARM_RPC24* = 254
  R_ARM_RBASE* = 255

##  Keep this the last entry.

const
  R_ARM_NUM* = 256

##  IA-64 specific declarations.
##  Processor specific flags for the Ehdr e_flags field.

const
  EF_IA_64_MASKOS* = 0x0000000F
  EF_IA_64_ABI64* = 0x00000010
  EF_IA_64_ARCH* = 0xFF000000

##  Processor specific values for the Phdr p_type field.

const
  PT_IA_64_ARCHEXT* = (PT_LOPROC + 0) ##  arch extension bits
  PT_IA_64_UNWIND* = (PT_LOPROC + 1) ##  ia64 unwind bits
  PT_IA_64_HP_OPT_ANOT* = (PT_LOOS + 0x00000012)
  PT_IA_64_HP_HSL_ANOT* = (PT_LOOS + 0x00000013)
  PT_IA_64_HP_STACK* = (PT_LOOS + 0x00000014)

##  Processor specific flags for the Phdr p_flags field.

const
  PF_IA_64_NORECOV* = 0x80000000

##  Processor specific values for the Shdr sh_type field.

const
  SHT_IA_64_EXT* = (SHT_LOPROC + 0) ##  extension bits
  SHT_IA_64_UNWIND* = (SHT_LOPROC + 1) ##  unwind bits

##  Processor specific flags for the Shdr sh_flags field.

const
  SHF_IA_64_SHORT* = 0x10000000
  SHF_IA_64_NORECOV* = 0x20000000

##  Processor specific values for the Dyn d_tag field.

const
  DT_IA_64_PLT_RESERVE* = (DT_LOPROC + 0)
  DT_IA_64_NUM* = 1

##  IA-64 relocations.

const
  R_IA64_NONE* = 0x00000000
  R_IA64_IMM14* = 0x00000021
  R_IA64_IMM22* = 0x00000022
  R_IA64_IMM64* = 0x00000023
  R_IA64_DIR32MSB* = 0x00000024
  R_IA64_DIR32LSB* = 0x00000025
  R_IA64_DIR64MSB* = 0x00000026
  R_IA64_DIR64LSB* = 0x00000027
  R_IA64_GPREL22* = 0x0000002A
  R_IA64_GPREL64I* = 0x0000002B
  R_IA64_GPREL32MSB* = 0x0000002C
  R_IA64_GPREL32LSB* = 0x0000002D
  R_IA64_GPREL64MSB* = 0x0000002E
  R_IA64_GPREL64LSB* = 0x0000002F
  R_IA64_LTOFF22* = 0x00000032
  R_IA64_LTOFF64I* = 0x00000033
  R_IA64_PLTOFF22* = 0x0000003A
  R_IA64_PLTOFF64I* = 0x0000003B
  R_IA64_PLTOFF64MSB* = 0x0000003E
  R_IA64_PLTOFF64LSB* = 0x0000003F
  R_IA64_FPTR64I* = 0x00000043
  R_IA64_FPTR32MSB* = 0x00000044
  R_IA64_FPTR32LSB* = 0x00000045
  R_IA64_FPTR64MSB* = 0x00000046
  R_IA64_FPTR64LSB* = 0x00000047
  R_IA64_PCREL60B* = 0x00000048
  R_IA64_PCREL21B* = 0x00000049
  R_IA64_PCREL21M* = 0x0000004A
  R_IA64_PCREL21F* = 0x0000004B
  R_IA64_PCREL32MSB* = 0x0000004C
  R_IA64_PCREL32LSB* = 0x0000004D
  R_IA64_PCREL64MSB* = 0x0000004E
  R_IA64_PCREL64LSB* = 0x0000004F
  R_IA64_LTOFF_FPTR22* = 0x00000052
  R_IA64_LTOFF_FPTR64I* = 0x00000053
  R_IA64_LTOFF_FPTR32MSB* = 0x00000054
  R_IA64_LTOFF_FPTR32LSB* = 0x00000055
  R_IA64_LTOFF_FPTR64MSB* = 0x00000056
  R_IA64_LTOFF_FPTR64LSB* = 0x00000057
  R_IA64_SEGREL32MSB* = 0x0000005C
  R_IA64_SEGREL32LSB* = 0x0000005D
  R_IA64_SEGREL64MSB* = 0x0000005E
  R_IA64_SEGREL64LSB* = 0x0000005F
  R_IA64_SECREL32MSB* = 0x00000064
  R_IA64_SECREL32LSB* = 0x00000065
  R_IA64_SECREL64MSB* = 0x00000066
  R_IA64_SECREL64LSB* = 0x00000067
  R_IA64_REL32MSB* = 0x0000006C
  R_IA64_REL32LSB* = 0x0000006D
  R_IA64_REL64MSB* = 0x0000006E
  R_IA64_REL64LSB* = 0x0000006F
  R_IA64_LTV32MSB* = 0x00000074
  R_IA64_LTV32LSB* = 0x00000075
  R_IA64_LTV64MSB* = 0x00000076
  R_IA64_LTV64LSB* = 0x00000077
  R_IA64_PCREL21BI* = 0x00000079
  R_IA64_PCREL22* = 0x0000007A
  R_IA64_PCREL64I* = 0x0000007B
  R_IA64_IPLTMSB* = 0x00000080
  R_IA64_IPLTLSB* = 0x00000081
  R_IA64_COPY* = 0x00000084
  R_IA64_SUB* = 0x00000085
  R_IA64_LTOFF22X* = 0x00000086
  R_IA64_LDXMOV* = 0x00000087
  R_IA64_TPREL14* = 0x00000091
  R_IA64_TPREL22* = 0x00000092
  R_IA64_TPREL64I* = 0x00000093
  R_IA64_TPREL64MSB* = 0x00000096
  R_IA64_TPREL64LSB* = 0x00000097
  R_IA64_LTOFF_TPREL22* = 0x0000009A
  R_IA64_DTPMOD64MSB* = 0x000000A6
  R_IA64_DTPMOD64LSB* = 0x000000A7
  R_IA64_LTOFF_DTPMOD22* = 0x000000AA
  R_IA64_DTPREL14* = 0x000000B1
  R_IA64_DTPREL22* = 0x000000B2
  R_IA64_DTPREL64I* = 0x000000B3
  R_IA64_DTPREL32MSB* = 0x000000B4
  R_IA64_DTPREL32LSB* = 0x000000B5
  R_IA64_DTPREL64MSB* = 0x000000B6
  R_IA64_DTPREL64LSB* = 0x000000B7
  R_IA64_LTOFF_DTPREL22* = 0x000000BA

##  SH specific declarations
##  Processor specific flags for the ELF header e_flags field.

const
  EF_SH_MACH_MASK* = 0x0000001F
  EF_SH_UNKNOWN* = 0x00000000
  EF_SH1* = 0x00000001
  EF_SH2* = 0x00000002
  EF_SH3* = 0x00000003
  EF_SH_DSP* = 0x00000004
  EF_SH3_DSP* = 0x00000005
  EF_SH4AL_DSP* = 0x00000006
  EF_SH3E* = 0x00000008
  EF_SH4* = 0x00000009
  EF_SH2E* = 0x0000000B
  EF_SH4A* = 0x0000000C
  EF_SH2A* = 0x0000000D
  EF_SH4_NOFPU* = 0x00000010
  EF_SH4A_NOFPU* = 0x00000011
  EF_SH4_NOMMU_NOFPU* = 0x00000012
  EF_SH2A_NOFPU* = 0x00000013
  EF_SH3_NOMMU* = 0x00000014
  EF_SH2A_SH4_NOFPU* = 0x00000015
  EF_SH2A_SH3_NOFPU* = 0x00000016
  EF_SH2A_SH4* = 0x00000017
  EF_SH2A_SH3E* = 0x00000018

##  SH relocs.

const
  R_SH_NONE* = 0
  R_SH_DIR32* = 1
  R_SH_REL32* = 2
  R_SH_DIR8WPN* = 3
  R_SH_IND12W* = 4
  R_SH_DIR8WPL* = 5
  R_SH_DIR8WPZ* = 6
  R_SH_DIR8BP* = 7
  R_SH_DIR8W* = 8
  R_SH_DIR8L* = 9
  R_SH_SWITCH16* = 25
  R_SH_SWITCH32* = 26
  R_SH_USES* = 27
  R_SH_COUNT* = 28
  R_SH_ALIGN* = 29
  R_SH_CODE* = 30
  R_SH_DATA* = 31
  R_SH_LABEL* = 32
  R_SH_SWITCH8* = 33
  R_SH_GNU_VTINHERIT* = 34
  R_SH_GNU_VTENTRY* = 35
  R_SH_TLS_GD_32* = 144
  R_SH_TLS_LD_32* = 145
  R_SH_TLS_LDO_32* = 146
  R_SH_TLS_IE_32* = 147
  R_SH_TLS_LE_32* = 148
  R_SH_TLS_DTPMOD32* = 149
  R_SH_TLS_DTPOFF32* = 150
  R_SH_TLS_TPOFF32* = 151
  R_SH_GOT32* = 160
  R_SH_PLT32* = 161
  R_SH_COPY* = 162
  R_SH_GLOB_DAT* = 163
  R_SH_JMP_SLOT* = 164
  R_SH_RELATIVE* = 165
  R_SH_GOTOFF* = 166
  R_SH_GOTPC* = 167

##  Keep this the last entry.

const
  R_SH_NUM* = 256

##  S/390 specific definitions.
##  Valid values for the e_flags field.

const
  EF_S390_HIGH_GPRS* = 0x00000001

##  Additional s390 relocs

const
  R_390_NONE* = 0
  R_390_8* = 1
  R_390_12* = 2
  R_390_16* = 3
  R_390_32* = 4
  R_390_PC32* = 5
  R_390_GOT12* = 6
  R_390_GOT32* = 7
  R_390_PLT32* = 8
  R_390_COPY* = 9
  R_390_GLOB_DAT* = 10
  R_390_JMP_SLOT* = 11
  R_390_RELATIVE* = 12
  R_390_GOTOFF32* = 13
  R_390_GOTPC* = 14
  R_390_GOT16* = 15
  R_390_PC16* = 16
  R_390_PC16DBL* = 17
  R_390_PLT16DBL* = 18
  R_390_PC32DBL* = 19
  R_390_PLT32DBL* = 20
  R_390_GOTPCDBL* = 21
  R_390_64* = 22
  R_390_PC64* = 23
  R_390_GOT64* = 24
  R_390_PLT64* = 25
  R_390_GOTENT* = 26
  R_390_GOTOFF16* = 27
  R_390_GOTOFF64* = 28
  R_390_GOTPLT12* = 29
  R_390_GOTPLT16* = 30
  R_390_GOTPLT32* = 31
  R_390_GOTPLT64* = 32
  R_390_GOTPLTENT* = 33
  R_390_PLTOFF16* = 34
  R_390_PLTOFF32* = 35
  R_390_PLTOFF64* = 36
  R_390_TLS_LOAD* = 37
  R_390_TLS_GDCALL* = 38
  R_390_TLS_LDCALL* = 39
  R_390_TLS_GD32* = 40
  R_390_TLS_GD64* = 41
  R_390_TLS_GOTIE12* = 42
  R_390_TLS_GOTIE32* = 43
  R_390_TLS_GOTIE64* = 44
  R_390_TLS_LDM32* = 45
  R_390_TLS_LDM64* = 46
  R_390_TLS_IE32* = 47
  R_390_TLS_IE64* = 48
  R_390_TLS_IEENT* = 49
  R_390_TLS_LE32* = 50
  R_390_TLS_LE64* = 51
  R_390_TLS_LDO32* = 52
  R_390_TLS_LDO64* = 53
  R_390_TLS_DTPMOD* = 54
  R_390_TLS_DTPOFF* = 55
  R_390_TLS_TPOFF* = 56
  R_390_20* = 57
  R_390_GOT20* = 58
  R_390_GOTPLT20* = 59
  R_390_TLS_GOTIE20* = 60
  R_390_IRELATIVE* = 61

##  Keep this the last entry.

const
  R_390_NUM* = 62

##  CRIS relocations.

const
  R_CRIS_NONE* = 0
  R_CRIS_8* = 1
  R_CRIS_16* = 2
  R_CRIS_32* = 3
  R_CRIS_8_PCREL* = 4
  R_CRIS_16_PCREL* = 5
  R_CRIS_32_PCREL* = 6
  R_CRIS_GNU_VTINHERIT* = 7
  R_CRIS_GNU_VTENTRY* = 8
  R_CRIS_COPY* = 9
  R_CRIS_GLOB_DAT* = 10
  R_CRIS_JUMP_SLOT* = 11
  R_CRIS_RELATIVE* = 12
  R_CRIS_16_GOT* = 13
  R_CRIS_32_GOT* = 14
  R_CRIS_16_GOTPLT* = 15
  R_CRIS_32_GOTPLT* = 16
  R_CRIS_32_GOTREL* = 17
  R_CRIS_32_PLT_GOTREL* = 18
  R_CRIS_32_PLT_PCREL* = 19
  R_CRIS_NUM* = 20

##  AMD x86-64 relocations.

const
  R_X86_64_NONE* = 0
  R_X86_64_64* = 1
  R_X86_64_PC32* = 2
  R_X86_64_GOT32* = 3
  R_X86_64_PLT32* = 4
  R_X86_64_COPY* = 5
  R_X86_64_GLOB_DAT* = 6
  R_X86_64_JUMP_SLOT* = 7
  R_X86_64_RELATIVE* = 8
  R_X86_64_GOTPCREL* = 9
  R_X86_64_32* = 10
  R_X86_64_32S* = 11
  R_X86_64_16* = 12
  R_X86_64_PC16* = 13
  R_X86_64_8* = 14
  R_X86_64_PC8* = 15
  R_X86_64_DTPMOD64* = 16
  R_X86_64_DTPOFF64* = 17
  R_X86_64_TPOFF64* = 18
  R_X86_64_TLSGD* = 19
  R_X86_64_TLSLD* = 20
  R_X86_64_DTPOFF32* = 21
  R_X86_64_GOTTPOFF* = 22
  R_X86_64_TPOFF32* = 23
  R_X86_64_PC64* = 24
  R_X86_64_GOTOFF64* = 25
  R_X86_64_GOTPC32* = 26
  R_X86_64_GOT64* = 27
  R_X86_64_GOTPCREL64* = 28
  R_X86_64_GOTPC64* = 29
  R_X86_64_GOTPLT64* = 30
  R_X86_64_PLTOFF64* = 31
  R_X86_64_SIZE32* = 32
  R_X86_64_SIZE64* = 33
  R_X86_64_GOTPC32_TLSDESC* = 34
  R_X86_64_TLSDESC_CALL* = 35
  R_X86_64_TLSDESC* = 36
  R_X86_64_IRELATIVE* = 37
  R_X86_64_RELATIVE64* = 38
  R_X86_64_NUM* = 39

##  AM33 relocations.

const
  R_MN10300_NONE* = 0
  R_MN10300_32* = 1
  R_MN10300_16* = 2
  R_MN10300_8* = 3
  R_MN10300_PCREL32* = 4
  R_MN10300_PCREL16* = 5
  R_MN10300_PCREL8* = 6
  R_MN10300_GNU_VTINHERIT* = 7
  R_MN10300_GNU_VTENTRY* = 8
  R_MN10300_24* = 9
  R_MN10300_GOTPC32* = 10
  R_MN10300_GOTPC16* = 11
  R_MN10300_GOTOFF32* = 12
  R_MN10300_GOTOFF24* = 13
  R_MN10300_GOTOFF16* = 14
  R_MN10300_PLT32* = 15
  R_MN10300_PLT16* = 16
  R_MN10300_GOT32* = 17
  R_MN10300_GOT24* = 18
  R_MN10300_GOT16* = 19
  R_MN10300_COPY* = 20
  R_MN10300_GLOB_DAT* = 21
  R_MN10300_JMP_SLOT* = 22
  R_MN10300_RELATIVE* = 23
  R_MN10300_TLS_GD* = 24
  R_MN10300_TLS_LD* = 25
  R_MN10300_TLS_LDO* = 26
  R_MN10300_TLS_GOTIE* = 27
  R_MN10300_TLS_IE* = 28
  R_MN10300_TLS_LE* = 29
  R_MN10300_TLS_DTPMOD* = 30
  R_MN10300_TLS_DTPOFF* = 31
  R_MN10300_TLS_TPOFF* = 32
  R_MN10300_SYM_DIFF* = 33
  R_MN10300_ALIGN* = 34
  R_MN10300_NUM* = 35

##  M32R relocs.

const
  R_M32R_NONE* = 0
  R_M32R_16* = 1
  R_M32R_32* = 2
  R_M32R_24* = 3
  R_M32R_10_PCREL* = 4
  R_M32R_18_PCREL* = 5
  R_M32R_26_PCREL* = 6
  R_M32R_HI16_ULO* = 7
  R_M32R_HI16_SLO* = 8
  R_M32R_LO16* = 9
  R_M32R_SDA16* = 10
  R_M32R_GNU_VTINHERIT* = 11
  R_M32R_GNU_VTENTRY* = 12

##  M32R relocs use SHT_RELA.

const
  R_M32R_16_RELA* = 33
  R_M32R_32_RELA* = 34
  R_M32R_24_RELA* = 35
  R_M32R_10_PCREL_RELA* = 36
  R_M32R_18_PCREL_RELA* = 37
  R_M32R_26_PCREL_RELA* = 38
  R_M32R_HI16_ULO_RELA* = 39
  R_M32R_HI16_SLO_RELA* = 40
  R_M32R_LO16_RELA* = 41
  R_M32R_SDA16_RELA* = 42
  R_M32R_RELA_GNU_VTINHERIT* = 43
  R_M32R_RELA_GNU_VTENTRY* = 44
  R_M32R_REL32* = 45
  R_M32R_GOT24* = 48
  R_M32R_26_PLTREL* = 49
  R_M32R_COPY* = 50
  R_M32R_GLOB_DAT* = 51
  R_M32R_JMP_SLOT* = 52
  R_M32R_RELATIVE* = 53
  R_M32R_GOTOFF* = 54
  R_M32R_GOTPC24* = 55
  R_M32R_GOT16_HI_ULO* = 56
  R_M32R_GOT16_HI_SLO* = 57
  R_M32R_GOT16_LO* = 58
  R_M32R_GOTPC_HI_ULO* = 59
  R_M32R_GOTPC_HI_SLO* = 60
  R_M32R_GOTPC_LO* = 61
  R_M32R_GOTOFF_HI_ULO* = 62
  R_M32R_GOTOFF_HI_SLO* = 63
  R_M32R_GOTOFF_LO* = 64
  R_M32R_NUM* = 256

##  MicroBlaze relocations

const
  R_MICROBLAZE_NONE* = 0
  R_MICROBLAZE_32* = 1
  R_MICROBLAZE_32_PCREL* = 2
  R_MICROBLAZE_64_PCREL* = 3
  R_MICROBLAZE_32_PCREL_LO* = 4
  R_MICROBLAZE_64* = 5
  R_MICROBLAZE_32_LO* = 6
  R_MICROBLAZE_SRO32* = 7
  R_MICROBLAZE_SRW32* = 8
  R_MICROBLAZE_64_NONE* = 9
  R_MICROBLAZE_32_SYM_OP_SYM* = 10
  R_MICROBLAZE_GNU_VTINHERIT* = 11
  R_MICROBLAZE_GNU_VTENTRY* = 12
  R_MICROBLAZE_GOTPC_64* = 13
  R_MICROBLAZE_GOT_64* = 14
  R_MICROBLAZE_PLT_64* = 15
  R_MICROBLAZE_REL* = 16
  R_MICROBLAZE_JUMP_SLOT* = 17
  R_MICROBLAZE_GLOB_DAT* = 18
  R_MICROBLAZE_GOTOFF_64* = 19
  R_MICROBLAZE_GOTOFF_32* = 20
  R_MICROBLAZE_COPY* = 21
  R_MICROBLAZE_TLS* = 22
  R_MICROBLAZE_TLSGD* = 23
  R_MICROBLAZE_TLSLD* = 24
  R_MICROBLAZE_TLSDTPMOD32* = 25
  R_MICROBLAZE_TLSDTPREL32* = 26
  R_MICROBLAZE_TLSDTPREL64* = 27
  R_MICROBLAZE_TLSGOTTPREL32* = 28
  R_MICROBLAZE_TLSTPREL32* = 29

##  TILEPro relocations.

const
  R_TILEPRO_NONE* = 0
  R_TILEPRO_32* = 1
  R_TILEPRO_16* = 2
  R_TILEPRO_8* = 3
  R_TILEPRO_32_PCREL* = 4
  R_TILEPRO_16_PCREL* = 5
  R_TILEPRO_8_PCREL* = 6
  R_TILEPRO_LO16* = 7
  R_TILEPRO_HI16* = 8
  R_TILEPRO_HA16* = 9
  R_TILEPRO_COPY* = 10
  R_TILEPRO_GLOB_DAT* = 11
  R_TILEPRO_JMP_SLOT* = 12
  R_TILEPRO_RELATIVE* = 13
  R_TILEPRO_BROFF_X1* = 14
  R_TILEPRO_JOFFLONG_X1* = 15
  R_TILEPRO_JOFFLONG_X1_PLT* = 16
  R_TILEPRO_IMM8_X0* = 17
  R_TILEPRO_IMM8_Y0* = 18
  R_TILEPRO_IMM8_X1* = 19
  R_TILEPRO_IMM8_Y1* = 20
  R_TILEPRO_MT_IMM15_X1* = 21
  R_TILEPRO_MF_IMM15_X1* = 22
  R_TILEPRO_IMM16_X0* = 23
  R_TILEPRO_IMM16_X1* = 24
  R_TILEPRO_IMM16_X0_LO* = 25
  R_TILEPRO_IMM16_X1_LO* = 26
  R_TILEPRO_IMM16_X0_HI* = 27
  R_TILEPRO_IMM16_X1_HI* = 28
  R_TILEPRO_IMM16_X0_HA* = 29
  R_TILEPRO_IMM16_X1_HA* = 30
  R_TILEPRO_IMM16_X0_PCREL* = 31
  R_TILEPRO_IMM16_X1_PCREL* = 32
  R_TILEPRO_IMM16_X0_LO_PCREL* = 33
  R_TILEPRO_IMM16_X1_LO_PCREL* = 34
  R_TILEPRO_IMM16_X0_HI_PCREL* = 35
  R_TILEPRO_IMM16_X1_HI_PCREL* = 36
  R_TILEPRO_IMM16_X0_HA_PCREL* = 37
  R_TILEPRO_IMM16_X1_HA_PCREL* = 38
  R_TILEPRO_IMM16_X0_GOT* = 39
  R_TILEPRO_IMM16_X1_GOT* = 40
  R_TILEPRO_IMM16_X0_GOT_LO* = 41
  R_TILEPRO_IMM16_X1_GOT_LO* = 42
  R_TILEPRO_IMM16_X0_GOT_HI* = 43
  R_TILEPRO_IMM16_X1_GOT_HI* = 44
  R_TILEPRO_IMM16_X0_GOT_HA* = 45
  R_TILEPRO_IMM16_X1_GOT_HA* = 46
  R_TILEPRO_MMSTART_X0* = 47
  R_TILEPRO_MMEND_X0* = 48
  R_TILEPRO_MMSTART_X1* = 49
  R_TILEPRO_MMEND_X1* = 50
  R_TILEPRO_SHAMT_X0* = 51
  R_TILEPRO_SHAMT_X1* = 52
  R_TILEPRO_SHAMT_Y0* = 53
  R_TILEPRO_SHAMT_Y1* = 54
  R_TILEPRO_DEST_IMM8_X1* = 55

##  Relocs 56-59 are currently not defined.

const
  R_TILEPRO_TLS_GD_CALL* = 60
  R_TILEPRO_IMM8_X0_TLS_GD_ADD* = 61
  R_TILEPRO_IMM8_X1_TLS_GD_ADD* = 62
  R_TILEPRO_IMM8_Y0_TLS_GD_ADD* = 63
  R_TILEPRO_IMM8_Y1_TLS_GD_ADD* = 64
  R_TILEPRO_TLS_IE_LOAD* = 65
  R_TILEPRO_IMM16_X0_TLS_GD* = 66
  R_TILEPRO_IMM16_X1_TLS_GD* = 67
  R_TILEPRO_IMM16_X0_TLS_GD_LO* = 68
  R_TILEPRO_IMM16_X1_TLS_GD_LO* = 69
  R_TILEPRO_IMM16_X0_TLS_GD_HI* = 70
  R_TILEPRO_IMM16_X1_TLS_GD_HI* = 71
  R_TILEPRO_IMM16_X0_TLS_GD_HA* = 72
  R_TILEPRO_IMM16_X1_TLS_GD_HA* = 73
  R_TILEPRO_IMM16_X0_TLS_IE* = 74
  R_TILEPRO_IMM16_X1_TLS_IE* = 75
  R_TILEPRO_IMM16_X0_TLS_IE_LO* = 76
  R_TILEPRO_IMM16_X1_TLS_IE_LO* = 77
  R_TILEPRO_IMM16_X0_TLS_IE_HI* = 78
  R_TILEPRO_IMM16_X1_TLS_IE_HI* = 79
  R_TILEPRO_IMM16_X0_TLS_IE_HA* = 80
  R_TILEPRO_IMM16_X1_TLS_IE_HA* = 81
  R_TILEPRO_TLS_DTPMOD32* = 82
  R_TILEPRO_TLS_DTPOFF32* = 83
  R_TILEPRO_TLS_TPOFF32* = 84
  R_TILEPRO_IMM16_X0_TLS_LE* = 85
  R_TILEPRO_IMM16_X1_TLS_LE* = 86
  R_TILEPRO_IMM16_X0_TLS_LE_LO* = 87
  R_TILEPRO_IMM16_X1_TLS_LE_LO* = 88
  R_TILEPRO_IMM16_X0_TLS_LE_HI* = 89
  R_TILEPRO_IMM16_X1_TLS_LE_HI* = 90
  R_TILEPRO_IMM16_X0_TLS_LE_HA* = 91
  R_TILEPRO_IMM16_X1_TLS_LE_HA* = 92
  R_TILEPRO_GNU_VTINHERIT* = 128
  R_TILEPRO_GNU_VTENTRY* = 129
  R_TILEPRO_NUM* = 130

##  TILE-Gx relocations.

const
  R_TILEGX_NONE* = 0
  R_TILEGX_64* = 1
  R_TILEGX_32* = 2
  R_TILEGX_16* = 3
  R_TILEGX_8* = 4
  R_TILEGX_64_PCREL* = 5
  R_TILEGX_32_PCREL* = 6
  R_TILEGX_16_PCREL* = 7
  R_TILEGX_8_PCREL* = 8
  R_TILEGX_HW0* = 9
  R_TILEGX_HW1* = 10
  R_TILEGX_HW2* = 11
  R_TILEGX_HW3* = 12
  R_TILEGX_HW0_LAST* = 13
  R_TILEGX_HW1_LAST* = 14
  R_TILEGX_HW2_LAST* = 15
  R_TILEGX_COPY* = 16
  R_TILEGX_GLOB_DAT* = 17
  R_TILEGX_JMP_SLOT* = 18
  R_TILEGX_RELATIVE* = 19
  R_TILEGX_BROFF_X1* = 20
  R_TILEGX_JUMPOFF_X1* = 21
  R_TILEGX_JUMPOFF_X1_PLT* = 22
  R_TILEGX_IMM8_X0* = 23
  R_TILEGX_IMM8_Y0* = 24
  R_TILEGX_IMM8_X1* = 25
  R_TILEGX_IMM8_Y1* = 26
  R_TILEGX_DEST_IMM8_X1* = 27
  R_TILEGX_MT_IMM14_X1* = 28
  R_TILEGX_MF_IMM14_X1* = 29
  R_TILEGX_MMSTART_X0* = 30
  R_TILEGX_MMEND_X0* = 31
  R_TILEGX_SHAMT_X0* = 32
  R_TILEGX_SHAMT_X1* = 33
  R_TILEGX_SHAMT_Y0* = 34
  R_TILEGX_SHAMT_Y1* = 35
  R_TILEGX_IMM16_X0_HW0* = 36
  R_TILEGX_IMM16_X1_HW0* = 37
  R_TILEGX_IMM16_X0_HW1* = 38
  R_TILEGX_IMM16_X1_HW1* = 39
  R_TILEGX_IMM16_X0_HW2* = 40
  R_TILEGX_IMM16_X1_HW2* = 41
  R_TILEGX_IMM16_X0_HW3* = 42
  R_TILEGX_IMM16_X1_HW3* = 43
  R_TILEGX_IMM16_X0_HW0_LAST* = 44
  R_TILEGX_IMM16_X1_HW0_LAST* = 45
  R_TILEGX_IMM16_X0_HW1_LAST* = 46
  R_TILEGX_IMM16_X1_HW1_LAST* = 47
  R_TILEGX_IMM16_X0_HW2_LAST* = 48
  R_TILEGX_IMM16_X1_HW2_LAST* = 49
  R_TILEGX_IMM16_X0_HW0_PCREL* = 50
  R_TILEGX_IMM16_X1_HW0_PCREL* = 51
  R_TILEGX_IMM16_X0_HW1_PCREL* = 52
  R_TILEGX_IMM16_X1_HW1_PCREL* = 53
  R_TILEGX_IMM16_X0_HW2_PCREL* = 54
  R_TILEGX_IMM16_X1_HW2_PCREL* = 55
  R_TILEGX_IMM16_X0_HW3_PCREL* = 56
  R_TILEGX_IMM16_X1_HW3_PCREL* = 57
  R_TILEGX_IMM16_X0_HW0_LAST_PCREL* = 58
  R_TILEGX_IMM16_X1_HW0_LAST_PCREL* = 59
  R_TILEGX_IMM16_X0_HW1_LAST_PCREL* = 60
  R_TILEGX_IMM16_X1_HW1_LAST_PCREL* = 61
  R_TILEGX_IMM16_X0_HW2_LAST_PCREL* = 62
  R_TILEGX_IMM16_X1_HW2_LAST_PCREL* = 63
  R_TILEGX_IMM16_X0_HW0_GOT* = 64
  R_TILEGX_IMM16_X1_HW0_GOT* = 65
  R_TILEGX_IMM16_X0_HW0_PLT_PCREL* = 66
  R_TILEGX_IMM16_X1_HW0_PLT_PCREL* = 67
  R_TILEGX_IMM16_X0_HW1_PLT_PCREL* = 68
  R_TILEGX_IMM16_X1_HW1_PLT_PCREL* = 69
  R_TILEGX_IMM16_X0_HW2_PLT_PCREL* = 70
  R_TILEGX_IMM16_X1_HW2_PLT_PCREL* = 71
  R_TILEGX_IMM16_X0_HW0_LAST_GOT* = 72
  R_TILEGX_IMM16_X1_HW0_LAST_GOT* = 73
  R_TILEGX_IMM16_X0_HW1_LAST_GOT* = 74
  R_TILEGX_IMM16_X1_HW1_LAST_GOT* = 75
  R_TILEGX_IMM16_X0_HW3_PLT_PCREL* = 76
  R_TILEGX_IMM16_X1_HW3_PLT_PCREL* = 77
  R_TILEGX_IMM16_X0_HW0_TLS_GD* = 78
  R_TILEGX_IMM16_X1_HW0_TLS_GD* = 79
  R_TILEGX_IMM16_X0_HW0_TLS_LE* = 80
  R_TILEGX_IMM16_X1_HW0_TLS_LE* = 81
  R_TILEGX_IMM16_X0_HW0_LAST_TLS_LE* = 82
  R_TILEGX_IMM16_X1_HW0_LAST_TLS_LE* = 83
  R_TILEGX_IMM16_X0_HW1_LAST_TLS_LE* = 84
  R_TILEGX_IMM16_X1_HW1_LAST_TLS_LE* = 85
  R_TILEGX_IMM16_X0_HW0_LAST_TLS_GD* = 86
  R_TILEGX_IMM16_X1_HW0_LAST_TLS_GD* = 87
  R_TILEGX_IMM16_X0_HW1_LAST_TLS_GD* = 88
  R_TILEGX_IMM16_X1_HW1_LAST_TLS_GD* = 89

##  Relocs 90-91 are currently not defined.

const
  R_TILEGX_IMM16_X0_HW0_TLS_IE* = 92
  R_TILEGX_IMM16_X1_HW0_TLS_IE* = 93
  R_TILEGX_IMM16_X0_HW0_LAST_PLT_PCREL* = 94
  R_TILEGX_IMM16_X1_HW0_LAST_PLT_PCREL* = 95
  R_TILEGX_IMM16_X0_HW1_LAST_PLT_PCREL* = 96
  R_TILEGX_IMM16_X1_HW1_LAST_PLT_PCREL* = 97
  R_TILEGX_IMM16_X0_HW2_LAST_PLT_PCREL* = 98
  R_TILEGX_IMM16_X1_HW2_LAST_PLT_PCREL* = 99
  R_TILEGX_IMM16_X0_HW0_LAST_TLS_IE* = 100
  R_TILEGX_IMM16_X1_HW0_LAST_TLS_IE* = 101
  R_TILEGX_IMM16_X0_HW1_LAST_TLS_IE* = 102
  R_TILEGX_IMM16_X1_HW1_LAST_TLS_IE* = 103

##  Relocs 104-105 are currently not defined.

const
  R_TILEGX_TLS_DTPMOD64* = 106
  R_TILEGX_TLS_DTPOFF64* = 107
  R_TILEGX_TLS_TPOFF64* = 108
  R_TILEGX_TLS_DTPMOD32* = 109
  R_TILEGX_TLS_DTPOFF32* = 110
  R_TILEGX_TLS_TPOFF32* = 111
  R_TILEGX_TLS_GD_CALL* = 112
  R_TILEGX_IMM8_X0_TLS_GD_ADD* = 113
  R_TILEGX_IMM8_X1_TLS_GD_ADD* = 114
  R_TILEGX_IMM8_Y0_TLS_GD_ADD* = 115
  R_TILEGX_IMM8_Y1_TLS_GD_ADD* = 116
  R_TILEGX_TLS_IE_LOAD* = 117
  R_TILEGX_IMM8_X0_TLS_ADD* = 118
  R_TILEGX_IMM8_X1_TLS_ADD* = 119
  R_TILEGX_IMM8_Y0_TLS_ADD* = 120
  R_TILEGX_IMM8_Y1_TLS_ADD* = 121
  R_TILEGX_GNU_VTINHERIT* = 128
  R_TILEGX_GNU_VTENTRY* = 129
  R_TILEGX_NUM* = 130

##  __END_DECLS
