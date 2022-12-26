#' @title Run a function based on whether a file exists
#' @description This function takes a file path and two functions as input and runs one of the functions based on whether the file exists. If the file exists, it runs the first function (`ftnA`) and if the file does not exist, it runs the second function (`ftnB`).
#'
#' @param file The file path to check
#' @param ftnA The function to run if the file exists
#' @param ftnB The function to run if the file does not exist
#' @return The output of either `ftnA` or `ftnB`, depending on whether the file exists
#' @examples
#' run_if_file_exists("/tmp/file.txt", mean, sd)
#' run_if_file_exists("/tmp/does_not_exist.txt", mean, sd)
run_if_file_exists <- function(file, ftnA, ftnB) {
  if (file.exists(file)) {
    return(ftnA())
  } else {
    return(ftnB())
  }
}