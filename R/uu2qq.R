# uu2qq.R

#' uu2qq
#'
#' \code{uu2qq} converts a vector of UUIDs to QQIDs.
#'
#' @section UUIDs and QQIDs: UUIDs are specially formatted 128 bit numbers.
#'   Randomly chosen UUIDs have a collision probability that is small enough to
#'   make them useful as (practically) unique identifiers in applications where
#'   centralized management of IDs is not feasible or not desirable. However
#'   since they are long strings that chiefly consist of hexadecimal numbers,
#'   they are hard to distinguish by eye and that creates difficulties for
#'   development or debugging with structured data, or for curation of UUID
#'   tagged information. The \code{qqid} package provides tools to convert the
#'   leading 5 hexadecimal digits of UUIDs (or the first 20 bits of 128-bit
#'   numbers) to two "Q-words", and the remainder to a string in a Base 64
#'   encoding. The "Q-words" - the letter Q evokes the word "cue" i.e. a hint or
#'   mnemonic - define a unique and invertible mapping to the integers (0,
#'   1023), i.e. all numbers that can be encoded with 10 bits. Thus two Q-words
#'   can encode 20 bits, or 5 hexadecimal letters: \preformatted{
#'
#'   [0-9a-f]    [0-9a-f]    [0-9a-f]    [0-9a-f]    [0-9a-f] hex:  |--0x[1]--|
#'   |--0x[2]--| |--0x[3]--| |--0x[4]--| |--0x[5]--| bit:  00 00 00 00 00 00 00
#'   00 00 00 00 00 00 00 00 00 00 00 00 00 ... int:
#'   |----------int[1]-----------| |----------int[2]-----------| (0, 1023)
#'   (0, 1023) Q:          (aims, ..., zone)     .       (aims, ..., zone)
#'   . Base64...
#'
#'   }
#'
#' @section Process: To convert a UUID to a QQID, the first five hexadecimal
#'   letters are converted to two ten bit numbers, these two numbers are
#'   interpreted as an index into the 1024-element Q-Word vector. The QQID has
#'   the two Q-words as a head, and the Base64 encoded digits 6 to 32 of the
#'   UUID as its tail. Since the mapping is fully reversible, QQIDs have exactly
#'   the same statistical properties as UUIDs. For details on QQID format see
#'   \code{\link{isValidQQID}}.
#'
#' @section Endianness: The \code{qqid} package uses its own functions to
#'   convert to and from bits, and is not affected by big-endian vs.
#'   little-endian processor architecture.
#'
#' @param uu (character) a vector of UUIDs
#' @return (character)  a vector of QQIDs
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @seealso \code{\link{qq2uu}} to convert a vector of QQIDs to UUIDs.
#'
#' @examples
#' # Convert three example UUIDs and one NA to the corresponding QQIDs
#' uu2qq( c(UUIDexample(c(1, 3, 5)), NA) )
#'
#' # forward and back again
#' myID <- "0c460ed3-b015-adc2-ab4a-01e093364f1f"
#' myID == qq2uu(uu2qq(myID))   # TRUE
#'
#' # Confirm that the example UUIDs are converted correctly
#' uu2qq( UUIDexample(2:4) ) == QQIDexample(2:4)  # TRUE TRUE TRUE
#'
#' @export

uu2qq <- function(uu) {
  stopifnot(all(isValidUUID(uu, na.map = NA), na.rm = TRUE))

  if (length(uu) == 0) { return(character(0)) }

  nas <- is.na(uu)
  uu <- uu[ ! nas]
  uu <- tolower(uu)
  uu <- gsub("-", "", uu)

  bitMat <- x32bit(uu)

  qq <- character(length(nas))
  qq[ ! nas] <- bitMat2QQ(bitMat)
  qq[   nas] <- NA_character_

  return(qq)
}


bit2int <- function(b) {
  # Not exported.
  # b: a matrix of integers {0, 1} and n rows
  # return: an n length vector of integers
  pow2 <- 2^((ncol(b)-1):0)
  return(colSums(t(b) * pow2))
}


bitMat2QQ <- function(x) {
  # Not exported. Convert a 128 column bit-matrix to a vector of QQIDs

  if (is.null(nrow(x))) { return(character(0)) }

  nr <- nrow(x)
  QQ <- matrix(character(nr * 22), nrow = nr)
  QQ[ ,  1] <- qMap(bit2int(x[ , 1:10, drop = FALSE]))
  QQ[ ,  2] <- "."
  QQ[ ,  3] <- qMap(bit2int(x[ ,11:20, drop = FALSE]))
  QQ[ ,  4] <- "."
  for (i in 0:17) {
    QQ[ , i+5] <- b64Map(apply(x[ ,(21+(i*6)):(26+(i*6)), drop = FALSE],
                               1,
                               paste, collapse = ""))
  }

  QQ <- apply(QQ, 1, paste, collapse = "")

  return(QQ)
}


x32bit <- function(x) {
  # Not-exported. Converts a vector of n 32-digit hexadeximal
  # numbers to a n * 128 matrix of bits, {0, 1}

  if (length(x) == 0) { return(numeric(0)) }

  b <- numeric(64)
  b[ 1:4 ] <- c(0, 0, 0, 0)
  b[ 5:8 ] <- c(0, 0, 0, 1)
  b[ 9:12] <- c(0, 0, 1, 0)
  b[13:16] <- c(0, 0, 1, 1)
  b[17:20] <- c(0, 1, 0, 0)
  b[21:24] <- c(0, 1, 0, 1)
  b[25:28] <- c(0, 1, 1, 0)
  b[29:32] <- c(0, 1, 1, 1)
  b[33:36] <- c(1, 0, 0, 0)
  b[37:40] <- c(1, 0, 0, 1)
  b[41:44] <- c(1, 0, 1, 0)
  b[45:48] <- c(1, 0, 1, 1)
  b[49:52] <- c(1, 1, 0, 0)
  b[53:56] <- c(1, 1, 0, 1)
  b[57:60] <- c(1, 1, 1, 0)
  b[61:64] <- c(1, 1, 1, 1)
  b <- matrix(b, ncol = 4, byrow = TRUE)
  rownames(b) <- paste0("0x", unlist(strsplit("0123456789abcdef", "")))

  x <- matrix(paste0("0x", unlist(strsplit(x,""))), nrow=length(x), byrow=TRUE)
  bit <- matrix(numeric(4 * nrow(x) * ncol(x)), nrow = nrow(x))
  for (i in seq_len(nrow(x))) {
    for (j in seq_len(ncol(x))) {
      bit[i, (((j-1)*4)+1):(((j-1)*4)+4)] <- b[x[i, j], ]
    }
  }
  return(bit)
}


# [END]
