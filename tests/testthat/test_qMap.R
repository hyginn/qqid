# test_qMap.R
#
# (c) 2019 Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#          licensed under MIT (see file ./LICENSE).
#
context("qMap")

test_that("corrupt input generates errors",  {
  expect_error(qMap(matrix(1:4)))
  expect_error(qMap(list(1:4)))
  expect_error(qMap(NULL))            # not a vector
})

test_that("the internal Q vector object is sane and intact",  {
  expect_true(all( ! is.na(qMap(0:1023))))
  expect_equal(length(grep("[^a-z]", qMap(0:1023))), 0)
  expect_equal(length(unique(qMap(0:1023))), 1024)
  expect_true(all(nchar(qMap(0:1023)) == 4))
  expect_equal(digest::digest(qMap(0:1023), algo = "md5"),
               "9daefc4895c1ec41bcf78d23c99ed4dc")
})

test_that("a valid numeric input produces the expected output",  {
  expect_equal(qMap(numeric()), character(0))               # zero-length input
  expect_equal(qMap(NA_integer_), NA_character_)            # single NA
  expect_equal(qMap(c(-1, 1024)), rep(NA_character_, 2)) # out-of-range
  expect_equal(qMap(0:2), c("aims", "ants", "arch"))
  expect_equal(qMap(c(1021, NA, 1023)), c("zest", NA, "zone"))
})

test_that("a valid character input produces the expected output",  {
  expect_equal(qMap(character()), numeric(0))               # zero-length input
  expect_equal(qMap(NA_character_), NA_integer_)            # one NA
  expect_equal(qMap(c("no", "0", "pasaran")), rep(NA_integer_, 3))
  expect_equal(qMap(c("aims", "ants", "arch")), 0:2)
  expect_equal(qMap(c("zest", NA, "zone")), c(1021, NA, 1023))
})

# [END]
