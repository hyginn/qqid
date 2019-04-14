# qq2uu.R

#' qq2uu.
#'
#' \code{qq2uu} converts a vector of QQIDs to UUIDs.
#'
#' Details.
#'
#' @section QQIDs: QQIDs are specially formatted UUIDs. See
#' \code{\link{uu2qq}} for the the motivation of mapping UUIDs to QQIDs and
#' details on how QQIDs are structured. This function reveses the mapping
#' exactly to recover the original UUID.
#'
#' @section Process: To convert a QQID to a UUID, the two "Q-words" that head
#' the QQID are mapped to their index in the 1024-element Q-word vector (cf.
#' \code{\link{qMap}}), and the indices are converted to two ten bit numbers.
#' These twenty bits are expressed as a five-digit hexadecimal number which
#' replaces the two Q-words to recover the UUID. For details on UUID format see
#' \code{\link{isValidUUID}}.
#'
#' @section Endianness: The conversion of Q-words to hex-numbers assumes a
#' little-endian byte order. This means the mapping may not be reversible
#' between different processor architectures. Nearly all platforms on which
#' this code is likely to run are little-endian. In addition, a swapped byte
#' order will still yield valid and equally random UUIDs. If this issue is of
#' concern, check your system with the example code provided here. You can
#' also check your architecture with \code{.Platform$endian}.
#'
#' @param qq (character) a vector of QQIDs
#' @return (character)  a vector of UUIDs
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{uu2qq}} to convert a vector of UUIDs to QQIDs.
#'
#' @examples
#' # Convert three example QQIDs and one NA to the corresponding UUIDs
#' qq2uu( c(QQIDexample(c(1, 3, 5)), NA) )
#'
#' # This expression is TRUE and correct if the code
#' # is executed on a little-endian processor architecture.
#' qq2uu( QQIDexample(1) ) == UUIDexample(1)
#'
#' @export

qq2uu <- function(qq) {
  stopifnot(all(isValidQQID(qq, na.map = NA), na.rm = TRUE))
  if (length(qq) == 0) {
    return(character(0))
  }
  nas <- is.na(qq)

  I <- cbind(qMap(substr(qq, 1, 4)) - 1, qMap(substr(qq, 6, 9)) - 1)
  X <- intX5(I)
  uu <- paste0(X, substr(qq, 11, 41))

  uu[nas] <- NA_character_

  return(uu)
}

intX5 <- function(x) {
  # Non-exported helper function. Converts a two column matrix of integers
  # to a vector of 5-digit hexadeximal numbers.
  #
  # return: (numeric) a 2 column matrix of integers in the range (0, 1023)
  # return: (character) a vector of 5 digit hex numbers (without 0x prefix)
  #
  # |----------int[1]-----------| |----------int[2]-----------|
  # 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  # |--0x[1]--| |--0x[2]--| |--0x[3]--| |--0x[4]--| |--0x[5]--|
  #
  # Note: numbers are interpreted as little-endian and thus the appropriate
  # columns need to be swapped. This may mean that the mapping of hex to QQ
  # is not reversible between little-endian and big-endian platforms. If this
  # is an issue we might need to switch conditional on the value of
  # .Platform$endian

  pow2 <- 2^(3:0)
  xMap <- unlist(strsplit("0123456789abcdef", ""))

  x <- cbind(matrix(as.integer(intToBits(t(x)[1, , drop = FALSE])),
                    ncol = 32, byrow = TRUE),
             matrix(as.integer(intToBits(t(x)[2, , drop = FALSE])),
                    ncol = 32, byrow = TRUE))
  x <- x[ , c(10:1, 42:33), drop = FALSE]

  h <- cbind(xMap[colSums(t(x[ ,  1:4,  drop = FALSE]) * pow2) + 1],
             xMap[colSums(t(x[ ,  5:8,  drop = FALSE]) * pow2) + 1],
             xMap[colSums(t(x[ ,  9:12, drop = FALSE]) * pow2) + 1],
             xMap[colSums(t(x[ , 13:16, drop = FALSE]) * pow2) + 1],
             xMap[colSums(t(x[ , 17:20, drop = FALSE]) * pow2) + 1])

  return(paste0(h[ ,1], h[ ,2], h[ ,3], h[ ,4], h[ ,5]))
}

# [END]
