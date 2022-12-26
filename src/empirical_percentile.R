#' @title Calculate Empirical Percentile
#' @documentation Calculates the percentile of a test number in the empirical distribution defined by a given vector.
#' @param vec A numeric vector
#' @param test_num A numeric scalar to calculate the percentile of in the empirical distribution defined by vec
#' @return A numeric scalar representing the percentile of test_num in the empirical distribution defined by vec
#' @examples
#' empirical_percentile(c(1, 5, 10), 5)
#' #> [1] 50
#' empirical_percentile(c(12, 45, 67, 34), 34)
#' #> [1] 50
empirical_percentile <- function(vec, test_num){
  # needs tidyverse
  library(tidyverse)
  
  # Use the `tidyverse` package to calculate the percentile of the test number in the empirical distribution
  percentile <- vec %>% 
    # Sort the vector in ascending order
    arrange() %>% 
    # Find the index of the test number in the sorted vector
    which(. == test_num) %>% 
    # Calculate the percentile of the test number in the empirical distribution
    100 * (. - 0.5) / length(vec)
  
  # Return the percentile
  return(percentile)
}