library(testthat)

# parse the package name from the parent directory path (necessary because
# normal tests and R CMD Check tests are run from different directories)
x <- unlist(strsplit(gsub("(\\.Rcheck/tests)?$", "", getwd()), "/"))
pkgName <- x[length(x)]

library(pkgName, character.only = TRUE)

test_check(pkgName)
# [END]
