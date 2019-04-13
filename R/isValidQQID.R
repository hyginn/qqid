# isValidQQID.R

#' isValidQQID
#'
#' \code{isValidQQID} Test whether the function argument is a vector of valid
#'                    QQIDs.
#'
#' The function accepts a vector of strings and returns a logical
#' vector of the same length,  \code{TRUE} for every element of the input that
#' is a valid QQID. \code{NA} values are mapped to \code{FALSE} (default) or can
#' be replaced with \code{NA} to preserve them. Note: arguments passed to
#' \code{na.map} are implicitly converted to type logical.
#'
#' @param s (character) a vector of strings to check.
#' @param na.map (logical) replace NA with \code{FALSE} (default), \code{NA},
#'                         or  \code{TRUE}
#' @return (logical) a vector of the same length as the input, \code{TRUE}
#'                   for every element  of the input that is a valid QQID.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{isValidUUID}} to check UUIDs.
#'
#' @examples
#' # check 2 valid QQIDs
#' isValidQQID(QQIDexample()[1:2])   # TRUE  TRUE
#' # check one invalid QQID
#' isValidQQID("no.pasaran-df7-652d-1982-0a5c-2c1a88284ee8")
#'
#' @export

isValidQQID <- function(s, na.map = FALSE) {
  stopifnot(is.character(s))
  stopifnot(is.vector(s))
  patt <- paste0("^[a-z]{4}\\.[a-z]{4}", # two Q words separetd by "."
                 "-[0-9a-fA-F]{3}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$")
  v <- grepl(patt, s)
    v[v] <- as.logical(qqMap(substr(s[v], 1, 4))) &
            as.logical(qqMap(substr(s[v], 6, 9)))
    v[is.na(v)] <- FALSE       # replace qqMap() NAs with FALSE
    v[is.na(s)] <- na.map      # replace original NAs with na.map
    return(v)
}

# [END]
