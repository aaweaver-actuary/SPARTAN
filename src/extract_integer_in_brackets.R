#' @title Extract Integer in Brackets
#'
#' @description The extract_integer_in_brackets() function is used to extract an integer from a string that is surrounded by brackets. 
#' It takes a single argument, `string`, which is the string from which the integer should be extracted. 
#' The function first uses the `gsub()` function to extract the substring inside the brackets and stores it in the 
#' `substring` variable. It then attempts to convert this `substring` to an integer using the `as.integer()` function 
#' and stores the result in the `result` variable. If the conversion fails, the function returns `NA`. 
#' If the conversion is successful, the function returns the integer value stored in `result`. 
#'
#' @param string A character string from which the integer should be extracted.
#' @return The integer value extracted from the string, or `NA` if the extraction fails.
#' @examples
#' extract_integer_in_brackets("The value is [3]")
#' #> 3
#' extract_integer_in_brackets("The value is [abc]")
#' #> NA
#' @export
extract_integer_in_brackets <- function(string) {
  # Use the gsub() function to extract the substring inside the brackets
  substring <- gsub(".*\\[(.*)\\].*", "\\1", string)
  
  # Try to convert the substring to an integer using as.integer()
  result <- as.integer(substring)
  
  # If the conversion fails (e.g. because the substring is not a valid integer), return NA
  ifelse(is.na(result), NA, result)
}