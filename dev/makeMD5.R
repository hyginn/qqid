# makeMD5.R
#
#
# A sample script that produces or updates an MD5 file for a package and checks
# an existing MD5 file against the package files.
#
# Author: Boris Steipe (ORCID: 0000-0002-1134-6758)
# License: (c) Author (2019) + MIT
# Date: 2019-01-17
#
# ToDo:
# Notes:
#
# ==============================================================================

# NO SIDE EFFECTS:
# This script can be safely source()'d to define the functions it contains.
# All other code will not be executed unless this is done interactively.

# ====  FUNCTIONS  =============================================================

makeMD5 <- function(myDir = getwd(), ignoreFiles, ignorePatternsIn) {
	# Purpose:
	#     produce a file that is valid input for tools::checkMD5sums()
	# Parameters:
	#     myDir:  The directory in which the resulting MD5 file will be placed.
	#             All files that are returned by a call to
	#             dir(myDir, recursive = TRUE) will be processed unless they are
	#             listed in the "ignore" parameter (see below).
	#             Defaults to the outout of getwd(). Will be used to construct
	#             fully qualified paths via file.path(), so do not add a trailing
	#             path-separator character.
	#     ignoreFiles: a vector of regular expressions. Files matching any of these
	#             expressions will not be processed. Defaults to "^MD5$". Set this
	#             parameter to "" to process all files.
	#     ignorePatternsIn: a vector of filenames. Regular expressions contained
	#                       in these files will be added to the ignoreFiles list.
	#                       Defaults to ".Rbuildignore". Set this parameter
	#                       to "" to add no patterns to the ignoreFiles list.
	#                       Filenames are expected relative to myDir and fully
	#                       qualified paths are constructed from file.path(), i.e.
	#                       in a platform independent way.
	# Details: The default values are appropriate to create an MD5 file in an R
	#          package development workflow. In this scenario, files will be
	#          mentioned in .Rbuildignore that should not appear in the
	#          package MD5 file since they will not be bundled with the package.
	#          Those files will not be processed into the MD5 output file.
	#
	#          Comment- or empty lines contained in files mentioned in
	#          "ignorePatternsIn" will be skipped.
	# Value:
	#     NULL    (invisible). The function is executed for its side effect of
	#             creating a new MD5 file in the myDir directory or updating an
	#             existing one. This file is suitable input for
	#             tools::checkMD5sums("", myDir)).

  # define regex patterns, which files to ignore
	if (missing(ignoreFiles)) {
	  ignoreFiles <- c("^MD5$")  # default: ignore MD5 file itself
	} else if (all(ignoreFiles == "")) {
	  ignoreFiles <- character()
	}

  # define files containing additional regexes
  if (missing(ignorePatternsIn)) {
    ignorePatternsIn <- c(".Rbuildignore") # default
  } else if (all(ignorePatternsIn == "")) {
    ignorePatternsIn <- character()
  }

  # process all files containing additional regexes
  for (fN in ignorePatternsIn) {
    fN <- file.path(myDir, fN)
    x <- readLines(fN)
    x <- x[! grepl("(^\\s*#)|(^\\s*$)", x)] # remove comment- or empty lines
    ignoreFiles <- c(ignoreFiles, x)        # add regex patterns to list
  }

  # make initial list of filenames
  fileNames <- dir(myDir, recursive = TRUE)

  # also make list of directory names - some regexes may exclude
  # directories, not files
  dirNames <- list.dirs(path = myDir, full.names = FALSE)
  dirNames <- dirNames[! grepl("(^\\.)|(^$)", dirNames)] # not empty or hidden

  # remove all files that need to be ignored
  for (patt in ignoreFiles) {
    if (sum(grepl(patt, dirNames)) > 0) { # note: pattern matches directories!
      # change pattern to match filepaths and remove all matching files
      # note: must terminate with .Platform$file.sep, otherwise  filenames
      #       starting with the directory string will be targeted!
      p2 <- gsub("(\\$)*$", .Platform$file.sep, patt)
      fileNames <- fileNames[! grepl(p2, fileNames)]
    }
    fileNames <- fileNames[! grepl(patt, fileNames)]
  }

  # done creating list of files to process

  # md5-process all files
  md5 <- tools::md5sum(file.path(myDir, fileNames))
  if (length(md5) > 0) {
    # filenames are fully qualified. Remove myDir to get relative
    # path, and remove first character, which must be either "\" or "/"
    md5 <- paste0(md5, " *", gsub(paste0(myDir, "."), "", names(md5)))
  }

  # output MD5 file
  writeLines(md5, con = file.path(myDir, "MD5"))

	return(invisible(NULL))
}



