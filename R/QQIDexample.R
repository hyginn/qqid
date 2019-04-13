# QQIDexample.R

#' QQIDexample
#'
#' \code{QQIDexample} returns five QQIDs.
#'
#' Details.
#' The same, fixed five QQIDs are returned every time. They can be mapped
#' to the five UUIDs returned by \code{UUIDexample}.
#'
#' @return (character) Five QQIDs
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{UUIDexample}} Returns five UUIDs
#'
#' @examples
#' QQIDexample()
#'
#' @export

QQIDexample <- function() {
  myQQ <- c("wars.hurt-233-4455-6677-8899-aabbccddeeff",
            "tick.bath-344-5566-7788-99aa-bbccddeeff00",
            "quay.dare-455-6677-8899-aabb-ccddeeff0011",
            "bars.rift-566-7788-99aa-bbcc-ddeeff001122",
            "mane.junk-677-8899-aabb-ccdd-eeff00112233")
  return(myQQ)
}

# [END]
