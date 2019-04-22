# xlt2qq.R

#' xlt2qq
#'
#' \code{xlt2qq} converts a vector of 128-bit numbers (hexlets) in hexadecimal
#' notation, UUID format, IPv6 addresses, or MD5 hashes to QQIDs.
#'
#' @section 128-bit numbers and QQIDs: UUIDs, IPv6 addresses and MD5 hashes are
#'   specially formatted 128-bit numbers, referred to as
#'   \href{https://en.wikipedia.org/wiki/Units_of_information#Hexlet}{hexlets}.
#'   Randomly chosen 128-bit numbers have a collision probability that is small
#'   enough to make them useful as (practically) unique identifiers in
#'   applications where a centralized management of IDs is not feasible or not
#'   desirable. However since they are long strings of numerals and letters,
#'   without overt semantic content, they are hard to distinguish by eye. This
#'   creates difficulties when developing, or debugging with structured data, or
#'   for the curation of ID tagged information. The \code{qqid} package provides
#'   tools to convert the leading 20-bits of 128-bit numbers to two "Q-words",
#'   and the remainder to a string of 18 Base64 encoded characters. The
#'   "Q-words" - the letter Q evokes the word "cue" i.e. a hint or mnemonic -
#'   define a unique and invertible mapping to 2^10 integers (0, 1023). Thus two
#'   Q-words can encode 20 bits, or 5 hexadecimal letters:

#'   \preformatted{
#'.
#'.          [0-9a-f]    [0-9a-f]    [0-9a-f]    [0-9a-f]    [0-9a-f]
#'.  hex:  |--0x[1]--| |--0x[2]--| |--0x[3]--| |--0x[4]--| |--0x[5]--|
#'.  bit:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
#'.        |----------int[1]-----------| |----------int[2]-----------|
#'.  int:            (0, 1023)                      (0,1023)
#'.    Q:      (aims, ..., zone)     .       (aims, ..., zone)     .   Base64...
#'.
#'   }

#' @section Process: Input strings are first converted to plain hexadecimal
#'   strings. A leading "0x" is deleted, the "-" and ":" separators of UUIDs and
#'   IPv6 addresses respectively are deleted, and all letters are converted to
#'   lower case. It is an error if the result is not exactly a 32 digit
#'   hexadecimal \code{"[0-9a-f]\{32\}"} string. The first five hexadecimal
#'   letters are interpreted as two ten bit numbers, and mapped as indices into
#'   the 1024-element Q-Word vector. The QQID has two Q-words as a head
#'   representing digits 1:5 of the input, and the 18 Base64 encoded digits 6:32
#'   of the input as its tail. Since the mapping is fully reversible, QQIDs have
#'   exactly the same statistical properties as the input. For details on QQID
#'   format see \code{\link[=is.QQID]{is.QQID()}}.
#'
#' @section Input formats: A hexlet comprises 16 octets and is written in the
#'   hexadecimal numeral convention. A canonical MD5 hash is such a string of 32
#'   hexadecimal characters. To improve readability, separators are inserted
#'   into UUIDs: \code{"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"} where \code{"x"}
#'   is a hexadecimal letter. A canonical expanded IPv6 address has the form:
#'   \code{"xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx"} where \code{"x"} is a
#'   hexadecimal letter. Conventions exist to omit leading zeros in IPv6
#'   addresses, such shortened addresses are treated as an error. It is up to
#'   the user to expand them correctly before processing.  There are many
#'   representations of hexadecimal numbers, most commonly they have a prefix of
#'   "0x". \code{xlt2qq()} converts all letters to lowercase on input.
#'
#' @section Endianness: The \code{qqid} package uses its own functions to
#'   convert to and from bits, and is not affected by big-endian vs.
#'   little-endian processor architecture or variant byte order. All numbers are
#'   interpreted to have their lowest order digits on the right.
#'
#' @param xlt (character) a vector of UUIDs, MD5 hashes, IPv6 addresses, or
#'   generally 32 digit hexadecimal numbers
#'
#' @return (character)  a vector of QQIDs
#'
#' @seealso \code{\link[=qq2uu]{qq2uu()}} to convert a vector of QQIDs to UUIDs.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' # Convert three example UUIDs and one NA to the corresponding QQIDs
#' xlt2qq( c(xltIDexample(c(1, 3, 5)), NA) )
#'
#' # A random hex-string is converted into a valid QQID
#' (x <- paste0(sample(c(0:9, letters[1:6]), 32, replace=TRUE), collapse=""))
#' (x <- xlt2qq(x))
#' is.QQID(x)                    # TRUE
#'
#' # forward and back again
#' myID <- "0c460ed3-b015-adc2-ab4a-01e093364f1f"
#' myID == qq2uu(xlt2qq(myID))   # TRUE
#'
#' # Confirm that the example hexlets are converted correctly
#' xlt2qq( xltIDexample(1:5) ) == QQIDexample(1:4)  # TRUE TRUE TRUE TRUE TRUE
#'
#' @export

xlt2qq <- function(xlt) {
  if (length(xlt) == 0) { return(character(0)) }
  stopifnot(is.character(xlt))
  stopifnot(is.vector(xlt))

  xlt <- unformatXlt(xlt)
  stopifnot(all(is.xlt(xlt, na.map = NA), na.rm = TRUE))

  nas <- is.na(xlt)
  xlt <- xlt[ ! nas]

  bitMat <- xlt2bit(xlt)

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
    QQ[ , i+5] <- sxtMap(apply(x[ ,(21+(i*6)):(26+(i*6)), drop = FALSE],
                               1,
                               paste, collapse = ""))
  }

  QQ <- apply(QQ, 1, paste, collapse = "")

  return(QQ)
}


xlt2bit <- function(x) {
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


unformatXlt <- function(s) {
  # Not exported. Function is NA-safe.
  # Note: do not convert too aggressively since that would risk converting
  # invalid input to a seemingly valid entry.

  s <- tolower(s)           # all lower case
  s <- gsub("^0x", "", s)   # drop 0x prefix if any
  s <- gsub("[:-]", "", s)  # drop IPv6 or UUID separators

  return(s)
}


# [END]
