///|
#cfg(platform="windows")
fn build_osstr(str : StringView, buf : @buffer.Buffer) -> Unit {
  buf.write_string_utf16le(str)
}

///|
#cfg(not(platform="windows"))
fn build_osstr(str : StringView, buf : @buffer.Buffer) -> Unit {
  buf.write_string_utf8(str)
}
