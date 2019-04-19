# isValidUUID.R

#' isValidUUID
#'
#' \code{isValidUUID} tests whether the function argument is a vector of valid
#' UUIDs.
#'
#' \code{isValidUUID} accepts a vector of strings and returns a logical vector of the
#' same length, \code{TRUE} for every element of the input that is a valid UUID
#' according to \href{https://tools.ietf.org/html/rfc4122}{RFC 4122}. \code{NA}
#' values are mapped to \code{FALSE} (default) or can be replaced with
#' \code{NA} to preserve them. Note: arguments passed to \code{na.map} are
#' implicitly converted to type logical. A valid UUID has the form:
#' \code{"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"} where \code{"x"} is a
#' hexadecimal letter.
#'
#' @param s (character) a vector of strings to check.
#' @param na.map (logical) replace NA with \code{FALSE} (default), \code{NA}, or
#'   \code{TRUE}
#' @return (logical) a vector of the same length as the input, \code{TRUE} for
#'   every element of the input that is a valid UUID.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{isValidQQID}} to check QQIDs.
#'
#' @examples
#' # check two valid UUIDs
#' isValidUUID(UUIDexample(3:4))   # TRUE  TRUE
#'
#' # check one invalid UUID
#' isValidUUID("2.7182818284590452353602874713526624")   # FALSE
#'
#' # convert a QQID and check it
#' isValidUUID(qq2uu("bird.carp.7TsBWtwqtKAeCTNk8f"))   # TRUE
#'
#' # check a valid UUID, not a UUID, and an NA. Map NA to NA, not to FALSE.
#' isValidUUID(c(UUIDexample(4),
#'               "7ac3844896e86b62da717e0f4500f99e",
#'               NA), na.map = NA)                      # TRUE  FALSE  NA

#'
#' @export

isValidUUID <- function(s, na.map = FALSE) {
  stopifnot(is.character(s))
  stopifnot(is.vector(s))
  patt <- paste0("^[0-9a-fA-F]{8}",
                 "-([0-9a-fA-F]{4}-){3}",
                 "[0-9a-fA-F]{12}$")
  v <- grepl(patt, s)
  v[is.na(s)] <- na.map      # replace original NAs with na.map
  return(v)
}

# [END]
