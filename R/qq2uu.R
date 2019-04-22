# qq2uu.R

#' qq2uu
#'
#' \code{qq2uu} converts a vector of QQIDs to UUIDs.
#'
#' @section QQIDs: QQIDs are specially formatted 128-bit numbers (hexlets), just
#'   like UUIDs. See \code{\link[=xlt2qq]{xlt2qq()}} for the the motivation of
#'   mapping UUIDs to QQIDs and details on how QQIDs are structured.
#'   \code{qq2uu} reverses the mapping exactly to recover the original UUID.
#'
#' @section Process: To convert a QQID to a UUID, the two "Q-words" that head
#'   the QQID are mapped to their index in the 0:1023 Q-word vector (cf.
#'   \code{\link[=qMap]{qMap()}}), and the indices are converted to two ten bit
#'   numbers. These twenty bits are expressed as a five-digit hexadecimal number
#'   which replaces the two Q-words to recover the UUID. For details on UUID
#'   format see \code{\link[=is.xlt]{is.xlt()}}. The remaining 18 Base64 encoded
#'   characters are converted to their corresponding 27 hex digits via an
#'   intermediate mapping to bit-patterns.
#'
#' @section Endianness: The \code{qqid} package uses its own functions to
#'   convert to and from bits, and is not affected by big-endian vs.
#'   little-endian processor architecture or variant byte order. All numbers are
#'   interpreted to have their lowest order digits on the right.
#'
#' @param qq (character) a vector of QQIDs
#' @return (character)  a vector of UUIDs
#'
#' @seealso \code{\link[=xlt2qq]{xlt2qq()}} to convert a vector of UUIDs, IPv6
#'   addresses or other hexlets to QQIDs.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' # Convert three example QQIDs and one NA to the corresponding UUIDs
#' qq2uu( c(QQIDexample(c(1, 3, 5)), NA) )
#'
#' # forward and back again
#' myID <- "bird.carp.7TsBWtwqtKAeCTNk8f"
#' myID == xlt2qq(qq2uu(myID))             # TRUE
#'
#' # Confirm that example QQID No. 3 is formatted correctly as a UUID
#' qq2uu( QQIDexample(3) ) == xltIDexample("UUID")  # TRUE
#'
#' @export

qq2uu <- function(qq) {
  stopifnot(all(is.QQID(qq, na.map = NA), na.rm = TRUE))
  if (length(qq) == 0) {
    return(character(0))
  }
  nas <- is.na(qq)
  lqq <- length(qq)    # save original length before removing NAs
  qq <- qq[ ! nas]

  # bit Matrix
  I <- matrix(numeric(128 * length(qq)), ncol = 128)
  # Q-words -> integer -> 2 * 10 digit bit matrix
  I[ ,  1:10 ] <- i2bit(qMap(substr(qq, 1, 4)), l = 10)
  I[ , 11:20 ] <- i2bit(qMap(substr(qq, 6, 9)), l = 10)

  # Base64 -> integer -> 18 * 6 bit matrix
  for(j in 1:18) {
    j1 <- (((j-1)*6)+21)
    j2 <- j1 + 5
    jq <- j+10
    I[ , j1:j2] <- i2bit(sxt2i(substr(qq, jq, jq)), l = 6)
  }

  # hex Matrix
  X <- matrix(character(32 * length(qq)), ncol = 32)
  for(j in 1:32) {
    j1 <- (((j-1)*4)+1)
    j2 <- j1 + 3
    # 4 column bit matrix -> quad -> hex character
    X[ , j] <- quad2x(I[ , j1:j2, drop = FALSE])
  }

  uu <- character(lqq)  # make length same as original input

  uu[ ! nas]<- apply(X, 1,
                     FUN = function(x) {paste0(c(x[ 1:8 ], "-",
                                                 x[ 9:12], "-",
                                                 x[13:16], "-",
                                                 x[17:20], "-",
                                                 x[21:32]), collapse = "")})
  uu[nas] <- NA

  return(uu)
}


quad2x <- function(x) {
  # Non exported. Convert a 4 column bit-pattern matrix to its
  # corresponding hexadecimal character.

  hMap <- unlist(strsplit("0123456789abcdef", ""))
  pow2 <- 2^(3:0)

  return(hMap[colSums(t(x) * pow2) + 1])
}


i2bit <- function(x, l) {
  # Non exported. Convert an integer vector in (0, 1023) to a matrix
  # of l bits each. No checking is done to confirm that no element of the input
  # requires more than l bits to be represented.

  pow2 <- 2^((l-1):0)

  n <- length(x)
  x <- rep(x, each = l)
  m <- matrix((t(x) %/% rep(pow2, n)) %% 2, ncol = l, byrow = TRUE)

  return(m)

}


# x2i <- function(x) {   # Not currently used
#   # Non exported. Convert a vector of hexadeximal characters to their
#   # corresponding integers.
#   xMap <- 0:15
#   names(xMap) <- unlist(strsplit("0123456789abcdef", ""))
#
#   return(xMap[x])
# }


sxt2i <- function(x) {
  # Non exported. Convert a vector of Base 64 characters to their
  # corresponding integers.
  sxt <- sxtMap(1:64)
  return(match(x, sxt) - 1)
}


# [END]
