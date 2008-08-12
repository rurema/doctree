
= class Gem::Package::TarHeader

  struct tarfile_entry_posix {
    char name[100];     # ASCII + (Z unless filled)
    char mode[8];       # 0 padded, octal, null
    char uid[8];        # ditto
    char gid[8];        # ditto
    char size[12];      # 0 padded, octal, null
    char mtime[12];     # 0 padded, octal, null
    char checksum[8];   # 0 padded, octal, null, space
    char typeflag[1];   # file: "0"  dir: "5"
    char linkname[100]; # ASCII + (Z unless filled)
    char magic[6];      # "ustar\0"
    char version[2];    # "00"
    char uname[32];     # ASCIIZ
    char gname[32];     # ASCIIZ
    char devmajor[8];   # 0 padded, octal, null
    char devminor[8];   # o padded, octal, null
    char prefix[155];   # ASCII + (Z unless filled)
  };


== Public Instance Methods

--- ==
#@todo

--- checksum
#@todo

--- devmajor
#@todo

--- devminor
#@todo

--- empty?
#@todo

--- gid
#@todo

--- gname
#@todo

--- linkname
#@todo

--- magic
#@todo

--- mode
#@todo

--- mtime
#@todo

--- name
#@todo

--- prefix
#@todo

--- size
#@todo

--- to_s
#@todo

--- typeflag
#@todo

--- uid
#@todo

--- uname
#@todo

--- update_checksum
#@todo

--- version
#@todo

== Singleton Methods

--- from
#@todo

== Constants

--- FIELDS -> Array
#@todo

--- PACK_FORMAT -> String
#@todo

--- UNPACK_FORMAT -> String
#@todo

