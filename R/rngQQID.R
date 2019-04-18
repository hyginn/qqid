# rngQQID.R

#'rngQQID.
#'
#'\code{rngQQID} uses R's random number generator to generate a vector of
#'pseudorandom QQIDs.
#'
#'The function \code{rngQQID} generates a vector of \code{n} pseudo-random QQIDs
#'using R's inbuilt random number generator. Internally, the QQIDs are
#'constructed from randomly sampled individual bits, thus the resulting QQIDs do
#'not suffer from distributional issues that arise from mapping large floating
#'point numbers to a continuous range of integers.
#'
#'@section qQQIds vs. rngQQIDs: In theory the chance of a key collision between
#'  the pseudo-random QQIDs produced by \code{rngQQID()} is small if the RNG is
#'  initialized with a 64 bit number: a 50%% probability of at least one
#'  collision requires about 5^e09 keys. However, in practice this probability
#'  depends on the chance that two runs of the RNG are accidentally initialized
#'  with the same number, due to an improper use of \code{set.seed()} in another
#'  function, script or package. The only way to prevent this with certainty is
#'  to use true random keys (see \code{\link{qQQIDfactory}}). True random qQQIDs
#'  have a 50%% collision probability in 2.7e18 keys, and this is the same at
#'  all times, regardless of the state of the requesting machine. Thus unless
#'  throughput of keys is a critical concern it is advisable to use true random
#'  QQIDs over those returned by \code{rngQQID()}, or at least to initialize the
#'  RNG with true random seed with the default \code{method = "q"}.
#'
#'@section 128 vs. 122 bit random:  By default QQIDs produced with this function
#'  can be converted to \href{https://tools.ietf.org/html/rfc4122}{RFC 4122}
#'  compliant UUIDs. These use 6 bits to identify the method of UUID generation
#'  and thus contain only 12 random bits. It is possible to obtain 128-bit
#'  random QQIds from \code{rngQQID()}, by setting the parameter
#'  \code{RFC4122compliant} to \code{FALSE}. This increases the number space
#'  from 2^122 ≈ 5.3e+36 to 2^128 ≈ 3.4e+38 at the cost of no longer being
#'  compliant with the UUID standard.
#'
#'@section random seeds: The function supports three methods to seed R's RNG.
#'  The default method is \code{"q"} and will use a true random seed retrieved
#'  from the ANU quantum random number server. An alternative is \code{"r"} and
#'  uses R's inbuilt random initialization (cf. the behaviour of
#'  \code{set.seed(NULL)}\link{set.seed} at \link{set.seed}. Finally, the
#'  function can be run without a random seed with \code{"n"}, which allows
#'  either to define one's own sane randomization, or a seed for reproducible
#'  randomization - assuming that the risks are clearly understood. In all cases
#'  the current state of R's RNG is saved and restored upon exit, even if the
#'  function exits with an error. For testing purposes, saving the RNG state can
#'  be demonstrated with mode \code{"t"} which performs exactly one call to the
#'  RNG internally and then throws an error.
#'
#'@section Disclaimer: Although this function has been written and tested with
#'  care, no suitability for any particular purpose, in particular not for
#'  high-value transactions, for applications whose failure could endager life
#'  or property, or for cryptography is claimed. The source code is published in
#'  full and it is up to the user to audit the code for such and similar
#'  purposes.
#'
#'@param n (integer) The number of pseudo-random QQIDs to return. Default is 1.
#'@param method (character) Which random seed method to use. Default is
#'  \code{"q"}, a true random number seed, options are \code{"r"} (R's inbuilt
#'  RNG initialization),  \code{"n"} (no initialization, if desired a
#'  reproducible random seed can be set prior to this call, if one clearly
#'  understands the risks), \code{"t"} (test of error handling).
#'@param RFC4122compliant (logical) whether to base the QQID on version-stamped
#'  128-bit numbers with 122 random bits, compliant with RFC 4122 (default), or
#'  return QQIDs based on 128 random bits.
#'
#'@return (character) a vector of \code{n} QQIDs
#'
#'@author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#'@seealso \code{\link{qQQIDfactory}} to create a function that returns true
#'  random QQIDs.
#'
#' @examples
#' \dontrun{
#' # initialize the RNG with a true random number and return 5 QQIDs
#' # note the latency incurred by retrieving the seed from the ANU server
#' rngQQID(5)
#'
#' # return 10,000 QQIDS and transform them into UUIDs (takes less than two
#' # seconds); we assume that the RNG is in a sane state since we have just
#' previously initialized it with a true random number
#' x <- qq2uu(rngQQID(1e4, method = "n"))
#'
#' }
#'
#'@export

rngQQID <- function(n = 1, method = "q", RFC4122compliant = TRUE) {
  # n: number of QQids to return
  if(is.null(n)) { return(NULL) }
  stopifnot(is.numeric(n))
  stopifnot(length(n) == 1)
  stopifnot(method %in% c("q", "r", "n", "t"))
  stopifnot(is.logical(RFC4122compliant))

  testMode <- FALSE

  # save the original state of the RNG
  if ( ! exists(".Random.seed", envir = .GlobalEnv)) {
    oSeed <- NULL
  } else {
    oSeed <- .Random.seed
  }

  # ensure the original RNG state will be reset when we exit
  on.exit(if (is.null(oSeed)) {
    rm(".Random.seed", envir=.GlobalEnv)
  } else {
    assign(".Random.seed", oSeed, envir=.GlobalEnv)
  })

  # set the RNG seed, dependent on the requested method

  if (method == "q") { # retrieve a true random seed
    myM <- paste("rngQQID can't retrieve a true random seed from ANU server.",
                 "Possibly no Internet connection. Aborting." , sep = "\n")
    rs <- tryCatch(qrandom::qrandommaxint(1),
                   error = function(e) {
                     message(paste("Error:", myM))
                     NULL},
                   warning = function(w) {
                     message(paste("Warning:", myM))
                     NULL})
    if (is.null(rs)) {
      return(invisible(NULL))  # Abort ...
    } else {
      set.seed(rs)
    }
  } else if (method == "r") { # use R's initialization
    set.seed(NULL)
  } else if (method == "n") { # do nothing, assume seed is already set
    ;
  } else if (method == "t") { # don't change the RNG, prepare to exit
    testMode <- TRUE
    n <- 1
  } else {
    stop("Unknown method - but we should never get here.")
  }

  # generate matrix of n * 128 {0, 1}
  x <- matrix(sample(c(0, 1), 128 * n, replace = TRUE), nrow = n)

  if (RFC4122compliant) { # stamp UUID version
    x[ , 61] <- 0
    x[ , 62] <- 1
    x[ , 63] <- 0
    x[ , 64] <- 0

    x[ , 71] <- 0
    x[ , 72] <- 1
  }

  if (testMode) {
    stop(bitMat2QQ(x))
  }

  return(bitMat2QQ(x))

}


# [END]
