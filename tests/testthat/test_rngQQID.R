#test_rngQQID.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#
# ==== setup ===================================================================
#
# Note: the tests are not entirely RNG-safe i.e. it is not guaranteed that the
#       global state of the RNG is unchanged if testing aborts with an error.
#       To achieve that, we would probably need to wrap this test in a function
#       and then do the restorative assign() in an on.exit() call.
#
# Save current state of the RNG
# Conveniently using code idioms by Martin Maechler on R-Help 2019-04-17
if ( ! exists(".Random.seed", envir = .GlobalEnv)) { runif(1) }
oSeed <- .Random.seed

#
# ==============================================================================
context("rngQQID")

test_that("If .Random.seed does not exist, rngQQID creates, then removes it.", {
  if (exists(".Random.seed", envir = .GlobalEnv)) {
    rm(.Random.seed, envir = .GlobalEnv)
  }
  expect_true(isValidQQID(rngQQID(n = 1, method = "n")))
  expect_false(exists(".Random.seed", envir = .GlobalEnv))
})

set.seed(112358) # set working RNG state
intReference <- sample.int(.Machine$integer.max, 2)

set.seed(112358) # repeat working RNG state

test_that("the global RNG state is as expected",  {
  expect_equal(sample.int(.Machine$integer.max, 1), intReference[1])
})  # we test for intReference[2] at the end of our tests

test_that("corrupt input generates errors",  {
  expect_error(rngQQID(n = "a"))
  expect_error(rngQQID(n = 1:2))
  expect_error(rngQQID(method = "unk"))
  expect_error(rngQQID(RFC4122compliant = "not"))
})

test_that("NULL returns NULL",  {
  expect_true(is.null(rngQQID(NULL)))
})


# There is no reasonable test for the true random seed
test_that("valid numeric input produces the expected output",  {
  expect_equal(rngQQID(n = 1, method = "n"),
               "wolf.pail.jW_nrfROUrepp4nfsR")
  expect_equal(rngQQID(n = 1, method = "n"),   # same result again since we are
               "wolf.pail.jW_nrfROUrepp4nfsR") # resetting the RNG
  expect_equal(rngQQID(n = 1, method = "n", RFC4122compliant = FALSE),
               "wolf.pail.jW_nrfR-Qrepp4nfsR") # similar but different
               #                 ^^
})

test_that("the RNG state is properly restored on error",  {
  expect_error(rngQQID(n = 1, method = "t"), "wolf.pail.jW_nrfROUrepp4nfsR")
  expect_equal(rngQQID(n = 1, method = "n"),   # same result - the RNG state
               "wolf.pail.jW_nrfROUrepp4nfsR") # should be unchanged
})

test_that("the global RNG state has not been changed by our tests",  {
  expect_equal(sample.int(.Machine$integer.max, 1), intReference[2])
})


# ==== teardown ================================================================
#
# Restore original state of the RNG
assign(".Random.seed", oSeed, envir=.GlobalEnv)

# [END]
