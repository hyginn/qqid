# xltIDexample.R

#' xltIDexample
#'
#' \code{xltIDexample} returns synthetic, valid 128-bit numbers in hexadecimal
#' notation (hexlets) in different common formats. The synthetic examples are
#' easy to distinguish from "real" IDs to prevent their accidental use in an
#' application.
#'
#' The function stores five artificial sample IDs. Input is a subsetting vector
#' that specifies which IDs to return. More than five IDs can be requested by
#' applying the usual subsetting rules. The IDs can be converted to the exact
#' same QQIDs provided by \code{\link[=QQIDexample]{QQIDexample()}}. The formats available are
#' \code{"md5"}: 32 hex numerals; \code{"hex"}: 32 hex numerals with \code{"0x"}
#' prefix; \code{"UUID"}: Universally Unique Identifier format; \code{"IPv6"}:
#' IPv6 formatted address; \code{"hEx"}: 32 hex numerals with mixed case.
#'
#' @param sel (numeric, logical, or character) a subsetting vector
#' @return (character) a named vector of formatted hexlets.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link[=QQIDexample]{QQIDexample()}} Returns five QQIDs
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' xltIDexample()                                  # the five stored hexlets
#' xltIDexample(2:3)                               # a hex number and a UUID
#' xltIDexample(c(TRUE, FALSE))                    # vector recycling
#' xltIDexample(sample(1:5, 17, replace = TRUE))   # seventeen in random order
#' xltIDexample("UUID") == qq2uu(QQIDexample(3))   # TRUE (correct conversion)
#'
#' @export

xltIDexample <- function(sel = 1:5) {
  xltIDs <- c("11111111111111111111111111111111",
              "0x22222222222222222222222222222222",
              "33333333-3333-3333-3333-333333333333",
              "4444:4444:4444:4444:4444:4444:4444:4444",
              "0x55555555aaaaaaaa66666666BBBBBBBB")
  names(xltIDs) <- c("md5", "hex", "UUID", "IPv6", "hEx")

  return(xltIDs[sel])
}

# [END]
