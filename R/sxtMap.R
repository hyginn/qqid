# sxtMap.R

#' sxtMap
#'
#' \code{sxtMap} maps 6-character bit patterns to their corresponding Base64
#' characters (an "sextet"), or characters back to bit patterns.
#'
#' @section Description: If the input is a vector of 6-character bit patterns,
#'   \code{sxtMap} returns the corresponding character from the Base64
#'   binary-to-text encoding. If the input is a vector of 1-character strings
#'   \code{sxtMap} returns the corresponding bit pattern. If the input is
#'   numeric, it is interpreted as indices into the sxt vector. The returned
#'   vector has the same length as the input but no checking for valid input is
#'   done.
#'
#' @section Base64: Base64 is a binary to text encoding specified in
#'   \href{https://tools.ietf.org/html/rfc4648}{RFC 1738}; we use the URL and
#'   filename-safe alphabet version with the following encoding from
#'   \code{000000} to \code{111111}:
#'   \code{"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"}
#'   This is safe for most applications; one exception is Microsoft Excel where
#'   strings that begin with a \code{"-"} are silently convert to formulas.
#'   (QQIDs are not affected by this problem since they always begin with
#'   a lowercase alphabetic character.)
#'
#' @param x (character or numeric) A vector of encoding characters, bit-patterns
#'   or indices. Note: indices are vector indices, not interpreted bit-patterns,
#'   i.e \code{sxtMap("000000") == sxtMap(1)}
#' @return (character) A vector of Base 64 characters or their corresponding
#'   bit-patterns.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' # sxtMap three bit patterns
#' sxtMap(c("101101", "011011", "010110"))   # "t"    "b"    "W"
#'
#' # sxtMap three encoding characters
#' sxtMap(c("a", "b", "c"))  # "011010" "011011" "011100"
#'
#' # print the entire r64 vector as one string
#' paste0(sxtMap(1:64), collapse = "")
#'
#' @export

sxtMap <- function(x) {
  sxt <- character()
  sxt["000000"] <- "A"
  sxt["000001"] <- "B"
  sxt["000010"] <- "C"
  sxt["000011"] <- "D"
  sxt["000100"] <- "E"
  sxt["000101"] <- "F"
  sxt["000110"] <- "G"
  sxt["000111"] <- "H"
  sxt["001000"] <- "I"
  sxt["001001"] <- "J"
  sxt["001010"] <- "K"
  sxt["001011"] <- "L"
  sxt["001100"] <- "M"
  sxt["001101"] <- "N"
  sxt["001110"] <- "O"
  sxt["001111"] <- "P"
  sxt["010000"] <- "Q"
  sxt["010001"] <- "R"
  sxt["010010"] <- "S"
  sxt["010011"] <- "T"
  sxt["010100"] <- "U"
  sxt["010101"] <- "V"
  sxt["010110"] <- "W"
  sxt["010111"] <- "X"
  sxt["011000"] <- "Y"
  sxt["011001"] <- "Z"
  sxt["011010"] <- "a"
  sxt["011011"] <- "b"
  sxt["011100"] <- "c"
  sxt["011101"] <- "d"
  sxt["011110"] <- "e"
  sxt["011111"] <- "f"
  sxt["100000"] <- "g"
  sxt["100001"] <- "h"
  sxt["100010"] <- "i"
  sxt["100011"] <- "j"
  sxt["100100"] <- "k"
  sxt["100101"] <- "l"
  sxt["100110"] <- "m"
  sxt["100111"] <- "n"
  sxt["101000"] <- "o"
  sxt["101001"] <- "p"
  sxt["101010"] <- "q"
  sxt["101011"] <- "r"
  sxt["101100"] <- "s"
  sxt["101101"] <- "t"
  sxt["101110"] <- "u"
  sxt["101111"] <- "v"
  sxt["110000"] <- "w"
  sxt["110001"] <- "x"
  sxt["110010"] <- "y"
  sxt["110011"] <- "z"
  sxt["110100"] <- "0"
  sxt["110101"] <- "1"
  sxt["110110"] <- "2"
  sxt["110111"] <- "3"
  sxt["111000"] <- "4"
  sxt["111001"] <- "5"
  sxt["111010"] <- "6"
  sxt["111011"] <- "7"
  sxt["111100"] <- "8"
  sxt["111101"] <- "9"
  sxt["111110"] <- "-"
  sxt["111111"] <- "_"

  if (is.character(x) && nchar(x[1]) == 1) {
    v <- names(sxt)[match(x, sxt)]
  } else if (is.character(x) && nchar(x[1]) == 6) {
    v <- sxt[x]
  } else if (is.numeric(x)) {
    v <- sxt[x]
  } else {
    stop("Unexpected input")
  }

  return(v)
}

# [END]
