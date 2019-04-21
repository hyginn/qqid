# oltMap.R

#' oltMap
#'
#' \code{oltMap} maps 6-character bit patterns to their corresponding Base64
#' characters (an "octlet"), or characters back to bit patterns.
#'
#' @section Description: If the input is a vector of 6-character bit patterns,
#'   \code{oltMap} returns the corresponding character from the Base64
#'   binary-to-text encoding. If the input is a vector of 1-character strings
#'   \code{oltMap} returns the corresponding bit pattern. If the input is
#'   numeric, it is interpreted as indices into the olt vector. The returned
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
#'   i.e \code{oltMap("000000") == oltMap(1)}
#' @return (character) A vector of Base 64 characters or their corresponding
#'   bit-patterns.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @examples
#' # oltMap three bit patterns
#' oltMap(c("101101", "011011", "010110"))   # "t"    "b"    "W"
#'
#' # oltMap three encoding characters
#' oltMap(c("a", "b", "c"))  # "011010" "011011" "011100"
#'
#' # print the entire r64 vector as one string
#' paste0(oltMap(1:64), collapse = "")
#'
#' @export

oltMap <- function(x) {
  olt <- character()
  olt["000000"] <- "A"
  olt["000001"] <- "B"
  olt["000010"] <- "C"
  olt["000011"] <- "D"
  olt["000100"] <- "E"
  olt["000101"] <- "F"
  olt["000110"] <- "G"
  olt["000111"] <- "H"
  olt["001000"] <- "I"
  olt["001001"] <- "J"
  olt["001010"] <- "K"
  olt["001011"] <- "L"
  olt["001100"] <- "M"
  olt["001101"] <- "N"
  olt["001110"] <- "O"
  olt["001111"] <- "P"
  olt["010000"] <- "Q"
  olt["010001"] <- "R"
  olt["010010"] <- "S"
  olt["010011"] <- "T"
  olt["010100"] <- "U"
  olt["010101"] <- "V"
  olt["010110"] <- "W"
  olt["010111"] <- "X"
  olt["011000"] <- "Y"
  olt["011001"] <- "Z"
  olt["011010"] <- "a"
  olt["011011"] <- "b"
  olt["011100"] <- "c"
  olt["011101"] <- "d"
  olt["011110"] <- "e"
  olt["011111"] <- "f"
  olt["100000"] <- "g"
  olt["100001"] <- "h"
  olt["100010"] <- "i"
  olt["100011"] <- "j"
  olt["100100"] <- "k"
  olt["100101"] <- "l"
  olt["100110"] <- "m"
  olt["100111"] <- "n"
  olt["101000"] <- "o"
  olt["101001"] <- "p"
  olt["101010"] <- "q"
  olt["101011"] <- "r"
  olt["101100"] <- "s"
  olt["101101"] <- "t"
  olt["101110"] <- "u"
  olt["101111"] <- "v"
  olt["110000"] <- "w"
  olt["110001"] <- "x"
  olt["110010"] <- "y"
  olt["110011"] <- "z"
  olt["110100"] <- "0"
  olt["110101"] <- "1"
  olt["110110"] <- "2"
  olt["110111"] <- "3"
  olt["111000"] <- "4"
  olt["111001"] <- "5"
  olt["111010"] <- "6"
  olt["111011"] <- "7"
  olt["111100"] <- "8"
  olt["111101"] <- "9"
  olt["111110"] <- "-"
  olt["111111"] <- "_"

  if (is.character(x) && nchar(x[1]) == 1) {
    v <- names(olt)[match(x, olt)]
  } else if (is.character(x) && nchar(x[1]) == 6) {
    v <- olt[x]
  } else if (is.numeric(x)) {
    v <- olt[x]
  } else {
    stop("Unexpected input")
  }

  return(v)
}

# [END]
