# helper-functions.R
#
# This file is automatically executed by testthat and makes its results
# available.

# parse the package name from the parent directory path (necessary because
# normal tests and R CMD Check tests are run from different directories)
x <- unlist(strsplit(gsub("\\.Rcheck", "", getwd()), "/"))
pkgName <- x[length(x)-2]

# [END]
