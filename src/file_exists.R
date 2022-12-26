#' @title Check if a file exists
#'
#' @description This function takes a file path as input and returns `TRUE` if the file exists and `FALSE` otherwise.
#'
#' @param file The file path to check
#' @return A logical value indicating if the file exists
#' @examples
#' file_exists("/tmp/file.txt")
#' #> [1] TRUE
#' file_exists("/tmp/does_not_exist.txt")
#' #> [1] FALSE
file_exists <- function(file) {
  if (file.exists(file)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}