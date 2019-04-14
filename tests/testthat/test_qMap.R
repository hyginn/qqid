#test_qMap.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#
context("qMap")

test_that("corrupt input generates errors",  {
  expect_error(qMap(matrix(1:4)))
  expect_error(qMap(list(1:4)))
  expect_error(qMap(NULL))            # not a vector
})

test_that("the w1024 object is sane and intact",  {
  expect_true(all( ! is.na(qMap(1:1024))))
  expect_equal(length(grep("[^a-z]", qMap(1:1024))), 0)
  expect_equal(length(unique(qMap(1:1024))), 1024)
  expect_true(all(nchar(qMap(1:1024)) == 4))
  expect_equal(digest::digest(qMap(1:1024), algo = "md5"),
               "88c215f0f964dd2bf399b38b35313ae0")
})

test_that("a valid numeric input produces the expected output",  {
  expect_equal(qMap(numeric()), character(0))               # zero-length input
  expect_equal(qMap(NA_integer_), NA_character_)            # single NA
  expect_equal(qMap(c(-1, 0, 1025)), rep(NA_character_, 3)) # out-of-range
  expect_equal(qMap(1:3), c("aims", "ants", "arch"))
  expect_equal(qMap(c(1022, NA, 1024)), c("zest", NA, "zone"))
})

test_that("a valid character input produces the expected output",  {
  expect_equal(qMap(character()), numeric(0))               # zero-length input
  expect_equal(qMap(NA_character_), NA_integer_)            # one NA
  expect_equal(qMap(c("no", "0", "pasaran")), rep(NA_integer_, 3))
  expect_equal(qMap(c("aims", "ants", "arch")), 1:3)
  expect_equal(qMap(c("zest", NA, "zone")), c(1022, NA, 1024))
})

# [END]
