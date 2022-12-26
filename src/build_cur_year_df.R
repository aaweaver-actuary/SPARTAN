#' @title build_cur_year_df
#'
#' @description
#' This function calculates the current year, quarter, and day of the year
#' based on the input data frame `modeldf` and the list of parameters `params`.
#' It selects and modifies columns in the input data frame, performs a left join
#' with itself and another data frame, and filters the resulting data frame.
#'
#' @param modeldf A data frame containing data for each quarter.
#' It must have columns `w`, `year`, `quarter`, `paid_loss`, `rpt_loss`, `paid_dcce`
#' , `rpt_counts`, `closed_counts`, `ay`, `dev_month`, and `lob`.
#' @param params A list of parameters with the following elements:
#'   - `first_ay`: an integer representing the first accident year
#'   - `lob`: a character string representing the line of business
#'
#' @return A data frame with columns `w`, `d`, `paid_loss`, `rpt_loss`
#' , `paid_dcce`, `rpt_counts`, `closed_counts`, `ay`, `dev_month`, `cum_olep`.
#'
#' @examples
#' modeldf <- build_model_df(loss.data.path, '2022', '2', 'LOB1')
#' params <- list(first_ay = 2009, lob = 'LOB1')
#' build_cur_year_df(modeldf, params) %>% head()
#' #> # A tibble: 6 x 10
#' #>       w     d paid_loss rpt_loss paid_dcce rpt_counts closed_counts    ay dev_month
#' #>   <dbl> <dbl>     <dbl>    <dbl>     <dbl>      <dbl>         <dbl> <dbl>     <dbl>
#' #> 1     1     1     0.000    0.000     0.000          0             0  2009         1
#' #> 2     1     2     0.000    0.000     0.000          0             0  2009         2
#' #> 3     1     3     0.000    0.000     0.000          0             0  2009         3
#' #> 4     1     4     0.000    0.000     0.000          0             0  2009         4
#' #> 5     1     5     0.000    0.000     0.000          0             0  2009         5 
#' #> 6     1     6     0.000    0.000     0.000          0             0  2009         6
#' #> # ... with 1 more variable: cum_olep <dbl>
#' 
#' @export
build_cur_year_df <- function(modeldf, params){
  
    # This function takes in two arguments:
    # 1. modeldf: A data frame containing data for each quarter
    # 2. params: A list of parameters
    # Calculate the current year, quarter, and day of the year
  cur_year <- modeldf %>%
    
    # Select the column 'w' from the data frame
    select(w) %>%
    
    # Remove duplicates and keep only the unique values of 'w'
    unique() %>%
    
    # Add a new column 'cur_d' to the data frame
    # The value of 'cur_d' for each row is calculated as
    # 12*(year- first_ay + 1 - w) + (quarter * 3)
    # 'year' and 'quarter' are assumed to be columns in the original data frame 'modeldf'
    # 'first_ay' is a parameter passed in the 'params' list
    mutate(cur_d = 12*(year- first_ay + 1 - w) + (quarter * 3)) %>%
    
    # Add a new column 'd' to the data frame
    # The value of 'd' for each row is calculated as the value of 'cur_d' divided by 3
    mutate(d = cur_d / 3) %>%
    
    # Left join the data frame with itself on the columns 'w' and 'd'
    # Select the columns 'w', 'd', 'paid_loss', 'rpt_loss', 'paid_dcce', 'rpt_counts', 'closed_counts' from the joined data frame
    left_join(modeldf %>% select(w, d, paid_loss, rpt_loss, paid_dcce, rpt_counts, closed_counts), by=c('w', 'd')) %>%
    
    # Left join the data frame with itself on the column 'w'
    # Select the columns 'ay' and 'w' from the joined data frame, and keep only unique rows
    left_join(modeldf %>% select(ay, w) %>% unique(), by='w') %>%
    
    # Left join the data frame with itself on the column 'd'
    # Select the columns 'dev_month' and 'd' from the joined data frame, and keep only unique rows
    left_join(modeldf %>% select(dev_month, d) %>% unique(), by='d') %>%
    
    # Left join the data frame with the data frame 'all_lines_olep' on the column 'ay'
    # Select the column 'cum_olep' from the joined data frame
    # Filter the data frame 'all_lines_olep' to keep only rows where the value of 'dev_month' is 12 and 'lob' is equal to the value of 'lob' in the 'params' list
    left_join(all_lines_olep %>% filter(dev_month==12) %>% filter(lob==params$lob) %>% select(ay, cum_olep), by='ay')
  
    # The most recent AY needs a full year of premium
    current_ay <- read_csu_olep(loss.data.path, as.character(params$year), as.character(params$qtr)) %>% 
      filter(LOB==params$lob, ay==params$year, dev_month==12) %>% 
      .$cum_olep
    # browser()
    cur_year$cum_olep[cur_year$w == params$n_ay] <- current_ay
    # (cur_year %>% filter(cur_year$w==params$n_ay))$cum_olep <- current_ay
  
    # Return the modified data frame
  return(cur_year)
}