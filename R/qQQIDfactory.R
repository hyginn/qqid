# qQQIDfactory.R

#'qQQIDfactory
#'
#'\code{qQQIDfactory} returns a closure (a function with an associated
#'environment) that retrieves, caches, and returns quantum-random QQIDs.
#'
#'In what follows we will call the closure that is produced by
#'\code{qQQIDfactory}  "\code{qQQID()}" (even though you could assign it to a
#'different name). The function factory \code{qQQIDfactory} and the
#'\code{qQQID()} closure address a latency problem that arises when we retrieve
#'true random numbers from the \href{https://qrng.anu.edu.au/index.php}{ANU
#'Quantum Random Number Generator} at the Australian National University.
#'\code{qQQIDfactory} produced closures maintain a local cache of true random
#'QQIDs, which can be accessed without latency. In a design use case,
#'\code{qQQID()} could be produced in an R session startup script. From that
#'point on, latency in generating true random QQIDs is only experienced
#'occasionally when the cache needs to be replenished.
#'
#'@section Usage: \code{qQQIDfactory}produces a closure which is meant to be
#'  assigned to a variable and called by that variable name (see examples).
#'  While any legal variable name can be used, assigning to "\code{qQQID}" is
#'  recommended. Producing the closure requires an Internet connection to first
#'  fill the closure's cache of QQID values. Once the cache is filled, no
#'  Internet connection is required until the cache is depleted and the closure
#'  attempts to replenish it. If replenishing the cache fails because of a
#'  failure to open a connection to the ANU server, an informative message is
#'  printed and the closure returns \code{NULL} invisibly. If there are
#'  remaining QQIDs in the cache, these can be retrieved by requesting no more
#'  than the number that currently exist in the cache. The closure either
#'  returns the requested number of QQIDs, or NULL, but it will never return
#'  fewer than the requested number of QQIDs, since implicit recycling of
#'  shorter vectors would be a critical failure mode for a function that is
#'  expected to return unique identifiers.
#'
#'@section Properties of the produced QQIDs: Internally, \code{qQQID} converts
#'  true random UUIDs obtained from \code{qrandom::qUUID}. These UUIDs are
#'  \href{https://tools.ietf.org/html/rfc4122}{RFC 4122} compliant and contain a
#'  six-bit version code, and 122 random bits. Such RFC compliant QQIDs are
#'  drawn from \eqn{2^{122} \approx 5.3 \times 10^{36}}{2^122 =~ 5.3e+36}
#'  possibilities, whereas totally random 128-bit numbers are drawn from a
#'  \eqn{\approx 3.4 \times 10^{38}}{=~ 3.4e+38} number space. The 50\%
#'  collision probability of random 122-bit numbers is \eqn{\approx 2.7 \times
#'  10^{18}}{=~ 2.7e+18} numbers, while for 128-bit numbers it is \eqn{\approx
#'  2.2 \times 10^{19}}{=~ 2.2e+19}.
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
#'  with a true random seed (the default option for
#'  \code{\link[=rngQQID]{rngQQID()}}).
#'
#'@section Caching QQIDs to avoid latency: The ANU server produces true random
#'  numbers from quantum fluctuations of the vacuum. The high latency of
#'  requests for quantum random numbers from the ANU server - between 6 to 10
#'  seconds per request - is practically independent of the size of the
#'  request's payload. This suggests a strategy to serve keys from a local
#'  cache. R provides an elegant way of doing this by defining functions as
#'  closures - i.e. along with their own environment. This function environment
#'  allows to maintain state between function calls. \code{qQQIDfactory}
#'  retrieves 1023 qQQIDs and caches them in the environment of \code{qQQID}.
#'  The \code{qQQID} closure replenishes the cache if it does not contain at
#'  least the requested number of QQIDs, then it unshifts the QQIDs from the
#'  cache, and returns them. The user experience is that \code{qQQID} is
#'  responsive, and latency arises only occasionally when the cache is
#'  replenished.
#'
#'@section Warning - parallelization: If you are executing code in parallel on
#'  separate processors, you must make sure that every task uses its own,
#'  independent copy of \code{qQQID()} and not a copy of an instance of the
#'  closure - such copies would all contain the same cache! Given the relatively
#'  high latency of cache replenishment, it is likely that an approach that uses
#'  \code{rngQQID(N, method = "q")}, is more promising.
#'
#'@section Disclaimer and caution: Although this function has been written and
#'  tested with care, no suitability for any particular purpose, in particular
#'  no suitability for high-value transactions, for applications whose failure
#'  could endanger life or property, or for cryptography is claimed. The source
#'  code is published in full and it is up to the user to audit and adapt the
#'  code for their own purposes and needs.
#'
#'@param nBatch (numeric) The batch size requested from the ANU server. The
#'  default 1023 does not normally need to be changed. (Larger batches take more
#'  time to process, smaller batches offer no speed benefit). It might be
#'  increased e.g. for storing a large cache in case an interruption to Internet
#'  connectivity is anticipated. Values < 1 and > 1e05 will cause an error in
#'  \code{qrandom::qUUID()}.
#'
#'@return \code{qQQIDfactory} returns a closure that takes the following
#'  arguments: \itemize{ \item \code{n} (numeric) (default: 1; in interval: (1,
#'  1e+05)): the number of true random QQIDs to return. \item \code{inspectOnly}
#'  (logical) (default: \code{FALSE}). If \code{TRUE}, the requested number of
#'  QQIDs are only printed as a side-effect, the function returns \code{NULL}
#'  invisibly. This is useful to inspect the first \code{n} elements of the
#'  cache without changing the cache, while making it sufficiently hard to
#'  accidentally assign and reuse QQIDs. } If no connection to ANU can be
#'  established and the initial cache cannot be filled, \code{qQQIDfactory}
#'  returns \code{NULL} invisibly.
#'
#'@seealso \code{\link[=rngQQID]{rngQQID()}} to generate QQIDs via the inbuilt
#'  RNG.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' \dontrun{
#' # prepare a qQQID function and use it to retrieve three true random  QQIDs
#' qQQID <- qQQIDfactory()
#' qQQID(3)
#'
#' # Use the function to return 10 UUIDs from the same cache
#' qq2uu(qQQID(10))
#'
#' # inspect the first 5 QQIDs on the cache ...
#' qQQID(5, inspectOnly = TRUE)
#'
#' # ... retrieve four of the QQIDs (they are identical
#' # to the first four we just inspected) ...
#' qQQID(4)
#'
#' # ... show that the four keys are gone from the cache which now
#' # begins with the fifth QQID we saw before.
#' qQQID(5, inspectOnly = TRUE)
#'
#' }
#'
#'@export

