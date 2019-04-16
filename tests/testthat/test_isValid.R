#test_isValid.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#
context("isValidQQID")

test_that("corrupt input generates errors in isValidQQID()",  {
  expect_error(isValidQQID(NULL))                           # not character
  expect_error(isValidQQID(1))                              # not character
  expect_error(isValidQQID(list("a", "b")))                 # not character
  expect_error(isValidQQID(matrix(letters[1:4], ncol = 2))) # not vector
})

test_that("edge case input generates correct in isValidQQID()", {
  expect_equal(length(isValidQQID(character(0))), 0)
  expect_equal(isValidQQID(character(0)), logical(0))
  expect_equal(isValidQQID(NA_character_), FALSE)
  expect_true(is.na(isValidQQID(NA_character_, na.map = NA)))
  expect_equal(length(isValidQQID(NA_character_)), 1)
})

test_that("a valid input to isValidQQID() produces the expected output",  {
  expect_equal(isValidQQID("a"), FALSE)
  expect_equal(isValidQQID(c("a", "a")), c(FALSE, FALSE))
  expect_equal(isValidQQID(QQIDexample(1)), TRUE)
  expect_equal(isValidQQID(QQIDexample(1:2)), c(TRUE, TRUE))
  expect_equal(isValidQQID(c(QQIDexample(1), "a", NA), na.map = NA),
               c(TRUE, FALSE, NA))
  expect_equal(isValidQQID("aims.aims.AAAAAAAAAAAAAAAAAA"), TRUE)
  expect_equal(isValidQQID("zone.zone.__________________"), TRUE)
  expect_equal(isValidQQID("this.that.ABCDEFghijkl0123-_"), TRUE)
})

test_that("subtle errors in the QQIDs are caught by isValidQQID()",  {
  expect_equal(isValidQQID("cost.mice.IiIiIiIiIiIiIiIiIi"), TRUE)
  # Q-words must not be capitalized
  expect_equal(isValidQQID("COST.mice.IiIiIiIiIiIiIiIiIi"), FALSE)
  expect_equal(isValidQQID("cost.MICE.IiIiIiIiIiIiIiIiIi"), FALSE)
  # QQID words must exist in the Q-words vector
  expect_equal(isValidQQID("xxxx.mice.IiIiIiIiIiIiIiIiIi"), FALSE)
  expect_equal(isValidQQID("cost.xxxx.IiIiIiIiIiIiIiIiIi"), FALSE)
  # illegal characters
  expect_equal(isValidQQID("this.that.ABCDEFgh.jkl0123-_"), FALSE)
  expect_equal(isValidQQID("this.that-ABCDEFghijkl0123-_"), FALSE)
})

context("isValidUUID")

test_that("corrupt input generates errors in isValidUUID()",  {
  expect_error(isValidUUID(NULL))                           # not character
  expect_error(isValidUUID(1))                              # not character
  expect_error(isValidUUID(list("a", "b")))                 # not character
  expect_error(isValidUUID(matrix(letters[1:4], ncol = 2))) # not vector
})

test_that("edge case input generates correct in isValidUUID()", {
  expect_equal(length(isValidUUID(character(0))), 0)
  expect_equal(isValidUUID(character(0)), logical(0))
  expect_equal(isValidUUID(NA_character_), FALSE)
  expect_true(is.na(isValidUUID(NA_character_, na.map = NA)))
  expect_equal(length(isValidUUID(NA_character_)), 1)
})

test_that("a valid input to isValidUUID() produces the expected output",  {
  expect_equal(isValidUUID("a"), FALSE)
  expect_equal(isValidUUID(c("a", "a")), c(FALSE, FALSE))
  expect_equal(isValidUUID(UUIDexample(1)), TRUE)
  expect_equal(isValidUUID(UUIDexample(1:2)), c(TRUE, TRUE))
  expect_equal(isValidUUID(c(UUIDexample(1), "a", NA), na.map = NA),
               c(TRUE, FALSE, NA))
  expect_equal(isValidUUID("00000000-0000-0000-0000-000000000000"), TRUE)
  expect_equal(isValidUUID("ffffffff-ffff-ffff-ffff-ffffffffffff"), TRUE)
  expect_equal(isValidUUID("01234567-89ab-cdef-ABCD-EF0123456789"), TRUE)
})

test_that("subtle errors in the UUIDs are caught by isValidUUID()",  {
  # hyphens should be hyphens
  expect_equal(isValidUUID("01234567.89ab-cdef-ABCD-EF0123456789"), FALSE)
  expect_equal(isValidUUID("01234567-89ab.cdef-ABCD-EF0123456789"), FALSE)
  expect_equal(isValidUUID("01234567-89ab-cdef.ABCD-EF0123456789"), FALSE)
  expect_equal(isValidUUID("01234567-89ab-cdef-ABCD.EF0123456789"), FALSE)
  # character class should not allow blanks
  expect_equal(isValidUUID("012 4567-89ab-cdef-ABCD-EF0123456789"), FALSE)
  expect_equal(isValidUUID("01234567-89ab-c ef-ABCD-EF0123456789"), FALSE)
  expect_equal(isValidUUID("01234567-89ab-cdef-ABCD-EF0123 56789"), FALSE)
})

# [END]
