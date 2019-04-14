#test_qqMap.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#
context("qqMap")

test_that("corrupt input generates errors",  {
  expect_error(qqMap(matrix(1:4)))
  expect_error(qqMap(list(1:4)))
  expect_error(qqMap(NULL))            # not a vector
})

test_that("the w1024 object is sane and intact",  {
  expect_true(all( ! is.na(qqMap(1:1024))))
  expect_equal(length(grep("[^a-z]", qqMap(1:1024))), 0)
  expect_equal(length(unique(qqMap(1:1024))), 1024)
  expect_true(all(nchar(qqMap(1:1024)) == 4))
  expect_equal(digest::digest(qqMap(1:1024), algo = "md5"),
               "88c215f0f964dd2bf399b38b35313ae0")
})

test_that("a valid numeric input produces the expected output",  {
  expect_equal(qqMap(numeric()), character(0))               # zero-length input
  expect_equal(qqMap(NA_integer_), NA_character_)            # single NA
  expect_equal(qqMap(c(-1, 0, 1025)), rep(NA_character_, 3)) # out-of-range
  expect_equal(qqMap(1:3), c("aims", "ants", "arch"))
  expect_equal(qqMap(c(1022, NA, 1024)), c("zest", NA, "zone"))
})

test_that("a valid character input produces the expected output",  {
  expect_equal(qqMap(character()), numeric(0))               # zero-length input
  expect_equal(qqMap(NA_character_), NA_integer_)            # one NA
  expect_equal(qqMap(c("no", "0", "pasaran")), rep(NA_integer_, 3))
  expect_equal(qqMap(c("aims", "ants", "arch")), 1:3)
  expect_equal(qqMap(c("zest", NA, "zone")), c(1022, NA, 1024))
})

# [END]