qQQIDfactory <- function(nBatch = 1023) {
  # Fetch QQIDs from cached store. This closure creates a function environment
  # that keeps a cache of true random QQIDs from which it unshifts QQIDs when
  # required. A call to the ANU server will only be triggered when the cache is
  # depleted. nBatch: 1,023 is the largest batch that qrandom::qrandom will
  # fetch in one call. Larger batches take more time to process since they
  # require more than one fetch operation, smaller batches are not received
  # significantly faster.

  stopifnot(is.numeric(nBatch))

  myM <- paste("qQQIDfactory can't fill cache from ANU server.",
               "Possibly no Internet connection. No closure produced.",sep="\n")
  uu <- tryCatch(qrandom::qUUID(nBatch),
                 error = function(e) {
                   message(paste("Error:", myM))
                   NULL},
                 warning = function(w) {
                   message(paste("Warning:", myM))
                   NULL})

  if (is.null(uu)) {
    return(invisible(NULL))
  } else {
    QQ <- xlt2qq(uu)         # Place QQ into the enclosing environment of
                             # the returned closure. Note: implicitly
                             # forcing evaluation here.
  }

  return(function(n = 1, inspectOnly = FALSE) {  # Here we define the closure
    stopifnot(is.numeric(n))
    stopifnot( n > 0)
    stopifnot( n <= 1e5)

    if (inspectOnly) {
      print(QQ[1:min(n, length(QQ))])
      return(invisible(NULL))
    }

    myM <- paste0("Closure can't replenish cache from ANU server.\n",
                 "Possibly no Internet connection.\n")

    # replenish, if there are not enough QQIDs in the cache
    while (length(QQ) < n) { # as long as there are not enough values in QQ
      message("trying...")
      uu <- tryCatch(qrandom::qUUID(nBatch),
                     error = function(e) {
                       message("Error: ", myM,
                               sprintf("%d QQID remaining in cache.",
                                       length(QQ)))
                       NULL},
                     warning = function(w) {
                       message("Warning: ", myM,
                               sprintf("%d QQID remaining in cache.",
                                       length(QQ)))
                       NULL})
      if (is.null(uu)) {
        return(invisible(NULL))
      } else {
        QQ <<- c(QQ, xlt2qq(uu))
      }
    }
    # Regular exit of while-loop: cache was replenished.
    # Unshift and return required number of QQIDs

    x <- QQ[1:n]
    QQ <<- QQ[-(1:n)]
    return(x)
  }) # end return(<closure>)

}


# [END]
