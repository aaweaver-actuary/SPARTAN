#' @title Create a new complete data frame
#'  
#' @description Creates a data frame with all possible combinations of lob, accident period, accident index, and
#' development index, and calculates dev_month values.
#' 
#' @param df A data frame with columns lob, accident period, accident period index, development index, and dev_month.
#' @param n_w An integer representing the number of accident periods to consider.
#' @param n_d An integer representing the number of development periods to consider.
#' @param min_ay An integer representing the minimum accident year to consider.
#' 
#' @return A data frame with all possible combinations of lob, accident period, accident period index, and development
#' index, and dev_month values.
#' 
#' @examples
#' df <- tibble(lob = c("A", "B", "C"), ay = c(1, 1, 2), w = c(1, 2, 3), d = c(1, 2, 3), dev_month = c(3, 6, 9))
#' new_complete_df(df, n_w = 3, n_d = 3) %>% head()
#' #> # A tibble: 6 x 6
#' #>   lob   ay     w     d dev_month rpt_counts
#' #>   <chr> <dbl> <dbl> <dbl>    <dbl>      <dbl>
#' #> 1 A         1     1     1        3          0
#' #> 2 A         1     1     2        3          0
#' #> 3 A         1     1     3        3          0
#' #> 4 A         1     2     1        3          0
#' #> 5 A         1     2     2        3          0
#' #> 6 A         1     2     3        3          0
#' 
new_complete_df <- function(df, n_w, n_d, min_ay=2008){
  # load packages
  library(tidyverse)

  # create a data frame with all possible combinations of lob, w, and d
  lob <- df$lob %>% unique()
  w <- c(1:n_w)
  d <- c(1:n_d)
  
  out <- data.frame(lob=lob, join=1) %>%
    full_join(data.frame(w=w, join=1), by='join') %>%
    full_join(data.frame(d=d, join=1), by='join') %>%
    mutate(ay=w + min_ay - 1) %>%
    mutate(dev_month=3*d) %>%
    select(-join)
  
  return(out)

}