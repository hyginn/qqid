# UUIDexample.R

#' UUIDexample
#'
#' \code{UUIDexample} returns synthetic, valid UUIDs for testing and
#' development, which are easy to distinguish from "real" UUIDs to prevent their
#' accidental use as IDs.
#'
#' The function stores five artifical sample UUIDs. Input is an index vector
#' that specifies which UUIDs to return. More than five UUIDs can be requested
#' by repeating indices. The UUIDs can be converted to the QQIDs provided by
#' \code{QQIDexample}. Note: these are not random numbers in the sense of the
#' philosophy behind UUIDs. Do not use them for any purpose other than
#' demonstration and testing.
#'
#' @param idx (numeric) an index vector that defines which of the five
#'   internally stored example UUIDs to return
#' @return (character) a vector of UUIDs
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{QQIDexample}} Returns five QQIDs
#'
#' @examples
#' UUIDexample()                             # the five stored UUIDs
#' UUIDexample(2:3)                          # two UUIDs
#' UUIDexample(rep(1:5, 5))                  # twentyfive non-random UUIDS
#' UUIDexample(3) == qq2uu(QQIDexample(3))   # TRUE (testing the conversion)
#'
#' @export

UUIDexample <- function(idx = 1:5) {
  myUU <- c("11111111-1111-1111-1111-111111111111",
            "22222222-2222-2222-2222-222222222222",
            "33333333-3333-3333-3333-333333333333",
            "44444444-4444-4444-4444-444444444444",
            "55555555-5555-5555-5555-555555555555")

  return(myUU[idx])
}

# [END]
