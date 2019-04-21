# test_isValid.R
#
# (c) 2019 Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#          licensed under MIT (see file ./LICENSE).
#
context("is.QQID")

test_that("corrupt input generates errors in is.QQID()",  {
  expect_error(is.QQID(NULL))                           # not character
  expect_error(is.QQID(1))                              # not character
  expect_error(is.QQID(list("a", "b")))                 # not character
  expect_error(is.QQID(matrix(letters[1:4], ncol = 2))) # not vector
})

test_that("edge case input generates correct in is.QQID()", {
  expect_equal(length(is.QQID(character(0))), 0)
  expect_equal(is.QQID(character(0)), logical(0))
  expect_equal(is.QQID(NA_character_), FALSE)
  expect_true(is.na(is.QQID(NA_character_, na.map = NA)))
  expect_equal(length(is.QQID(NA_character_)), 1)
})

test_that("a valid input to is.QQID() produces the expected output",  {
  expect_equal(is.QQID("a"), FALSE)
  expect_equal(is.QQID(c("a", "a")), c(FALSE, FALSE))
  expect_equal(is.QQID(QQIDexample(1)), TRUE)
  expect_equal(is.QQID(QQIDexample(1:2)), c(TRUE, TRUE))
  expect_equal(is.QQID(c(QQIDexample(1), "a", NA), na.map = TRUE),
               c(TRUE, FALSE, TRUE))
  expect_equal(is.QQID(c(QQIDexample(1), "a", NA), na.map = FALSE),
               c(TRUE, FALSE, FALSE))
  expect_equal(is.QQID(c(QQIDexample(1), "a", NA), na.map = NA),
               c(TRUE, FALSE, NA))
  expect_equal(is.QQID("aims.aims.AAAAAAAAAAAAAAAAAA"), TRUE)
  expect_equal(is.QQID("zone.zone.__________________"), TRUE)
  expect_equal(is.QQID("this.that.ABCDEFghijkl0123-_"), TRUE)
  expect_equal(is.QQID("0c460ed3-b015-adc2-ab4a-01e093364f1f"), FALSE)
  expect_equal(as.vector(is.QQID(xltIDexample())), rep(FALSE, 5))
  # test the entire range of letters
  hLett <- c(0:9, LETTERS, letters, "-", "_")
  f <- function(x){ paste0("this.test.", paste0(rep(x, 18), collapse="")) }
  expect_true(all(is.QQID(sapply(hLett, f))))
  # test all Q-words in both positions
  f <- function(x){ sprintf("%s.%s.ABCDEFghijkl0123-_", x, x) }
  expect_true(all(is.QQID(sapply(qMap(0:1023), f))))
})

test_that("subtle errors in the QQIDs are caught by is.QQID()",  {
  expect_equal(is.QQID("cost.mice.IiIiIiIiIiIiIiIiIi"), TRUE)
  # Q-words must not be capitalized
  expect_equal(is.QQID("COST.mice.IiIiIiIiIiIiIiIiIi"), FALSE)
  expect_equal(is.QQID("cost.MICE.IiIiIiIiIiIiIiIiIi"), FALSE)
  # QQID words must exist in the Q-words vector
  expect_equal(is.QQID("xxxx.mice.IiIiIiIiIiIiIiIiIi"), FALSE)
  expect_equal(is.QQID("cost.xxxx.IiIiIiIiIiIiIiIiIi"), FALSE)
  # illegal characters
  expect_equal(is.QQID("this.that.ABCDEFgh.jkl0123-_"), FALSE)
  expect_equal(is.QQID("this.that-ABCDEFghijkl0123-_"), FALSE)
})

context("is.xlt")

test_that("corrupt input generates errors in is.UUID()",  {
  expect_error(is.xlt(NULL))                           # not character
  expect_error(is.xlt(1))                              # not character
  expect_error(is.xlt(list("a", "b")))                 # not character
  expect_error(is.xlt(matrix(letters[1:4], ncol = 2))) # not vector
})

test_that("edge case input generates correct in is.UUID()", {
  expect_equal(length(is.xlt(character(0))), 0)
  expect_equal(is.xlt(character(0)), logical(0))
  expect_equal(is.xlt(NA_character_), FALSE)
  expect_true(is.na(is.xlt(NA_character_, na.map = NA)))
  expect_equal(length(is.xlt(NA_character_)), 1)
})

test_that("a valid input to is.xlt() produces the expected output",  {
  expect_equal(is.xlt("a"), FALSE)
  expect_equal(is.xlt(c("a", "a")), c(FALSE, FALSE))
  expect_equal(is.xlt(xltIDexample(1)), TRUE)
  expect_equal(is.xlt(xltIDexample(1:2)), c(TRUE, TRUE))
  expect_equal(is.xlt(c(xltIDexample(1), "a", NA), na.map = TRUE),
               c(TRUE, FALSE, TRUE))
  expect_equal(is.xlt(c(xltIDexample(1), "a", NA), na.map = FALSE),
               c(TRUE, FALSE, FALSE))
  expect_equal(is.xlt(c(xltIDexample(1), "a", NA), na.map = NA),
               c(TRUE, FALSE, NA))
  expect_equal(is.xlt("00000000-0000-0000-0000-000000000000"), TRUE)
  expect_equal(is.xlt("ffffffff-ffff-ffff-ffff-ffffffffffff"), TRUE)
  expect_equal(is.xlt("01234567-89ab-cdef-ABCD-EF0123456789"), TRUE)
  expect_equal(is.xlt("bird.carp.7TsBWtwqtKAeCTNk8f"), FALSE)
})

test_that("subtle errors in the xlTs are caught by is.UUID()",  {
  # one character too short
  expect_equal(is.xlt("01234567-89ab-cdef-ABCD-EF012345678"), FALSE)
  # one character too long
  expect_equal(is.xlt("01234567-89ab-cdef-ABCD-EF01234567890"), FALSE)
  # no periods allowed
  expect_equal(is.xlt("01234567.89ab-cdef-ABCD-EF0123456789"), FALSE)
  expect_equal(is.xlt("01234567-89ab.cdef-ABCD-EF0123456789"), FALSE)
  expect_equal(is.xlt("01234567-89ab-cdef.ABCD-EF0123456789"), FALSE)
  expect_equal(is.xlt("01234567-89ab-cdef-ABCD.EF0123456789"), FALSE)
  # no blanks allowed
  expect_equal(is.xlt("012 4567-89ab-cdef-ABCD-EF0123456789"), FALSE)
  expect_equal(is.xlt("01234567-89ab-c ef-ABCD-EF0123456789"), FALSE)
  expect_equal(is.xlt("01234567-89ab-cdef-ABCD-EF0123 56789"), FALSE)
  # but we can substitute  : for - and vice versa
  expect_equal(is.xlt("01234567-89ab-cdef-ABCD-EF0123456789"), TRUE)
  expect_equal(is.xlt("01234567:89ab:cdef:ABCD:EF0123456789"), TRUE)
  expect_equal(is.xlt("0123:4567:89ab:cdef:ABCD:EF01:2345:6789"), TRUE)
  expect_equal(is.xlt("0123-4567-89ab-cdef-ABCD-EF01-2345-6789"), TRUE)
})

# [END]
