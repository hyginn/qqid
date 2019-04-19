# b64Map.R

#' b64Map
#'
#' \code{b64Map} maps 6-character bit patterns to their corresponding Base64
#' characters or characters back to bit patterns.
#'
#' @section Description: If the input is a vector of 6-character bit patterns,
#'   \code{b64Map} returns the corresponding character from the Base64
#'   binary-to-text encoding. If the input is a vector of 1-character strings
#'   \code{b64Map} returns the corresponding bit pattern. If the input is
#'   numeric, it is interpreted as indices into the b64 vector. The returned
#'   vector has the same length as the input but no checking for valid input is
#'   done.
#'
#' @section Base64: Base64 is a binary to text encoding specified in
#'   \href{https://tools.ietf.org/html/rfc4648}{RFC 1738}; we use the URL and
#'   filename-safe alphabet version with the following encoding from
#'   \code{000000} to \code{111111}:
#'   \code{"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"}
#'   This is safe for most applications; one exception is Microsoft Excel where
#'   strings beginning with a \code{"-"} are silently convert to formulas.
#'   (QQIDs are not affected by this problem since they always begin with
#'   a lowercase alphabetic character.)
#'
#' @param x (character or numeric) A vector of encoding characters, bit-patterns
#'   or indices. Note: indices are vector indices, not interpreted bit-patterns,
#'   i.e \code{b64Map("000000") == b64Map(1)}
#' @return (character) A vector of Base 64 characters or their corresponding
#'   bit-patterns.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @examples
#' # b64Map three bit patterns
#' b64Map(c("101101", "011011", "010110"))   # "t"    "b"    "W"
#'
#' # b64Map three encoding characters
#' b64Map(c("a", "b", "c"))  # "011010" "011011" "011100"
#'
#' # print the entire r64 vector as one string
#' paste0(b64Map(1:64), collapse = "")
#'
#' @export

b64Map <- function(x) {
  b64 <- character()
  b64["000000"] <- "A"
  b64["000001"] <- "B"
  b64["000010"] <- "C"
  b64["000011"] <- "D"
  b64["000100"] <- "E"
  b64["000101"] <- "F"
  b64["000110"] <- "G"
  b64["000111"] <- "H"
  b64["001000"] <- "I"
  b64["001001"] <- "J"
  b64["001010"] <- "K"
  b64["001011"] <- "L"
  b64["001100"] <- "M"
  b64["001101"] <- "N"
  b64["001110"] <- "O"
  b64["001111"] <- "P"
  b64["010000"] <- "Q"
  b64["010001"] <- "R"
  b64["010010"] <- "S"
  b64["010011"] <- "T"
  b64["010100"] <- "U"
  b64["010101"] <- "V"
  b64["010110"] <- "W"
  b64["010111"] <- "X"
  b64["011000"] <- "Y"
  b64["011001"] <- "Z"
  b64["011010"] <- "a"
  b64["011011"] <- "b"
  b64["011100"] <- "c"
  b64["011101"] <- "d"
  b64["011110"] <- "e"
  b64["011111"] <- "f"
  b64["100000"] <- "g"
  b64["100001"] <- "h"
  b64["100010"] <- "i"
  b64["100011"] <- "j"
  b64["100100"] <- "k"
  b64["100101"] <- "l"
  b64["100110"] <- "m"
  b64["100111"] <- "n"
  b64["101000"] <- "o"
  b64["101001"] <- "p"
  b64["101010"] <- "q"
  b64["101011"] <- "r"
  b64["101100"] <- "s"
  b64["101101"] <- "t"
  b64["101110"] <- "u"
  b64["101111"] <- "v"
  b64["110000"] <- "w"
  b64["110001"] <- "x"
  b64["110010"] <- "y"
  b64["110011"] <- "z"
  b64["110100"] <- "0"
  b64["110101"] <- "1"
  b64["110110"] <- "2"
  b64["110111"] <- "3"
  b64["111000"] <- "4"
  b64["111001"] <- "5"
  b64["111010"] <- "6"
  b64["111011"] <- "7"
  b64["111100"] <- "8"
  b64["111101"] <- "9"
  b64["111110"] <- "-"
  b64["111111"] <- "_"

  if (is.character(x) && nchar(x[1]) == 1) {
    v <- names(b64)[match(x, b64)]
  } else if (is.character(x) && nchar(x[1]) == 6) {
    v <- b64[x]
  } else if (is.numeric(x)) {
    v <- b64[x]
  } else {
    stop("Unexpected input")
  }

  return(v)
}

# [END]
