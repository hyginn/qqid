% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/is.xlt.R
\name{is.xlt}
\alias{is.xlt}
\title{is.xlt}
\usage{
is.xlt(s, na.map = FALSE)
}
\arguments{
\item{s}{(character) a vector of strings to check.}

\item{na.map}{(logical) replace NA with \code{FALSE} (default), \code{NA}, or
\code{TRUE}}
}
\value{
(logical) a vector of the same length as the input, \code{TRUE} for
  every element of the input that is a valid UUID, \code{FALSE} for every
  element that is not, and \code{NA} or \code{FALSE} for every \code{NA}
  input.
}
\description{
\code{is.xlt} tests whether the function argument is a vector of 32 digit
hexadecimal numbers (a "hexlet").
}
\details{
\code{is.xlt} accepts a vector of strings and returns a logical vector of the
same length, \code{TRUE} for every element of the input that matches the
regular expression  \code{"^[0-9a-f]{32}$"}. \code{NA} values are mapped to
\code{FALSE} (default) or can be replaced with \code{NA} to preserve them.
Note: arguments passed to \code{na.map} are implicitly converted to type
logical.
}
\examples{
# check the example hexlet formats
is.xlt(xltIDexample())              # TRUE  TRUE  TRUE  TRUE  TRUE

# check one invalid format
is.xlt("2.718281828459045235360287471353")     # FALSE

# check a valid hexlet, an invalid hexlet, and an NA.
# Map input NA to NA, not to FALSE.
is.xlt(c("0c46:0ed3:b015:adc2:ab4a:01e0:9336:4f1f", # IPv6
         "c46:ed3:b015:adc2:ab4a:1e0:9336:4f1f",    # IPv6 abbreviated format
         NA), na.map = NA)                          # TRUE  FALSE  NA

}
\seealso{
\code{\link[=is.QQID]{is.QQID()}} to check QQIDs.
}
\author{
(c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
licensed under MIT (see file \code{LICENSE} in this package).
}
