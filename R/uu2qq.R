# uu2qq.R

#' uu2qq.
#'
#' \code{uu2qq} converts a vector of UUIDs to QQIDs.
#'
#' Details.
#'
#'
#' @section UUIDs: UUIDs are specially formatted 128 bit numbers. Randomly
#' chosen UUIDs have a collision probability that is small enough to make them
#' useful as (practically) unique identifiers in applications where centralized
#' management of IDs is not feasible or not desireable. However since they are
#' long strings that chiefly consist of hexadecimal numbers, they are hard to
#' distingiush by eye and that creates difficulties for development or debugging
#' with structured data, or for curation of UUID tagged information.
#' These "Q" words - the letter Q evokes the word "cue" i.e. a hint or mnemonic
#' - define a unique and invertible mapping to the integers (0, 1023), i.e. all
#' numbers that can be encoded with 10 bits. Thus two Q-words can encode 20
#' bits, or 5 hexadecimal letters:\cr
#' \code{         [0-9a-f]    [0-9a-f]    [0-9a-f]    [0-9a-f]    [0-9a-f]  }\cr
#' \code{  hex:  |--0x[1]--| |--0x[2]--| |--0x[3]--| |--0x[4]--| |--0x[5]--|}\cr
#' \code{  bit:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}\cr
#' \code{  int:  |----------int[1]-----------| |----------int[2]-----------|}\cr
#' \code{                  (0, 1023)                     (0, 1023)          }\cr
#' \code{  Q:          (aims, ..., zone)             (aims, ..., zone)      }\cr
#'
#' @section Process: To convert a UUID to a QQID, the first five hexadecimal
#' letters are converted to two ten bit numbers, these two numbers are
#' interpreted as an index into the 1024-element Q-Word vector. The QQID has
#' the two vectors as a head, and the original characters 6 to 32 of the UUID
#' as its tail. Since the mapping is fully reversible, QQIDs have exactly the
#' same statistical properties as UUIDs. For details on QQID format see
#' \code{\link{isValidQQID}}.
#'
#' @section Endianness: The conversion of hex numbers to Q-words assumes a
#' little-endian byte order. This means the mapping may not be reversible
#' between different processor architectures. Nearly all platforms on which
#' this code is likely to run are little-endian. In addition, a swapped byte
#' order will still yield valid and equally random QQIDs. If this issue is of
#' concern, check your system with the example code provided here. You can
#' also check your architecture with \code{.Platform$endian}.
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
#' # This expression is TRUE and correct if the code
#' # is executed on a little-endian processor architecture.
#' uu2qq( UUIDexample(1) ) == QQIDexample(1)
#'
#' @export

uu2qq <- function(uu) {
  stopifnot(all(isValidUUID(uu, na.map = NA), na.rm = TRUE))
  if (length(uu) == 0) {
    return(character(0))
  }
  nas <- is.na(uu)
  X <- paste0("0x", substr(uu, 1, 5))   # prefix with "0x"
  iQ <- x5int(X) + 1                    # (0, 1023) -> (1, 1024)
  qq <- paste0(qMap(iQ[ , 1]), ".", qMap(iQ[ , 2]), "-", substr(uu, 6, 36))
  qq[nas] <- NA_character_
  return(qq)
}

x5int <- function(x) {
  # Non-exported helper function. Converts a vector of 5-digit hexadeximal
  # numbers to a two column matrix of integers.
  #
  # x (character) a vector of 5 digit hex numbers
  # return: a 2 column matrix of integers in the range (0, 1023)
  #
  # |--0x[1]--| |--0x[2]--| |--0x[3]--| |--0x[4]--| |--0x[5]--|
  # 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  # |----------int[1]-----------| |----------int[2]-----------|
  #
  # Note: numbers are interpreted as little-endian and thus the appropriate
  # columns need to be swapped. This may mean that the mapping of hex to QQ
  # is not reversible between little-endian and big-endian platforms. If this
  # is an issue we might need to switch conditional on the value of
  # .Platform$endian

  pow2 <- 2^(9:0)
  x <- matrix(as.integer(intToBits(strtoi(x))), ncol = 32, byrow = TRUE)
  x <- x[ , c(20:17,16:13,12:9,8:5,4:1), drop = FALSE]
  int <- t(rbind(colSums(t(x[ ,  1:10, drop = FALSE]) * pow2),
                 colSums(t(x[ , 11:20, drop = FALSE]) * pow2)))
  return(int)
}

# [END]
