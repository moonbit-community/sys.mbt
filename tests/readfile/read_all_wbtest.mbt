///|
test {
  inspect(
    test_read_all("readfile/foo.txt"),
    content=(
      #|b"ABCDEF"

    ),
  )
  inspect(
    test_read_all("readfile/bar.txt"),
    content=(
      #|b"10\x0a11\x0a12\x0a13\x0a14\x0a15"

    ),
  )
  inspect(
    (try? test_read_all("no_exist.txt")).map_err(_.kind()),
    content="Err(NotFound)",
  )
}
