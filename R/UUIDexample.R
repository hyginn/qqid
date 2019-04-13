# UUIDexample.R

#' UUIDexample
#'
#' \code{UUIDexample} returns five UUIDs.
#'
#' Details.
#' The same, fixed five UUIDs are returned every time. They can be mapped
#' to the five QQIDs returned by \code{QQIDexample}.
#'
#' @return (character) Five UUIDs
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{QQIDexample}} Returns five QQIDs
#'
#' @examples
#' UUIDexample()
#'
#' @export

UUIDexample <- function() {
  myUU <- c("00112233-4455-6677-8899-aabbccddeeff",
            "11223344-5566-7788-99aa-bbccddeeff00",
            "22334455-6677-8899-aabb-ccddeeff0011",
            "33445566-7788-99aa-bbcc-ddeeff001122",
            "44556677-8899-aabb-ccdd-eeff00112233")
  return(myUU)
}

# [END]
