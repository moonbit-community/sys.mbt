///|
let path_separator : String = if moonbit_os_iswin32() { "\\" } else { "/" }

///|
struct Path(OsStr)

///|
pub fn Path::op_add(self : Path, other : Path) -> Path {
  self.0 + other.0
}

///|
pub fn Path::from(view : StringView) -> Path {
  Path(OsStrBuilder::from(view).to_osstr())
}

///|
pub fn Path::join(self : Path, other : ArrayView[StringView]) -> Path {
  let buf = OsStrBuilder::from_osstr(self.0)
  for str in other {
    buf.push(path_separator)
    buf.push(str)
  }
  buf.to_osstr()
}

///|
pub fn Path::as_view(self : Path) -> BytesView {
  self.0.0[:]
}

///|
trait AsPath: AsCStr {
  to_path(Self) -> Path
}

///|
pub impl AsPath for Path with to_path(self) {
  return self
}

///|
pub impl AsPath for StringView with to_path(self) {
  return Path::from(self)
}

///|
pub impl AsPath for String with to_path(self) {
  return Path::from(self[:])
}

///|
pub impl AsPath for OsStr with to_path(self) {
  return Path(self)
}

// \\?\

///|
let verbatim_prefix : String = "\\\\?\\"

// \??\

///|
let nt_prefix : String = "\\??\\"

// \\?\UNC\

///|

///|
fn maybe_verbatim(path : Path) -> OsStr {
  // assume path utf16 encoded and non-empty
  if path.0.0.to_unchecked_string().has_prefix(verbatim_prefix) ||
    path.0.0.to_unchecked_string().has_prefix(nt_prefix) {
    // Early return for paths that are already verbatim
    return path.0
  }
  // Return the path as-is if no verbatim prefix is found
  path.0
}
