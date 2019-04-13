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
  myUU <- c(
    "6c10088e-4a13-a1d2-79ee-ec0567354223",
    "e2062b08-9f14-9032-0baa-5f796fa2a71b",
    "51513df7-652d-1982-0a5c-2c1a88284ee8",
    "28c24f9e-d798-3d22-6894-643b13ed8740",
    "965ec6e3-4461-3002-99be-eb263a3a14d2"
  )
  return(myUU)
}

# [END]
