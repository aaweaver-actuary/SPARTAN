#' @title Apply `empirical_percentile` function to each column of a matrix
#'
#' @description This function takes a matrix and a vector as input and applies the empirical_percentile function to each column of the matrix and corresponding element of the vector using the purrr::map2 function. The result is returned as a vector.
#'
#' @param mat The matrix to which the empirical percentile function will be applied
#' @param vec The vector containing the corresponding elements for each column of the matrix
#' @return A vector containing the result of applying the empirical percentile function to each column of the matrix
#' @examples
#' apply_empirical_percentile(mat, vec)
#' #> [1] 50 50 50
apply_empirical_percentile <- function(mat, vec) {
  # Use the `purrr::map2` function to apply the empirical_percentile function to each column of the matrix and corresponding element of the vector
  result <- purrr::map2(mat, vec, empirical_percentile)
  
  # Return the result vector
  return(result)
}