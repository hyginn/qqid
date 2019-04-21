#test_oltMap.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#
context("oltMap")

test_that("corrupt input generates errors",  {
  expect_error(oltMap(list(1:4)))
  expect_error(oltMap(NULL))            # not a vector
})

test_that("the r64 vector is sane and intact",  {
  expect_true(all( ! is.na(oltMap(1:64))))
  expect_true(all(grep("[A-za-z0-9_-]", oltMap(1:64))))
  expect_equal(length(unique(oltMap(1:64))), 64)
  expect_true(all(nchar(oltMap(1:64)) == 1))
  expect_true(all(nchar(names(oltMap(1:64))) == 6))
  expect_true(all(grepl("[01]{6}", names(oltMap(1:64)))))
  expect_equal(digest::digest(oltMap(1:64), algo = "md5"),
               "73a45886e81c77a15c1ea87f26a7b8fd")
  expect_equal(digest::digest(names(oltMap(1:64)), algo = "md5"),
               "99933ad788d4c90a98dd4c05410f518e")
})

test_that("a valid input produces the expected output",  {
  expect_equal(oltMap(1:3),
               c("000000" = "A", "000001" = "B", "000010" = "C"))
  expect_equal(oltMap(c("A", "B", "C")), c("000000", "000001", "000010"))
  expect_equal(oltMap(c("000000", "000001", "000010")),
               c("000000" = "A", "000001" = "B", "000010" = "C"))
})

# [END]
