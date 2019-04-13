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
  myQQ <- c(
    "gram.love-88e-4a13-a1d2-79ee-ec0567354223",
    "skip.torn-b08-9f14-9032-0baa-5f796fa2a71b",
    "wave.loaf-df7-652d-1982-0a5c-2c1a88284ee8",
    "time.pike-f9e-d798-3d22-6894-643b13ed8740",
    "flee.teak-6e3-4461-3002-99be-eb263a3a14d2"
  )
  return(myQQ)
}

# [END]
