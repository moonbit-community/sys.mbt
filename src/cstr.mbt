///|
priv struct CStr(Bytes)

///|
trait AsCStr {
  to_cstr(Self) -> CStr
}

///|
pub impl AsCStr for OsStr with to_cstr(self) {
  if moonbit_os_iswin32() {
    // UTF-16 NULL terminator
    self.0 + "\x00\x00"
  } else {
    self.0 + "\x00"
  }
}

///|
pub impl AsCStr for OsStrBuilder with to_cstr(self) {
  if moonbit_os_iswin32() {
    // UTF-16 NULL terminator
    self.0.write_byte(0x00)
    self.0.write_byte(0x00)
  } else {
    self.0.write_byte(0x00)
  }
  return CStr(self.0.contents())
}

///|
pub impl AsCStr for String with to_cstr(self) {
  return OsStr::from(self[:]).to_cstr()
}

///|
pub impl AsCStr for StringView with to_cstr(self) {
  return OsStr::from(self).to_cstr()
}

///|
pub impl AsCStr for Path with to_cstr(self) {
  return self.0.to_cstr()
}
