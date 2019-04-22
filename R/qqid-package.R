# qqid-package.R

#' @title QQIDs - human-compatible representation of 128-bit numbers
#'
#' @section RNG safe: Care has been taken to ensure that the \code{qqid}
#'   functions have little risk of inadvertently changing the RNG's global
#'   initialization state \code{.Random.seed}. Your random-reproducible
#'   simulation should not be affected if you generate a few QQIDs in-between.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @references See the
#'   \href{http://hyginn.github.io/qqid/}{\code{qqid} README
#'   on the Web} for more Details.  \href{https://zenodo.org/record/2648318}{\code{DOI:10.5281/zenodo.2648318}}
#'
#' @seealso \code{\link[qrandom]{qUUID}},
#'
#' @keywords  internal
#'
#' @examples
#'   # Use rngQQID() to get a few QQIDS with R's internal RNG
#'   rngQQID(7, method = "R")
#'
#'   # That's fine, but it's better to initialize the RNG with a true-random
#'   # number. You need to be connected to the Internet ...
#'   \dontrun{
#'     rngQQID(7, method = "q")
#'     # ... of course you won't really notice
#'     # the difference. Except that it takes a
#'     # few seconds to fetch the random seed from
#'     # the quantum-random number server at the
#'     # Australian National University in Canberra
#'   }
#'
#'   # The best way is to fetch a block of  true-random numbers from the ANU
#'   # in Canberra and to cache them in a closure...
#'
#'   \dontrun{
#'     qQQID <- qQQIDfactory()   # takes a few seconds to fabricate the closure
#'
#'     # then, getting QQIDs works without latency
#'     qQQID(1)
#'     qQQID(1)
#'     qQQID(2)
#'     qQQID(3)
#'     qQQID(5)
#'     qQQID(8)
#'
#'     # if you are curious, you can peek what's next in the cache...
#'     qQQID(5, inspectOnly = TRUE)
#'     # (the numbers are not returned, only
#'     #  message()'d so you can't accidentally
#'     #  assign them)
#'
#'     # ... and then retrieve some of those numbers
#'     qQQID(2)
#'
#'     # of course, these two are now no longer on the cache.
#'     qQQID(5, inspectOnly = TRUE)
#'
#'     # Now, you have just looked at a dozen of 128-bit random numbers, and had
#'     # no trouble figuring out which ones were the same, and which ones were
#'     # different. That's the point of QQIDs.
#'   }
#'

"_PACKAGE"

# [END]
