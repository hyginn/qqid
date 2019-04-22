# rngQQID.R

#'rngQQID
#'
#'\code{rngQQID} uses R's random number generator to generate a vector of
#'pseudo-random QQIDs.
#'
#'The function \code{rngQQID} generates a vector of \code{n} pseudo-random QQIDs
#'using R's inbuilt random number generator. Internally, the QQIDs are
#'constructed from randomly sampled individual bits, thus the resulting QQIDs do
#'not suffer from distributional issues that arise from mapping large floating
#'point numbers to a continuous range of integers. The function takes care not
#'to change the global state of the RNG in \code{.Random.seed}.
#'
#'@section qQQIDs vs. rngQQIDs: Whether to use true random or pseudo-random
#'  QQIDs is a tradeoff between speed and safety. The ANU quantum  random number
#'  server can have considerable latency (a problem that \code{qQQIDfactory}
#'  addresses through caching), but pseudo-random numbers may not be
#'  sufficiently collision-safe for use cases that depend on the uniqueness of
#'  the resulting numbers: while the RNGs provided by R are very good, all RNGs
#'  potentially suffer from the possibility of an \strong{initialization}
#'  collision, i.e. when two runs of the RNG are accidentally initialized with
#'  the same seed, due to an improper and/or unrecognized use of
#'  \code{set.seed()} in another function, script or package, or due to the
#'  limited randomness of time- and machine-state based seeds. This is not a
#'  problem for long runs of key-generation on a single machine, but it may be
#'  an issue for the decentralized generation of random unique keys, which is
#'  the design use case of \code{qqid}. The only way to prevent this with
#'  certainty is to use true random keys (as provided with this function). True
#'  random qQQIDs have a 50\% collision probability in \eqn{\approx 2.7 \times
#'  10^{18}}{=~ 2.7e+18} keys, and this is the same at all times, regardless of
#'  the state of the requesting machine. Thus unless throughput of keys is a
#'  critical concern, it is advisable to use true random QQIDs from a
#'  \code{qQQIDfactory} closure over those returned by a
#'  \code{\link[=rngQQID]{rngQQID()}} process, or at least to initialize the RNG
#'  with a true random seed (method "q", the default option for \code{rngQQID}).
#'
#'@section 128 vs. 122 bit random:  By default, QQIDs produced with
#'  \code{rngQQID()} can be converted to
#'  \href{https://tools.ietf.org/html/rfc4122}{RFC 4122} compliant UUIDs. These
#'  use 6 bits to identify the method of UUID generation and thus contain only
#'  122 random bits. It is possible to obtain 128-bit random QQIDs from
#'  \code{rngQQID()}, by setting the parameter \code{RFC4122compliant} to
#'  \code{FALSE}. This increases the number space from \eqn{2^{122} \approx 5.3
#'  \times 10^{36}}{2^122 =~ 5.3e+36} to \eqn{2^{128} \approx 3.4 \times
#'  10^{38}}{2^128 =~ 3.4e+38} at the cost of no longer being compliant with the
#'  UUID standard.
#'
#'@section Random seeds: The function supports three methods to seed R's RNG.
#'  The default method is \code{"q"} and uses a true random seed retrieved from
#'  the ANU quantum random number server. An alternative method is \code{"r"},
#'  which uses R's inbuilt random initialization (cf. the behaviour of
#'  \code{set.seed(NULL)} in the \link[=set.seed]{set.seed()} documentation).
#'  Finally, the function can be run without a random seed with \code{"n"},
#'  which allows either to define one's own sane RNG initialization, or use a
#'  specific seed for reproducible randomization - assuming that the risks are
#'  clearly understood. In all cases, the current state of R's RNG is saved and
#'  restored upon exit, even if the function exits with an error. For testing
#'  purposes, saving the RNG state can be demonstrated with method \code{"t"}
#'  which does not change the global random seed, creates exactly one random
#'  128-bit number internally, and then throws an error to exit the function
#'  which should restore \code{.Random.seed}.
#'
#'@section Warning - parallelization: If you are executing code in parallel on
#'  separate processors, you must make sure that every task uses its own,
#'  separately initialized state of the global variable \code{.Random.seed} and
#'  not a copy of a single instance of the global environment - such copies will
#'  produce exactly identical QQIDs unless reinitialized after the task is
#'  deployed.
#'
#'@section Disclaimer and caution: Although this function has been written and
#'  tested with care, no suitability for any particular purpose, in particular
#'  no suitability for high-value transactions, for applications whose failure
#'  could endanger life or property, or for cryptography is claimed. The source
#'  code is published in full and it is up to the user to audit and adapt the
#'  code for their own purposes and needs.
#'
#'@param n (integer) The number of pseudo-random QQIDs to return. Default is 1.
#'@param method (character) Which random seed method to use. Default is
#'  \code{"q"}, a true random number seed. Other options are \code{"R"} (R's
#'  inbuilt RNG initialization),  \code{"n"} (no initialization, a reproducible
#'  random seed can be set prior to this call if one clearly understands the
#'  risks), \code{"t"} (test of error handling).
#'@param RFC4122compliant (logical) whether to base the QQID on version-stamped
#'  128-bit numbers with 122 random bits, compliant with RFC 4122 (default), or
#'  to return QQIDs based on 128 random bits.
#'
#'@return (character) a vector of \code{n} QQIDs
#'
#'@seealso \code{\link[=qQQIDfactory]{qQQIDfactory()}} to create a closure that
#'  returns cached, true random QQIDs.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' \dontrun{
#'
#' # initialize the RNG with a true random number and return 5 QQIDs
#' # note the latency incurred by retrieving the seed from the ANU server
#' rngQQID(5)
#'
#' # return 10,000 QQIDs and transform them into UUIDs (takes less than two
#' # seconds); we assume that the RNG is in a sane state since we have just
#' previously initialized it with a true random number
#' x <- qq2uu(rngQQID(1e4, method = "n"))
#' }
#'
#'@export

rngQQID <- function(n = 1, method = "q", RFC4122compliant = TRUE) {
  # n: number of QQids to return
  if(is.null(n)) { return(NULL) }
  stopifnot(is.numeric(n))
  stopifnot(length(n) == 1)
  stopifnot(method %in% c("q", "R", "n", "t"))
  stopifnot(is.logical(RFC4122compliant))

  testMode <- FALSE

  # save the original state of the RNG
  if ( ! exists(".Random.seed", envir = .GlobalEnv)) {
    oSeed <- NULL
    set.seed(NULL) # initialize with normal inbuilt seed
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
  } else if (method == "R") { # use R's initialization
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
  x <- matrix(sample(c(0, 1), 128 * n, replace = TRUE),
              byrow = TRUE, #<--- This is an important safety issue:
              nrow = n)         # previously repeated runs with the same seed
                                # appeared deceptively different, if they had
                                # diffferent lengths. Now, we will get
                                # identical IDs, and we WILL have collisions.
                                # However we can easily notice
                                # this by comparing the head()s of the vectors.

  if (RFC4122compliant) { # stamp UUID version 4 code
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
