#test_qQQIDfactory.R
# Author: Boris Steipe <https://orcid.org/0000-0002-1134-6758>
#
# ==== setup ===================================================================
#
ANUnotReachable <- tryCatch(ifelse(nchar(qrandom::qUUID(1)) == 36, FALSE, TRUE),
                            error   = function(e) { TRUE },
                            warning = function(w) { TRUE })
#
# ==============================================================================
context("qQQIDfactory")

test_that("corrupt input generates errors",  {
  expect_error(testQQ <- qQQIDfactory(NULL))
  expect_error(testQQ <- qQQIDfactory(FALSE))
})

test_that("valid input produces the expected output",  {
  skip_if(ANUnotReachable)
  testQQ <- qQQIDfactory(nBatch = 5)
  expect_equal(length(testQQ(2)), 2)                   # is able to retrieve 2
  expect_equal(length(testQQ(2)), 2)                   # two more
  x <- capture_output(testQQ(5, inspectOnly = TRUE))
  expect_equal(length(unlist(strsplit(x, " "))), 2)    # one QQID in output
  newQQs <- testQQ(2)                                  # replenish cachce
  expect_equal(length(newQQs), 2)                      # successfully retrieved
  expect_equal(newQQs[1], substr(x, 6, 33))            # old == new[1]
  x <- capture_output(testQQ(10, inspectOnly = TRUE))  # four more in cache
  expect_equal(length(unlist(strsplit(x, " "))), 5)
})

# [END]
