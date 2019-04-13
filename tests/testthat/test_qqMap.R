#test_qqMap.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#
context("qqMap")

test_that("corrupt input generates errors",  {
  expect_error(qqMap(matrix(1:4)))
  expect_error(qqMap(list(1:4)))
  expect_error(qqMap(NULL))            # not a vector
})

test_that("the w1024 object is intact",  {
  expect_equal(digest::digest(qqMap(1:1024), algo = "md5"),
               "1973ec691ed0019d43dd695b79339517")
})

test_that("a valid numeric input produces the expected output",  {
  expect_equal(qqMap(numeric()), character(0))               # zero-length input
  expect_equal(qqMap(NA_integer_), NA_character_)            # single NA
  expect_equal(qqMap(c(-1, 0, 1025)), rep(NA_character_, 3)) # out-of-range
  expect_equal(qqMap(1:3), c("love", "maps", "ease"))
  expect_equal(qqMap(c(1022, NA, 1024)), c("hive", NA, "pump"))
})

test_that("a valid character input produces the expected output",  {
  expect_equal(qqMap(character()), numeric(0))               # zero-length input
  expect_equal(qqMap(NA_character_), NA_integer_)            # one NA
  expect_equal(qqMap(c("no", "0", "pasaran")), rep(NA_integer_, 3))
  expect_equal(qqMap(c("love", "maps", "ease")), 1:3)
  expect_equal(qqMap(c("hive", NA, "pump")), c(1022, NA, 1024))
})

# [END]
