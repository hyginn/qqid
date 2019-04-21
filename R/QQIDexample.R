# QQIDexample.R

#' QQIDexample
#'
#' \code{QQIDexample} returns synthetic, valid QQIDs for testing and
#' development. The synthetic examples are easy to distinguish from "real" IDs
#' to prevent their accidental use in an application.
#'
#' The function stores five artificial QQIDs. Input is an index vector that
#' specifies which QQIDs to return. More than five IDs can be requested by
#' applying the usual subsetting rules. The QQIDs represent the exact same
#' numbers provided by \code{\link[=xltIDexample]{xltIDexample()}}. However the \code{qqid}
#' package provides only format conversion to UUID at this time, so the reverse
#' comparison will only succeed with \code{xltIDexample("UUID")}.
#'
#' @param sel (numeric, or logical) a subsetting vector
#' @return (character) a vector of QQIDs
#'
#' @seealso \code{\link[=xltIDexample]{xltIDexample()}} Returns five 128-bit "hexlets", formatted
#'   as Md5, hex-number, UUID, and IPv6.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' QQIDexample()                                  # the five stored QQIDs
#' QQIDexample(2:3)                               # two QQIDS
#' QQIDexample(c(TRUE, FALSE))                    # vector recycling
#' QQIDexample(sample(1:5, 17, replace = TRUE))   # seventeen in random order
#' QQIDexample() == xlt2qq(xltIDexample())        # TRUE TRUE TRUE TRUE TRUE
#'
#' @export

QQIDexample <- function(sel = 1:5) {
  myQQ <- c("bowl.foil.ERERERERERERERERER",
            "cost.mice.IiIiIiIiIiIiIiIiIi",
            "dues.soon.MzMzMzMzMzMzMzMzMz",
            "foil.bowl.RERERERERERERERERE",
            "gulf.gulf.VVqqqqqmZmZma7u7u7")

  return(myQQ[sel])
}

# [END]
