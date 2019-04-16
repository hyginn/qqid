# rngQQID.R

#' rngQQID.
#'
#' \code{rngQQID} uses R's random number generator to generate a vector of
#' pseudorandom QQIDs.
#'
#' The function \code{rngQQID} generates a vector of \code{n} pseudo-random
#' QQIDs using R's inbuilt random number generator. Internally, the QQIDs are
#' constructed from randomly sampled individual bits, thus the resulting QQIDs
#' do not suffer from distributional issues that arise from mapping large
#' floating point numbers to a continuous range of integers.
#'
#'
#' @section qQQIds vs. rngQQIDs: In theory the chance of a key collision between
#'   the pseudo-random QQIDs produced by \code{rngQQID()} is small if the RNG is
#'   initialized with a 64 bit number: a 50%% probability of at least one
#'   collision requires about 5^e09 keys. However, in practice this probability
#'   depends on the chance that two runs of the RNG are accidentally initialized
#'   with the same number, due to an improper use of \code{set.seed()} in
#'   another function, script or package. The only way to prevent this with
#'   certainty is to use true random keys (see \code{\link{qQQIDfactory}}). True
#'   random qQQIDs have a 50%% collision probability in 2.7e18 keys, and this is
#'   the same at all times, regardless of the state of the requesting machine.
#'   Thus unless throughput of keys is a critical concern it is advisable to use
#'   true random QQIDs over those returned by \code{rngQQID()}, or at least to
#'   initialize the RNG with a seed returned from
#'   \code{qrandom::qrandommaxint()} immediately before using \code{rngQQID()}.
#'
#' @param n (integer) The number of pseudo-random QQIDs to return. Default is 1.
#'
#' @return (character) a vector of \code{n} QQIDs
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{qQQIDfactory}} to create a funcion that returns true
#'   random QQIDs.
#'
#' @examples
#' \dontrun{
#' # initialize the RNG with a random number and return 5 QQIDs
#' set.seed(qrandom::qrandommaxint())
#' rngQQID(5)
#'
#' # return 10,000 UUIDS (takes less than two seconds)
#' x <- qq2uu(rngQQID(1e4))
#'
#' }
#'
#' @export

rngQQID <- function(n = 1) {
  # n: number of QQids to return

  # generate matrix of n * 128 {0, 1}
  x <- matrix(sample(0:1, 128 * n, replace = TRUE), nrow = n)

  # stamp UUID version
  x[ , 61] <- 0
  x[ , 62] <- 1
  x[ , 63] <- 0
  x[ , 64] <- 0
  x[ , 71] <- 0
  x[ , 72] <- 1

  return(bitMat2QQ(x))
}


# [END]
