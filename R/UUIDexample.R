# UUIDexample.R

#' UUIDexample
#'
#' \code{UUIDexample} returns example UUIDs.
#'
#' Details.
#' The function stores five artifical sample UUIDs. Input is an index vector
#' that specifies which UUIDs to return. More than five UUIDs can be requested
#' by repeating indices. The UUIDs can be converted to the QQIDs provided by
#' \code{QQIDexample}. Note: these are not random numbers in the sense of the
#' philosophy behind UUIDs. Do not use them for any purpose other than
#' demonstration and testing.
#'
#' @param idx (numeric) an index vector that defines which of the five
#'                      internally stored example UUIDs to return
#' @return (character) a vector of UUIDs
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{QQIDexample}} Returns five QQIDs
#'
#' @examples
#' UUIDexample()              # the five stored UUIDs
#' UUIDexample(2:3)           # two UUIDs
#' UUIDexample(rep(1:5, 5))   # twentyfive non-random UUIDS
#' UUIDexample(3) == qq2uu(QQIDexample(3)) # TRUE (testing the conversion)
#'
#' @export

UUIDexample <- function(idx = 1:5) {
  myUU <- c("00112233-4455-6677-8899-aabbccddeeff",
            "11223344-5566-7788-99aa-bbccddeeff00",
            "22334455-6677-8899-aabb-ccddeeff0011",
            "33445566-7788-99aa-bbcc-ddeeff001122",
            "44556677-8899-aabb-ccdd-eeff00112233")
  return(myUU[idx])
}

# [END]
