#test_rngQQID.R
#
# (c) 2019 Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#          licensed under MIT (see file ./LICENSE).
#
# ==== setup ===================================================================
#
# Note: the tests are not entirely RNG-safe i.e. it is not guaranteed that the
#       global state of the RNG is unchanged if testing aborts with an error.
#       To achieve that, we would need to wrap this test in a function
#       and then do the restorative assign() in an on.exit() call. Not doing
#       that for the sake of clarity in the testing code.
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
  expect_true(is.QQID(rngQQID(n = 1, method = "n")))
  expect_false(exists(".Random.seed", envir = .GlobalEnv))
})

set.seed(112358) # generate three markers for global env RNG State
rngReference <- sample.int(.Machine$integer.max, 3)

set.seed(112358) # generate 122 bit Reference State QQID
sample.int(.Machine$integer.max, 1) # advance working RNG by one
QQIDrefs <- rngQQID(n = 1, method = "n")
sample.int(.Machine$integer.max, 1) # advance working RNG by one
QQIDrefs[2] <- rngQQID(n = 1, method = "n")

set.seed(112358) # generate 128 bit Reference State QQID
sample.int(.Machine$integer.max, 1) # advance working RNG state
QQIDrefs[3] <- rngQQID(n = 1, method = "n", RFC4122compliant = FALSE)
names(QQIDrefs) <- c("122bit", "No.2", "128bit")

set.seed(112358) # reset RNG reference state

test_that("the global RNG state is as expected",  {
  expect_equal(sample.int(.Machine$integer.max, 1), rngReference[1])
})

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
               as.vector(QQIDrefs["122bit"]))
  expect_equal(rngQQID(n = 1, method = "n"),   # same result again since we are
               as.vector(QQIDrefs["122bit"]))  # resetting the RNG
  expect_equal(rngQQID(n = 1, method = "n", RFC4122compliant = FALSE),
               as.vector(QQIDrefs["128bit"]))  # similar but different
})

test_that("the RNG state is properly restored after internal reset",  {
  expect_false(rngQQID(n = 1, method = "R") ==
                 as.vector(QQIDrefs["122bit"])) # this time it's different
  test_that("the global RNG state has not been changed by our tests",  {
    expect_equal(sample.int(.Machine$integer.max, 1), rngReference[2])
  })
})

test_that("the RNG state is properly restored on error",  {
  expect_error(rngQQID(n = 1, method = "t"),
               as.vector(QQIDrefs["No.2"]))
  expect_equal(rngQQID(n = 1, method = "n"),  # same result - the RNG state
               as.vector(QQIDrefs["No.2"]))   # should be unchanged by the error
})

test_that("the global RNG state has not been changed by our tests",  {
  expect_equal(sample.int(.Machine$integer.max, 1), rngReference[3])
})

# ==== teardown ================================================================
#
# Restore original state of the RNG
assign(".Random.seed", oSeed, envir=.GlobalEnv)

# [END]
