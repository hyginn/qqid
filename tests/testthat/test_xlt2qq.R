#test_xlt2qq.R
#
# (c) 2019 Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#          licensed under MIT (see file ./LICENSE).
#
context("xlt2qq")

test_that("corrupt input generates errors",  {
  expect_error(xlt2qq(1))
  expect_error(xlt2qq(c(UUIDexample(1), "oops")))  # 1: valid, 2: invalid
})

test_that("valid input produces the expected output",  {
  expect_equal(length(xlt2qq(NULL)), 0)
  expect_equal(xlt2qq(character()), character(0))            # zero-length input
  expect_equal(xlt2qq(NA_character_), NA_character_)         # one NA
  expect_equal(xlt2qq(xltIDexample(1)), QQIDexample(1))
  expect_equal(xlt2qq(c(xltIDexample(1), NA)), c(QQIDexample(1), NA))
  expect_equal(xlt2qq(c(NA, xltIDexample(1:2), NA, xltIDexample(3:5), NA)),
               c(NA, QQIDexample(1:2), NA, QQIDexample(3:5), NA))
  expect_equal(xlt2qq(xltIDexample("md5")),  QQIDexample(1))
  expect_equal(xlt2qq(xltIDexample("hex")),  QQIDexample(2))
  expect_equal(xlt2qq(xltIDexample("UUID")), QQIDexample(3))
  expect_equal(xlt2qq(xltIDexample("IPv6")), QQIDexample(4))
  expect_equal(xlt2qq(xltIDexample("hEx")),  QQIDexample(5))
  expect_equal(xlt2qq("00000000-0000-0000-0000-000000000000"),
                     "aims.aims.AAAAAAAAAAAAAAAAAA")
  expect_equal(xlt2qq("FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF"),
                     "zone.zone.__________________")
})

# [END]
