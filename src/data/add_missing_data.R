#' @title Add missing data to a data frame
#' @description Creates a data frame with all possible combinations of lob, accident year, accident period index, and 
#' development period, and calculates dev_month values. Missing values are filled with 0. Then, adds the rows from the 
#' original data frame that are not in the completed data frame to the output. Finally, sorts the final data frame by lob, 
#' development period, development month, accident
#' @param df A data frame with columns lob, accident year, accident year week, development period, and dev_month.
#' @param min_ay An integer representing the minimum accident year to consider.
#' @param n_w An integer representing the number of accident years to consider.
#' @param n_d An integer representing the number of development periods to consider.
#' @return A data frame with all possible combinations of lob, accident year, accident year index, and development period, 
#' and calculated dev_month values. Missing values are filled with 0. Then, adds the rows from the original data frame 
#' that are not in the completed data frame. Finally, sorts the final data frame by lob, development period, development 
#' month, accident year, and accident period index.
#' @examples
#' df <- tibble(lob = c("A", "B", "C"), ay = c(1, 1, 2), w = c(1, 2, 3), d = c(1, 2, 3), dev_month = c(3, 6, 9))
#' add_missing_data(df, min_ay = 1, n_w = 3, n_d = 3) %>% head()
#' #> # A tibble: 6 x 5
#' #>   lob    ay     w     d dev_month
#' #>   <chr> <dbl> <dbl> <dbl>    <dbl>
#' #> 1 A         1     1     1        3
#' #> 2 A         1     1     2        0
#' #> 3 A         1     1     3        0
#' #> 4 A         1     2     1        0
#' #> 5 A         1     2     2        6
#' #> 6 A         1     2     3        0 
#' 
#' @export
add_missing_data <- function(df, min_ay, n_w, n_d) {
  # Include the tidyverse package
  library(tidyverse)
  
  # Run the complete_data function to get a data frame with all possible combinations of lob, ay, w, and d
  complete_df <- new_complete_df(df, n_w, n_d, min_ay)
  
  df_rows <- df %>% 
    apply(1, function(x){x['lob'] %>% str_c("-",as.character(x['w']) %>% str_trim(), "-", as.character(x['d']) %>% str_trim())})
  
  complete_df_rows <- complete_df %>% 
    apply(1, function(x){x['lob'] %>% str_c("-",as.character(x['w']) %>% str_trim(), "-", as.character(x['d']) %>% str_trim())})
  
  # Find the rows in complete_df that are not present in df
  missing_rows <- !complete_df_rows %in% df_rows
  
  
  #build data frame from these missing rows
  missing_df <- data.frame(idx=complete_df_rows[missing_rows]) %>%
    separate(col=idx, into=c("lob", "w", "d"), sep="-", remove=F) %>%
    mutate(ay=as.numeric(w) + min_ay - 1) %>%
    mutate(dev_month=as.numeric(d) * 3)
  
  missing_idx <- missing_df %>% select(idx)
  
  missing_df <- missing_df %>% select(-idx)
  
  for(c in names(df)[!names(df) %in% names(missing_df)]){
    missing_df[, c] <- 0
  }
  # browser()
  # Add the missing rows to df
  if(length(missing_rows) > 0) {
    df <- rbind(df, missing_df)
  }
  
  # replace the NA values with zeros
  df[is.na(df)] <- 0 
  
  # Sort the final data frame by lob, development period, development month, accident year, and accident period index
  df <- df %>%
    mutate(d=as.numeric(d)) %>%
    mutate(w=as.numeric(w)) %>%
    mutate(dev_month=as.numeric(dev_month)) %>%
    mutate(ay=as.numeric(ay)) %>%
    arrange(lob, d, dev_month, ay, w)
  
  # browser()
  
  # Return the final data frame
  return(df)
}