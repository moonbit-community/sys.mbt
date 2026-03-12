///|
struct CStr(Bytes)

///|
#cfg(platform="windows")
pub fn build_cstr(str : StringView) -> CStr {
  let buf = @buffer.new(size_hint=str.length() * 2 + 2)
  build_osstr(str, buf)
  buf.write_byte(0x00)
  buf.write_byte(0x00)
  CStr(buf.to_bytes())
}

///|
#cfg(not(platform="windows"))
pub fn build_cstr(str : StringView) -> CStr {
  let buf = @buffer.new(size_hint=str.length() * 2 + 1)
  build_osstr(str, buf)
  buf.write_byte(0x00)
  CStr(buf.to_bytes())
}
