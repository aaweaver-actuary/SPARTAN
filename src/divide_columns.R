#' Divide Columns of a Data Frame by Corresponding Elements in a Vector
#'
#' This function divides each column of a data frame by the corresponding element in a vector.
#'
#' @param df A data frame.
#' @param vec A vector.
#' @return A data frame with each column divided by the corresponding element in the vector.
#' @examples
#' # Test the function with a sample data frame and vector
#' df <- data.frame(a = c(1, 2, 3), b = c(4, 5, 6), c = c(7, 8, 9))
#' vec <- c(10, 20, 30)
#' divide_columns(df, vec)
#'
#' @export
divide_columns <- function(df, vec = exp(stan_dat$log_prem_ay)) {
  library(tidyverse)
  # Use the mutate() function from the dplyr package to apply a function to each column of the data frame
  # The .fns argument specifies the function to apply to each column.
  # In this case, we're using the map2() function from the purrr package.
  # The .x argument specifies the first argument to pass to map2().
  # In this case, it's the vec vector
  # The .y argument specifies the second argument to pass to map2(). In this case, it's the data frame, which is represented by the . symbol
  df %>% 
    mutate(across(.fns = map2, .x = vec, .y = .))
}