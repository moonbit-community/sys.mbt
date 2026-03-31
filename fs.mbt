///|
struct File(@ffi.File)

///|
struct FileType(@ffi.FileType)

///|
struct Metadata(@ffi.Metadata)

///|
struct Permissions(@ffi.Permissions)

///|
/// Open a file for reading.
/// If the file does not exist, a `SysError` is raised.
pub fn open_file(filename : StringView) -> File raise SysError {
  let filename = @cstr.build_cstr(filename)
  let file = @ffi.moonbit_file_open(filename)
  if @ffi.moonbit_file_is_invalid(file) {
    raise last_sys_error()
  } else {
    return File(file)
  }
}

///|
/// Creates a new file with the given filename.
/// If the file already exists, it will be truncated to zero length.
/// If the file cannot be created, a `SysError` is raised.
pub fn create_file(filename : StringView) -> File raise SysError {
  let filename = @cstr.build_cstr(filename)
  let file = @ffi.moonbit_file_create(filename)
  if @ffi.moonbit_file_is_invalid(file) {
    raise last_sys_error()
  } else {
    return file
  }
}

///|
pub fn remove_file(filename : StringView) -> Unit raise SysError {
  let filename = @cstr.build_cstr(filename)
  if !@ffi.moonbit_remove_file(filename) {
    raise last_sys_error()
  }
}

///|
pub fn create_dir(dirname : StringView) -> Unit raise SysError {
  let dirname = @cstr.build_cstr(dirname)
  if !@ffi.moonbit_create_dir(dirname) {
    raise last_sys_error()
  }
}

///|
pub fn remove_dir(dirname : StringView) -> Unit raise SysError {
  let filename = @cstr.build_cstr(dirname)
  if !@ffi.moonbit_remove_dir(filename) {
    raise last_sys_error()
  }
}

///|
pub fn File::close(self : File) -> Unit raise SysError {
  if !@ffi.moonbit_file_close(self.0) {
    raise last_sys_error()
  }
}

///|
pub fn File::metadata(self : File) -> Metadata raise SysError {
  let stat = @ffi.moonbit_file_metadata_new()
  let successfully_init_stat = @ffi.moonbit_file_metadata(self.0, stat)
  if successfully_init_stat {
    return stat
  } else {
    raise last_sys_error()
  }
}

///|
// pub fn File::symlink_metadata(self : File) -> Metadata? {
//   let stat = moonbit_file_metadata_new()
//   let successfully_init_stat = moonbit_file_symlink_metadata(self, stat)
//   if successfully_init_stat {
//     return Some(stat)
//   } else {
//     return None
//   }
// }

///|
pub fn Metadata::filesize(self : Metadata) -> Int {
  return @ffi.moonbit_file_metadata_filesize(self.0)
}

///|
pub fn Metadata::filetype(self : Metadata) -> FileType {
  return FileType(@ffi.moonbit_file_metadata_filetype(self.0))
}

///|
pub fn Metadata::is_dir(self : Metadata) -> Bool {
  return @ffi.moonbit_metadata_filetype_is_dir(self.filetype().0)
}

///|
pub fn Metadata::is_file(self : Metadata) -> Bool {
  return @ffi.moonbit_metadata_filetype_is_file(self.filetype().0)
}

///|
pub fn Metadata::is_symlink(self : Metadata) -> Bool {
  return @ffi.moonbit_metadata_filetype_is_symlink(self.filetype().0)
}

///|
pub fn Metadata::permissions(self : Metadata) -> Permissions {
  return @ffi.moonbit_file_metadata_permissions(self.0)
}

///|
pub fn Permissions::is_readonly(self : Permissions) -> Bool {
  return @ffi.moonbit_metadata_permissions_readonly(self.0)
}

///|
pub fn File::read(
  self : File,
  buf : FixedArray[Byte],
  offset? : Int = 0,
) -> Int raise SysError {
  let capacity = buf.length()
  let have_read = @ffi.moonbit_file_read(self.0, buf, offset, capacity)
  guard have_read >= 0 else { raise last_sys_error() }
  return have_read
}

///|
pub fn File::write(
  self : File,
  buf : FixedArray[Byte],
  offset? : Int = 0,
) -> Int raise SysError {
  let capacity = buf.length()
  let written = @ffi.moonbit_file_write(self.0, buf, offset, capacity)
  guard written >= 0 else { raise last_sys_error() }
  return written
}

///|
pub fn File::read_all(self : File) -> Bytes raise SysError {
  let metadata = self.metadata()
  let size = metadata.filesize()
  let buf = Bytes::make(size, 0)
  let have_read = @ffi.moonbit_file_read_all(self.0, buf, size)
  guard have_read == size else { raise last_sys_error() }
  return buf
}

///|
pub fn File::write_all(self : File, buf : Bytes) -> Unit raise SysError {
  let size = buf.length()
  let written = @ffi.moonbit_file_write_all(self.0, buf, size)
  guard written == size else { raise last_sys_error() }
}
