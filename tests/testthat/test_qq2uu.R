# test_qq2uu.R
#
# (c) 2019 Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#          licensed under MIT (see file ./LICENSE).
#
context("qq2uu")

test_that("corrupt input generates errors",  {
  expect_error(qq2uu(NULL))
  expect_error(qq2uu(1))
  expect_error(qq2uu(c(UUIDexample(1), "oops")))
})

test_that("valid input produces the expected output",  {
  expect_equal(qq2uu(character()), character(0))            # zero-length input
  expect_equal(qq2uu(NA_character_), NA_character_)         # one NA
  expect_equal(qq2uu(QQIDexample(3)), as.vector(xltIDexample(3)))
  expect_equal(qq2uu(c(QQIDexample(3), NA)), as.vector(c(xltIDexample(3), NA)))
  expect_equal(qq2uu(c(NA, QQIDexample(3), NA, QQIDexample(3), NA)),
               as.vector(c(NA, xltIDexample(3), NA, xltIDexample(3), NA)))
  expect_equal(qq2uu("aims.aims.AAAAAAAAAAAAAAAAAA"),
                     "00000000-0000-0000-0000-000000000000")
  expect_equal(qq2uu("zone.zone.__________________"),
                     "ffffffff-ffff-ffff-ffff-ffffffffffff")
})

# [END]
