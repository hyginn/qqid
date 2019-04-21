# is.QQID.R

#' is.QQID
#'
#' \code{is.QQID} tests whether the function argument is a vector of valid
#' QQIDs.
#'
#' \code{is.QQID} accepts a vector of strings and returns a logical vector of
#' the same length,  \code{TRUE} for every element of the input that is a valid
#' QQID. \code{NA} values are mapped to \code{FALSE} (default) or can be
#' replaced with \code{NA} to preserve them. Note: arguments passed to
#' \code{na.map} are implicitly converted to type logical. A valid QQID has the
#' form: \code{"qqqq.qqqq.BBBBBBBBBBBBBBBBBB"} where each \code{"qqqq"} is a
#' Q-word (cf. \code{\link[=qMap]{qMap()}}) encoding 10 bit, and \code{"B"} is a
#' Base64 character encoding 6 bits each for \code{10 + 10 + (18 * 6) == 128}
#' bits. The two Q-words of the QQID are separated by a "." which does not
#' appear in UUIDs nor in the Base64 alphabet and thus the Q-words bead, beef,
#' dead, deaf, deed, face, and fade can be easily distinguished from 4 digit
#' hexadecimal numbers in a QQID or a Base64 encoded number.
#'
#' @param s (character) a vector of strings to check.
#' @param na.map (logical) replace NA with \code{FALSE} (default), \code{NA}, or
#'   \code{TRUE}
#' @return (logical) a vector of the same length as the input, \code{TRUE} for
#'   every element  of the input that is a valid QQID.
#'
#' @seealso \code{\link[=is.xlt]{is.xlt()}} to check UUIDs, MD5s, IPv6 addresses
#'   and other hexlets.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' # check one invalid QQID
#' is.QQID("spur.ious.oversimplification")  # FALSE: "ious" is not a Q-word
#'
#' # check one valid QQID
#' is.QQID("base.less.Anthr0p0centricity")  # TRUE, perhaps regrettably so
#'
#' # check two valid QQIDs
#' is.QQID(QQIDexample(1:2))   # TRUE  TRUE
#'
#' # convert a UUID and check it
#' is.QQID(xlt2qq("0c460ed3-b015-adc2-ab4a-01e093364f1f"))   # TRUE
#'
#' # check a valid QQID, not a QQID, and an NA. Map NA to NA, not to FALSE.
#' is.QQID(c(QQIDexample(3), "meh", NA), na.map = NA)   # TRUE  FALSE  NA
#'
#' @export

is.QQID <- function(s, na.map = FALSE) {
  stopifnot(is.character(s))
  stopifnot(is.vector(s))
  patt <- paste0("^([a-z]{4}\\.){2}",  # two Q-words separated by "."
                 "[0-9a-zA-Z_-]{18}$") # 18 Base 64 encoded characters
  v <- grepl(patt, s)
  v[v] <- ! is.na(qMap(substr(s[v], 1, 4))) &
          ! is.na(qMap(substr(s[v], 6, 9)))
  v[is.na(v)] <- FALSE       # replace qMap() NAs with FALSE
  v[is.na(s)] <- na.map      # replace original NAs with na.map
  return(v)
}


# [END]
