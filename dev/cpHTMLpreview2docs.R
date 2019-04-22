# cpHTMLpreview2docs.R

#' cpHTMLpreview2docs
#'
#' \code{cpHTMLpreview2docs} Utility to move a copy of the preview created by
#' \code{pandoc()} to \code{index.html} in the \code{./docs} folder.
#'
#' @section Details: GitHub pages expects \code{index.html} in the \code{./docs}
#' folder of the repository. This function puts the pandoc preview of
#' \code{README.md} into the location defined by \code{targetFile}. The function
#' aborts if the preview directory or file is not unique.
#'
#' @params targetFile (character) the filename to write to. Default:
#' \code{./docs/index.html}.
#'
#' @return NULL (invisible) Invoked for the side-effect of copying a file.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' \dontrun{
#' # run the function
#' cpHTMLpreview2docs()
#' }
#'

cpHTMLpreview2docs <- function(targetFile = "./docs/index.html") {

  pandocDir <- list.files(path = tempdir(),
                          pattern = "^preview.+\\.dir$",
                          full.names = TRUE)
  stopifnot(length(pandocDir) == 1)

  previewFile <- list.files(path = pandocDir,
                          pattern = "^README\\.html$",
                          full.names = TRUE)
  stopifnot(length(previewFile) == 1)

  system(sprintf("cp %s %s", previewFile, targetFile))
  message(sprintf("executed \"cp %s %s\"", previewFile, targetFile))

  return(invisible(NULL))

}

# [END]
