# is.xlt.R

#' is.xlt
#'
#' \code{is.xlt} tests whether the function argument is a vector of 32 digit
#' hexadecimal numbers (a "hexlet").
#'
#' \code{is.xlt} accepts a vector of strings and returns a logical vector of the
#' same length, \code{TRUE} for every element of the input that matches the
#' regular expression  \code{"^[0-9a-f]{32}$"}. \code{NA} values are mapped to
#' \code{FALSE} (default) or can be replaced with \code{NA} to preserve them.
#' Note: arguments passed to \code{na.map} are implicitly converted to type
#' logical.
#'
#' @param s (character) a vector of strings to check.
#' @param na.map (logical) replace NA with \code{FALSE} (default), \code{NA}, or
#'   \code{TRUE}
#' @return (logical) a vector of the same length as the input, \code{TRUE} for
#'   every element of the input that is a valid UUID, \code{FALSE} for every
#'   element that is not, and \code{NA} or \code{FALSE} for every \code{NA}
#'   input.
#'
#' @seealso \code{\link[=is.QQID]{is.QQID()}} to check QQIDs.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' # check the example hexlet formats
#' is.xlt(xltIDexample())              # TRUE  TRUE  TRUE  TRUE  TRUE
#'
#' # check one invalid format
#' is.xlt("2.718281828459045235360287471353")     # FALSE
#'
#' # check a valid hexlet, an invalid hexlet, and an NA.
#' # Map input NA to NA, not to FALSE.
#' is.xlt(c("0c46:0ed3:b015:adc2:ab4a:01e0:9336:4f1f", # IPv6
#'          "c46:ed3:b015:adc2:ab4a:1e0:9336:4f1f",    # IPv6 abbreviated format
#'          NA), na.map = NA)                          # TRUE  FALSE  NA
#'
#' @export

is.xlt <- function(s, na.map = FALSE) {
  stopifnot(is.character(s))
  stopifnot(is.vector(s))

  v <- grepl("^[0-9a-f]{32}$", unformatXlt(s))

  v[is.na(s)] <- na.map      # replace original NAs with na.map
  return(v)
}

# [END]
