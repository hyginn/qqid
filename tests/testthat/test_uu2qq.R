#test_uu2qq.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#
context("uu2qq")

test_that("corrupt input generates errors",  {
  expect_error(uu2qq(NULL))
  expect_error(uu2qq(1))
  expect_error(uu2qq(c(UUIDexample(1), "oops")))
})

test_that("valid input produces the expected output",  {
  expect_equal(uu2qq(character()), character(0))            # zero-length input
  expect_equal(uu2qq(NA_character_), NA_character_)         # one NA
  expect_equal(uu2qq(UUIDexample(1)), QQIDexample(1))
  expect_equal(uu2qq(c(UUIDexample(1), NA)), c(QQIDexample(1), NA))
  expect_equal(uu2qq(c(NA, UUIDexample(1:2), NA, UUIDexample(3:5), NA)),
               c(NA, QQIDexample(1:2), NA, QQIDexample(3:5), NA))
  expect_equal(uu2qq(UUIDexample()), QQIDexample())
  expect_equal(uu2qq("00000000-0000-0000-0000-000000000000"),
                     "aims.aims.AAAAAAAAAAAAAAAAAA")
  expect_equal(uu2qq("ffffffff-ffff-ffff-ffff-ffffffffffff"),
                     "zone.zone.__________________")
})

# [END]
