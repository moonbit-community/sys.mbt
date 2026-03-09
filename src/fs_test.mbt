///|
fn create_then_remove_file(filename : String) -> Unit raise @sys.SysError {
  let file = @sys.create_file(filename)
  file.close()
  return @sys.remove_file(filename)
}

///|
fn create_then_remove_dir(dirname : String) -> Unit raise @sys.SysError {
  @sys.create_dir(dirname)
  return @sys.remove_dir(dirname)
}

///|
test {
  create_then_remove_file("blobs/temp.txt")
  create_then_remove_dir("blobs/temp")
}

///|
fn create_when_exist(filename : String) -> Unit raise @sys.SysError {
  // will clear file contents
  let file = @sys.create_file(filename)
  file.close()
}

///|
test {
  create_when_exist("blobs/empty.txt")
}

///|
fn filesize(filename : String) -> Int raise Error {
  let file = @sys.open_file(filename) catch {
    _ => fail("Failed to open file: \{filename}")
  }
  let metadata = file.metadata() catch {
    _ => fail("Failed to retrieve metadata for file: \{filename}")
  }
  metadata.filesize()
}

///|
fn isdir(filename : String) -> Bool raise Error {
  let file = @sys.open_file(filename) catch {
    _ => fail("Failed to open file: \{filename}")
  }
  let metadata = file.metadata() catch {
    _ => fail("Failed to retrieve metadata for file: \{filename}")
  }
  metadata.is_dir()
}

///|
test {
  assert_true(isdir("blobs/"))
  assert_false(isdir("blobs/not_dir.txt"))
}

///|
test {
  inspect(filesize("blobs/foo.txt"), content="6")
  inspect(filesize("blobs/bar.txt"), content="17")
}

///|
fn read_all(filename : String) -> Bytes raise @sys.SysError {
  let file = @sys.open_file(filename)
  let bytes = file.read_all()
  file.close()
  return bytes
}

///|
fn read(filename : String, content : Bytes) -> Unit raise Error {
  let file = @sys.open_file(filename)
  let buf = FixedArray::make(content.length(), b'\x00')
  let bytes_read = file.read(buf)
  file.close()
  for i in 0..<bytes_read {
    if buf[i] != content[i] {
      raise fail("buf[\{i}] = \{buf[i]}, content[\{i}] = \{content[i]}")
    }
  }
}

///|
test {
  read("blobs/rfoo.txt", b"\x41\x42\x43\x44\x45\x46")
  read(
    "blobs/rbar.txt", b"\x31\x30\x0a\x31\x31\x0a\x31\x32\x0a\x31\x33\x0a\x31\x34\x0a\x31\x35",
  )
}

///|
test {
  inspect(
    read_all("blobs/rfoo.txt"),
    content=(
      #|b"ABCDEF"
    ),
  )
  inspect(
    read_all("blobs/rbar.txt"),
    content=(
      #|b"10\x0a11\x0a12\x0a13\x0a14\x0a15"
    ),
  )
  assert_true(
    (try? read_all("not_exist.txt")).map_err(err => err.kind()) is Err(NotFound),
  )
}

///|
fn write_all(filename : String, content : Bytes) -> Unit raise Error {
  let file = @sys.create_file(filename) catch {
    _ => fail("File::create(): \{filename} failed")
  }
  file.write_all(content) catch {
    _ => fail("File::write_all(): \{filename} failed")
  }
  file.close()
}

///|
test {
  write_all("blobs/wfoo.txt", b"\x41\x42\x43\x44\x45\x46")
  write_all(
    "blobs/wbar.txt", b"\x31\x30\x0a\x31\x31\x0a\x31\x32\x0a\x31\x33\x0a\x31\x34\x0a\x31\x35",
  )
  let bar2 = @sys.create_file("blobs/wbar2.txt")
  bar2.write_all(b"\x31\x30\x0a")
  bar2.write_all(b"\x31\x31\x0a")
  bar2.write_all(b"\x31\x32\x0a")
  bar2.write_all(b"\x31\x33\x0a")
  bar2.write_all(b"\x31\x34\x0a")
  bar2.write_all(b"\x31\x35")
  bar2.close()
}
