#test_qq2uu.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
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
  expect_equal(qq2uu(QQIDexample(1)), UUIDexample(1))
  expect_equal(qq2uu(c(QQIDexample(1), NA)), c(UUIDexample(1), NA))
  expect_equal(qq2uu(QQIDexample()), UUIDexample())
  expect_equal(qq2uu("aims.aims-000-0000-0000-0000-000000000000"),
                     "00000000-0000-0000-0000-000000000000")
  expect_equal(qq2uu("zone.zone-fff-ffff-ffff-ffff-ffffffffffff"),
                     "ffffffff-ffff-ffff-ffff-ffffffffffff")
})

# [END]
