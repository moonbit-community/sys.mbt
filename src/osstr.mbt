///|
struct OsStrBuilder(@buffer.T)

///|
extern "c" fn moonbit_os_iswin32() -> Bool = "moonbit_os_iswin32"

///|
pub fn OsStrBuilder::new(size_hint~ : Int = 20) -> OsStrBuilder {
  return OsStrBuilder(@buffer.new(size_hint~))
}

///|
pub fn OsStrBuilder::from(view : @string.View) -> OsStrBuilder {
  let buf = OsStrBuilder(@buffer.new(size_hint=view.length() * 4))
  buf.push(view)
  return buf
}

///|
pub fn OsStrBuilder::from_osstr(osstr : OsStr) -> OsStrBuilder {
  let buf = OsStrBuilder(@buffer.new(size_hint=osstr.inner().length() * 4))
  buf.push_osstr(osstr.inner())
  return buf
}

///|
pub fn OsStrBuilder::push(self : OsStrBuilder, str : @string.View) -> Unit {
  if moonbit_os_iswin32() {
    self.inner().write_stringview(str)
  } else {
    @encoding.encode_to(str, self.inner(), encoding=UTF8)
  }
}

///|
pub fn OsStrBuilder::push_osstr(self : OsStrBuilder, osstr : OsStr) -> Unit {
  self.inner().write_bytes(osstr.inner())
}

///|
pub fn OsStrBuilder::to_osstr(self : OsStrBuilder) -> OsStr {
  return OsStr(self.inner().contents())
}

///|
struct OsStr(Bytes)

///|
pub fn OsStr::from(str : @string.View) -> OsStr {
  OsStrBuilder::from(str).to_osstr()
}

///|
pub impl Add for OsStr with op_add(self : OsStr, other : OsStr) {
  self.inner() + other.inner()
}

///|
pub impl Show for OsStr with output(self, logger) {
  logger.write_string("OsStr(\"")
  if moonbit_os_iswin32() {
    logger.write_string(self.inner().to_unchecked_string())
  } else {
    let decoder = @encoding.decoder(UTF8)
    logger.write_string(decoder.decode_lossy(self.inner()))
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
