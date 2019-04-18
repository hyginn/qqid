# qQQIDfactory.R

#' qQQIDfactory.
#'
#' \code{qQQIDfactory} returns a closure (a function with an associated
#' environment) that retrieves, caches, and returns true random QQIDs.
#'
#' In what follows we will call the closure that is produced by
#' \code{qQQIDfactory} itself \code{qQQID()} (even though you could assign it to
#' a different name). The function factory \code{qQQIDfactory} and the
#' \code{qQQID()} closure address a latency problem that arises when we retrieve
#' true random numbers from the \href{https://qrng.anu.edu.au/index.php}{ANU
#' Quantum Random Number Generator} at the Australian National University.
#' \code{qQQIDfactory} produced closures maintain a local cache of true random
#' QQIDs, which can be accessed without latency. In a design use case
#' \code{qQQID()} could be produced in an R session startup script. From that
#' point on, latency in generating true random QQIDs is only experienced
#' occasionally when the cache needs to be replenished.
#'
#' @section Usage: \code{qQQIDfactory}produces a closure which you assign to a
#'   variable and call by that variable name (see examples). While any legal
#'   variable name can be used, assigning to \code{qQQID} is recommended.
#'   Producing the closure requires an internet connection to first fill the
#'   closure's cache of QQID values. Once the cache is filled, no internet
#'   connection is required until the cache is depleted and the closure attempts
#'   to replenish it. If replenishing the cache fails because of a failure to
#'   open a connection to the ANU server, an informative message is printed and
#'   the closure returns \code{NULL} invisibly. If there are remaining QQIDs in
#'   the cache these can be retrieved by requesting no more than the number that
#'   currently exist in the cache. The closure has been written to either return
#'   NULL, or to return the requested number of QQIDs, but it will never return
#'   fewer than the requested number, since implicit recycling of shorter
#'   vectors would be a critical failure mode for a function that is expected to
#'   create unique identifiers.
#'
#' @section Properties of the produced QQIDs: Internally, \code{qQQID} converts
#'   true random UUIDs obtained from \code{qrandom::qUUID}. These UUIDs are
#'   \href{https://tools.ietf.org/html/rfc4122}{RFC 4122} compliant and contain
#'   a six-bit version code, and 122 random bits. Such RFC compliant QQIDs are
#'   drawn from 2^122 = 5.3e+36 possibilities, whereas totally random 128-bit
#'   numbers are drawn from a 3.4e+38 number space. The 50%% collision
#'   probability of random 122-bit numbers is ~ 2.7e18 numbers, while for
#'   128-bit numbers it is ~ 2.2e19.
#'
#' @section qQQIds vs. rngQQIDs: Using true random (qQQIDs) or pseudo-random
#'   (rngQQIDs) is a tradeoff between speed and randomness. While the inbuilt
#'   RNGs of R are very good at producing random numbers, they need to be
#'   initialized starting from a single 64-bit number - which is a very much
#'   smaller space than 128-bit - and in practice, initialization via
#'   \code{set.seed(NULL)} is based on system time and process ID, which results
#'   in a very much smaller number space still. This may be acceptable in some
#'   use cases, but for the decentralized generation of unique keys the
#'   potential for initialization collision may become a problem. Moreover the
#'   RNG state is a global variable in R, therefore the possibility of an
#'   initialization collision with catastrophic consequences (all subsequent
#'   keys are duplicates) arises from improper use of \code{set.seed()} in
#'   another function, script or package that is not under explicit control of
#'   the user. The best way to prevent this with certainty is to use the true
#'   random keys that \code{qQQID} provides.  Thus unless very large numbers of
#'   keys are required, it is advisable to use true randum QQIDs provided by
#'   \code{qQQID}.
#'
#' @section caching QQIDs to avoid latency: The ANU server produces true random
#'   numbers from quantum fluctuations of the vacuum. The high latency of
#'   requests for quantum random numbers from the ANU server - between 6 to 10
#'   seconds per request - is practically independent of the size of the
#'   request's payload. This suggests a strategy to serve keys from a local
#'   cache. R provides an elegant way of doing this by defining functions as
#'   closures - i.e. along with their own environment. This function environment
#'   allows to maintain state between function calls. \code{qQQIDfactory}
#'   retrieves 1023 qQQIDs and caches them in the environment of \code{qQQID}.
#'   The \code{qQQID} closure replenishes the cache if it does not contain at
#'   least the requested number of QQIDs, then it unshifts the QQIDs from the
#'   cache, and returns them. The user experience is that \code{qQQID} is
#'   responsive, and latency arises only occasionaly when the cache is
#'   restocked.
#'
#' @section Warning - paralellization: If you are executing code in paralell on
#'   separate processors, you must make sure that every task uses its own,
#'   independent copy of \code{qQQID()} and not a copy of an instance of the
#'   closure - such copies would all contain the same cache! Given the
#'   relatively high latency of cache replenishment, it is likely that an
#'   approach that uses \code{rngQQID(N, method = "q")}, is more promising.
#'
#' @section Disclaimer: Although this function has been written and tested with
#'   care, no suitability for any particular purpose, in particular not for
#'   high-value transactions, for applications whose failure could endager life
#'   or property, or for cryptography is claimed. The source code is published
#'   in full and it is up to the user to audit the code for such and similar
#'   purposes.
#'
#' @param nBatch (numeric) The batch size requested from the ANU server. The
#'   default 1023 does not normally need to be changed. (Larger batches take
#'   more time to process, smaller batches offer no speed beenefit). It might be
#'   increased e.g. for storing a large cache in case an interruption to
#'   Internet connectivity is anticipated.
#'
#' @return \code{qQQIDfactory} returns a closure that takes an argument \code{n}
#'   (default: 1): the number of true random QQIDs to return. A second argument
#'   of the closure is \code{inspectOnly} (default: \code{FALSE}). If this is
#'   \code{TRUE}, the requested number of QQIDs are only printed as a
#'   side-effect, the function returns \code{NULL} invisibly. This is useful to
#'   inspect the first \code{n} elements of the cache without changing the
#'   cache, while making it sufficiently hard to accidentally assign and reuse
#'   QQIDs. If the connection to ANU can't be established and the initial cache
#'   cannot be filled, \code{qQQIDfactory} returns \code{NULL} invisibly.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{rngQQID}} to generate QQIDs via the inbuilt RNG.
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
#' @export

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
    QQ <- uu2qq(uu)          # place QQ into the enclosing environment of
                             # the returned closure
  }

  return(function(n = 1, inspectOnly = FALSE) {  # Here we define the closure

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
        QQ <<- c(QQ, uu2qq(uu))
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
