# isValidQQID.R

#' isValidQQID
#'
#' \code{isValidQQID} tests whether the function argument is a vector of valid
#' QQIDs.
#'
#' The function accepts a vector of strings and returns a logical vector of the
#' same length,  \code{TRUE} for every element of the input that is a valid
#' QQID. \code{NA} values are mapped to \code{FALSE} (default) or can be
#' replaced with \code{NA} to preserve them. Note: arguments passed to
#' \code{na.map} are implicitly converted to type logical. A valid QQID has the
#' form: \code{"qqqq.qqqq.BBBBBBBBBBBBBBBBBB"} where \code{"qqqq"} is a Q-word
#' (cf \code{\link{qMap}}) encoding 10 bit each and \code{"B"} is a Base 64
#' character encoding 6 bits each for \code{10 + 10 + (18 * 6) == 128} bits. The
#' two Q-words of the QQID are separated by a "." which does not appear in UUIDs
#' and thus the Q-words bead, beef, dead, deaf, deed, face, and fade can be
#' easily distinguished from 4 digit hexadecimal numbers.
#'
#' @param s (character) a vector of strings to check.
#' @param na.map (logical) replace NA with \code{FALSE} (default), \code{NA}, or
#'   \code{TRUE}
#' @return (logical) a vector of the same length as the input, \code{TRUE} for
#'   every element  of the input that is a valid QQID.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{isValidUUID}} to check UUIDs.
#'
#' @examples
#' # check one invalid QQID
#' isValidQQID("spur.ious.oversimplification")  # FALSE: "ious" is not a Q-word
#'
#' # check one valid QQID
#' isValidQQID("base.less.anthropocentricity")  # TRUE, though regrettably so
#'
#' # check two valid QQIDs
#' isValidQQID(QQIDexample(1:2))   # TRUE  TRUE
#'
#' @export

isValidQQID <- function(s, na.map = FALSE) {
  stopifnot(is.character(s))
  stopifnot(is.vector(s))
  patt <- paste0("^([a-z]{4}\\.){2}",  # two Q-words separated by "."
                 "[0-9a-zA-Z_-]{18}$") # 18 Base 64 encoded characters
  v <- grepl(patt, s)
  v[v] <- as.logical(qMap(substr(s[v], 1, 4))) &
          as.logical(qMap(substr(s[v], 6, 9)))
  v[is.na(v)] <- FALSE       # replace qMap() NAs with FALSE
  v[is.na(s)] <- na.map      # replace original NAs with na.map
  return(v)
}


# [END]
