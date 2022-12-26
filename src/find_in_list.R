#' @title Find elements in list
#'
#' @description This function takes two lists as input and returns a logical vector indicating
#' whether each element of the first list is present in the second list.
#'
#' @param list1 A list of elements.
#' @param list2 A list of elements to search in.
#' @return A logical vector of the same length as `list1`, with elements that are `TRUE` if
#' the corresponding element in `list1` is present in `list2`, and `FALSE` otherwise.
#' @examples
#' list1 <- c(1, 2, 3, 4)
#' list2 <- c(3, 4, 5, 6)
#' find_in_list(list1, list2)
#' #> [1] FALSE FALSE  TRUE  TRUE
#' 
find_in_list <- function(list1, list2) {
  # Initialize an empty logical vector to store the result
  result <- logical(length(list1))
  
  # Iterate over the elements of list1
  for (i in seq_along(list1)) {
    # Check if the current element of list1 is present in list2
    if (list1[i] %in% list2) {
      # If the element is present, set the corresponding element in the result vector to TRUE
      result[i] <- TRUE
    }
  }
  
  # Return the result vector
  return(result)
}