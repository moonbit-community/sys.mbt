///|
using @cstr {type CStr}

///|
#external
pub type File

///|
#external
pub type FileType

///|
pub type Metadata

///|
#external
pub type Permissions

///|
pub extern "c" fn moonbit_file_is_invalid(file : File) -> Bool = "moonbit_file_is_invalid"

///|
#borrow(filename)
pub extern "c" fn moonbit_file_open(filename : CStr) -> File = "moonbit_file_open"

///|
#borrow(filename)
pub extern "c" fn moonbit_remove_file(filename : CStr) -> Bool = "moonbit_remove_file"

///|
#borrow(dirname)
pub extern "c" fn moonbit_create_dir(dirname : CStr) -> Bool = "moonbit_create_dir"

///|
#borrow(dirname)
pub extern "c" fn moonbit_remove_dir(dirname : CStr) -> Bool = "moonbit_remove_dir"

///|
#borrow(filename)
pub extern "c" fn moonbit_file_create(filename : CStr) -> File = "moonbit_file_create"

///|
#borrow(buf)
pub extern "c" fn moonbit_file_read(
  file : File,
  buf : FixedArray[Byte],
  offset : Int,
  capacity : Int,
) -> Int = "moonbit_file_read"

///|
#borrow(buf)
pub extern "c" fn moonbit_file_write(
  file : File,
  buf : FixedArray[Byte],
  offset : Int,
  capacity : Int,
) -> Int = "moonbit_file_write"

///|
#borrow(bytes)
pub extern "c" fn moonbit_file_read_all(
  file : File,
  bytes : Bytes,
  capacity : Int,
) -> Int = "moonbit_file_read_all"

///|
#borrow(bytes)
pub extern "c" fn moonbit_file_write_all(
  file : File,
  bytes : Bytes,
  capacity : Int,
) -> Int = "moonbit_file_write_all"

///|
pub extern "c" fn moonbit_file_close(file : File) -> Bool = "moonbit_file_close"

///|
pub extern "c" fn moonbit_file_metadata_new() -> Metadata = "moonbit_file_metadata_new"

///|
#borrow(stat)
pub extern "c" fn moonbit_file_metadata(file : File, stat : Metadata) -> Bool = "moonbit_file_metadata"

///|
#borrow(stat)
pub extern "c" fn moonbit_file_metadata_filetype(stat : Metadata) -> FileType = "moonbit_file_metadata_filetype"

///|
pub extern "c" fn moonbit_metadata_filetype_is_dir(filetype : FileType) -> Bool = "moonbit_metadata_filetype_is_dir"

///|
pub extern "c" fn moonbit_metadata_filetype_is_file(
  filetype : FileType,
) -> Bool = "moonbit_metadata_filetype_is_file"

///|
pub extern "c" fn moonbit_metadata_filetype_is_symlink(
  filetype : FileType,
) -> Bool = "moonbit_metadata_filetype_is_symlink"

///|
#borrow(stat)
pub extern "c" fn moonbit_file_metadata_filesize(stat : Metadata) -> Int = "moonbit_file_metadata_filesize"

///|
#borrow(stat)
pub extern "c" fn moonbit_file_metadata_permissions(
  stat : Metadata,
) -> Permissions = "moonbit_file_metadata_permissions"

///|
pub extern "c" fn moonbit_metadata_permissions_readonly(
  perm : Permissions,
) -> Bool = "moonbit_metadata_permissions_readonly"

///|
pub extern "c" fn moonbit_stdin() -> File = "moonbit_stdin"

///|
pub extern "c" fn moonbit_stdout() -> File = "moonbit_stdout"
