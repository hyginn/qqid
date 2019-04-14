# QQIDexample.R

#' QQIDexample
#'
#' \code{QQIDexample} returns example QQIDs.
#'
#' Details.
#' The function stores five artifical sample QQIDs. Input is an index vector
#' that specifies which QQIDs to return. More than five QQIDs can be requested
#' by repeating indices. The QQIDs can be converted to the UUIDs provided by
#' \code{UUIDexample}. Note: these are not random numbers in the sense of the
#' philosophy behind QQIDs. Do not use them for any purpose other than
#' demonstration and testing.
#'
#' @param idx (numeric) an index vector that defines which of the five
#'                      internally stored example QQIDs to return
#' @return (character) a vector of QQIDs
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{UUIDexample}} Returns five UUIDs
#'
#' @examples
#' QQIDexample()                             # the five stored QQIDs
#' QQIDexample(2:3)                          # two QQIDs
#' QQIDexample(rep(1:5, 5))                  # twentyfive non-random QQIDS
#' QQIDexample(3) == uu2qq(UUIDexample(3))   # TRUE (testing the conversion)
#'
#' @export

QQIDexample <- function(idx = 1:5) {
  myQQ <- c("aims.fold-233-4455-6677-8899-aabbccddeeff",
            "bowl.mild-344-5566-7788-99aa-bbccddeeff00",
            "cost.soot-455-6677-8899-aabb-ccddeeff0011",
            "duke.bows-566-7788-99aa-bbcc-ddeeff001122",
            "foil.gull-677-8899-aabb-ccdd-eeff00112233")

  return(myQQ[idx])
}

# [END]
