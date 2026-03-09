///|
struct OsStrBuilder(@buffer.Buffer)

///|
extern "c" fn moonbit_os_iswin32() -> Bool = "moonbit_os_iswin32"

///|
pub fn OsStrBuilder::new(size_hint? : Int = 20) -> OsStrBuilder {
  return OsStrBuilder(@buffer.new(size_hint~))
}

///|
pub fn OsStrBuilder::from(view : StringView) -> OsStrBuilder {
  let buf = OsStrBuilder(@buffer.new(size_hint=view.length() * 4))
  buf.push(view)
  return buf
}

///|
pub fn OsStrBuilder::from_osstr(osstr : OsStr) -> OsStrBuilder {
  let buf = OsStrBuilder(@buffer.new(size_hint=osstr.0.length() * 4))
  buf.push_osstr(osstr.0)
  return buf
}

///|
pub fn OsStrBuilder::push(self : OsStrBuilder, str : StringView) -> Unit {
  if moonbit_os_iswin32() {
    self.0.write_string_utf16le(str)
  } else {
    self.0.write_string_utf8(str)
  }
}

///|
pub fn OsStrBuilder::push_osstr(self : OsStrBuilder, osstr : OsStr) -> Unit {
  self.0.write_bytes(osstr.0)
}

///|
pub fn OsStrBuilder::to_osstr(self : OsStrBuilder) -> OsStr {
  return OsStr(self.0.contents())
}

///|
struct OsStr(Bytes)

///|
pub fn OsStr::from(str : StringView) -> OsStr {
  OsStrBuilder::from(str).to_osstr()
}

///|
pub impl Add for OsStr with add(self : OsStr, other : OsStr) {
  self.0 + other.0
}

///|
pub impl Show for OsStr with output(self, logger) {
  logger.write_string("OsStr(\"")
  if moonbit_os_iswin32() {
    logger.write_string(self.0.to_unchecked_string())
  } else {
    logger.write_string(@utf8.decode_lossy(self.0))
  }
  logger.write_string("\")")
}

///|
test {
  inspect(
    OsStr::from("/tmp"),
    content=(
      #|OsStr("/tmp")
    ),
  )
  inspect(
    OsStr::from("/etc/passwd"),
    content=(
      #|OsStr("/etc/passwd")
    ),
  )
}