# ====  PROCESS  ===============================================================

if (FALSE) {

  makeMD5()
  tools::checkMD5sums("", getwd())

}


# ====  TESTS  =================================================================
# Enter your function tests here...

if (FALSE) {

  library(testthat)

  myPath <- paste0(tempdir(), "/testMD5")
  dir.create(myPath)

  myMD5 <- file.path(myPath, "MD5")

  # list.dirs(myPath)
  # list.files(myPath, recursive = TRUE)

  test_that("an empty directory creates an empty MD5", {
    makeMD5(myDir = myPath, ignoreFiles = "", ignorePatternsIn = "")
    x <- readLines(myMD5)

    unlink(myMD5)
  })

  dir.create(paste0(myPath, "/skip/skip"), recursive = TRUE)
  dir.create(paste0(myPath, "/do/do"), recursive = TRUE)
  dir.create(paste0(myPath, "/.hidden"), recursive = TRUE)

  testFN <- sprintf("test%02d.txt", 1:7)
  testFN[1] <- file.path(myPath, "",          testFN[1])
  testFN[2] <- file.path(myPath, ".hidden",   testFN[2])
  testFN[3] <- file.path(myPath, "skip",      testFN[3])
  testFN[4] <- file.path(myPath, "skip/skip", testFN[4])
  testFN[5] <- file.path(myPath, "do",        testFN[5])
  testFN[6] <- file.path(myPath, "do",        testFN[6])
  testFN[7] <- file.path(myPath, "do/do",     testFN[7])

  txt <- "Test string"


  test_that("an empty file tree creates an empty MD5", {
    makeMD5(myDir = myPath, ignoreFiles = "", ignorePatternsIn = "")
    x <- readLines(myMD5)

    expect_equal(0, length(x))                    # empty
    expect_true(tools::checkMD5sums("", myPath))  # should skip "MD5"

    unlink(myMD5)
  })

  test_that("a single file in myPath creates the right MD5", {
    writeLines(txt, con = testFN[1])
    makeMD5(myDir = myPath, ignoreFiles = "", ignorePatternsIn = "")
    x <- readLines(myMD5)

    expect_equal(1, length(x))
    expect_true(grepl(paste0("\\*", gsub("^.+/","",  testFN[1])), x))
    expect_true(tools::checkMD5sums("", myPath))

    unlink(testFN[1]) # note: we are keeping MD5
  })

  test_that("ignoring the MD5 file works", {
    writeLines(txt, con = testFN[1])
    # MD5 is not used per function default
    makeMD5(myDir = myPath, ignorePatternsIn = "")
    x <- readLines(myMD5)

    expect_equal(1, length(x))  # 1, not 2
    expect_true(grepl(paste0("\\*", gsub("^.+/","",  testFN[1])), x))
    expect_true(tools::checkMD5sums("", myPath))

    unlink(c(myMD5, testFN[1]))
  })

  test_that("several files in the tree create the right MD5", {
    for (i in 1:7) {
      writeLines(txt, con = testFN[i])
    }

    makeMD5(myDir = myPath, ignoreFiles = "", ignorePatternsIn = "")
    x <- readLines(file.path(myPath, "MD5"))

    expect_equal(6, length(x))
    expect_equal(6, sum(grepl("\\*.*test0[1-7]\\.txt", x)))
    expect_false(any(grepl("\\*.*test02\\.txt", x)))  # in .hidden directory
    expect_true(tools::checkMD5sums("", myPath))

    unlink(myMD5) # keep test files in place
  })

  test_that("one or more regular expressions work in the ignoreFiles parameter", {

    makeMD5(myDir = myPath,
            ignoreFiles = c("^MD5$", "[567]"),
            ignorePatternsIn = "")
    x <- readLines(file.path(myPath, "MD5"))

    expect_equal(3, length(x))
    expect_equal(3, sum(grepl("\\*.*test0[1-7]\\.txt", x)))
    expect_false(any(grepl("[567]\\.txt", x)))
    expect_true(tools::checkMD5sums("", myPath))

    unlink(myMD5) # keep test files in place
  })

  test_that("the default .Rbuildignore file works with one regex", {

    writeLines("test0[13]\\.txt$", con = file.path(myPath, ".Rbuildignore"))

    makeMD5(myDir = myPath)
    x <- readLines(file.path(myPath, "MD5"))

    expect_equal(4, length(x))
    expect_equal(4, sum(grepl("\\*.*test0[4-7]\\.txt", x)))
    expect_true(tools::checkMD5sums("", myPath))

    unlink(c(myMD5, file.path(myPath, ".Rbuildignore")))
  })

  test_that("the default .Rbuildignore file works with two regexes", {

    writeLines(c("test07\\.txt$",
                 "test05\\.txt$"),
               con = file.path(myPath, ".Rbuildignore"))

    makeMD5(myDir = myPath)
    x <- readLines(file.path(myPath, "MD5"))

    expect_equal(4, length(x))
    expect_equal(4, sum(grepl("\\*.*test0[1346]\\.txt", x)))
    expect_true(tools::checkMD5sums("", myPath))

    unlink(c(myMD5, file.path(myPath, ".Rbuildignore")))
  })

  test_that("the default .Rbuildignore file works with two directories", {

    writeLines(c("^skip$",
                 "^do/do$"),
               con = file.path(myPath, ".Rbuildignore"))

    makeMD5(myDir = myPath)
    x <- readLines(file.path(myPath, "MD5"))

    expect_equal(3, length(x))
    expect_equal(3, sum(grepl("\\*.*test0[156]\\.txt", x)))
    expect_true(tools::checkMD5sums("", myPath))

    unlink(c(myMD5, file.path(myPath, ".Rbuildignore")))
  })

  test_that("a file .Rtestignore file works with two regexes", {

    writeLines(c("test01\\.txt$",
                 "test06\\.txt$"),
               con = file.path(myPath, ".Rtestignore"))

    makeMD5(myDir = myPath, ignorePatternsIn = ".Rtestignore")
    x <- readLines(file.path(myPath, "MD5"))

    expect_equal(4, length(x))
    expect_equal(4, sum(grepl("\\*.*test0[3457]\\.txt", x)))
    expect_true(tools::checkMD5sums("", myPath))

    unlink(c(myMD5, file.path(myPath, ".Rtestignore")))
  })

  test_that("two ignore files with two regexes each work", {

    writeLines(c("^skip$",
                 "test01\\.txt$"),
               con = file.path(myPath, ".Rbuildignore"))
    writeLines(c("test05\\.txt$",
                 "^do/do$"),
               con = file.path(myPath, ".Rtestignore"))

    makeMD5(myDir = myPath, ignorePatternsIn = c(".Rbuildignore",
                                                 ".Rtestignore"))
    x <- readLines(file.path(myPath, "MD5"))

    expect_equal(1, length(x))
    expect_equal(1, sum(grepl("\\*.*test06\\.txt", x)))
    expect_true(tools::checkMD5sums("", myPath))

    unlink(c(myMD5,
             file.path(myPath, ".Rtestignore"),
             file.path(myPath, ".Rbuildignore")))
  })

  # Cleanup:

  # unlink(testFN)
  # unlink(myPath, recursive = TRUE)

  # list.dirs(myPath)
  # list.files(myPath, recursive = TRUE)

}


# [END]
