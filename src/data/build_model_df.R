#' @title Build Model Dataframe from Loss Data
#' 
#' @description This function builds a model dataframe from loss data.
#' It filters the data by line of business (lob) and only includes rows with
#' non-zero reported loss (rpt_loss). It also includes several mutate and
#' arrange operations to transform and organize the data.
#' 
#' @param loss.data.path string, the path to the loss data file
#' @param year string, the year of the data
#' @param quarter string, the quarter of the data
#' @param lob string, the line of business to filter by
#' @param col.ord vector of strings, the columns to include in the model dataframe.
#' Default is c('lob', 'ay', 'dev_month', 'cum_olep', 'rpt_loss', 'paid_loss'
#' , 'case_resv', 'paid_dcce', 'rpt_counts', 'closed_counts', 'open_counts'
#' , 'ave_rpt_loss', 'ave_paid_loss', 'ave_case_os').
#' 
#' @return A dataframe with the specified columns and filtered and transformed according to the specified lob and rpt_loss.
#' @export
#'
#' @examples
#' modeldf <- build_model_df(loss.data.path, '2022', '2', 'LOB1')
#' head(modeldf)
#' #> # A tibble: 6 x 15
#' #>   lob    ay dev_month cum_olep rpt_loss paid_loss case_resv paid_dcce rpt_counts
#' #>   <chr> <dbl>     <dbl>    <dbl>    <dbl>     <dbl>     <dbl>     <dbl>      <dbl>
#' #> 1 LOB1  2022         1  1.00e6    1.00e6     1.00e6     1.00e6     1.00e6      1.00
#' #> 2 LOB1  2022         2  1.00e6    1.00e6     1.00e6     1.00e6     1.00e6      1.00
#' #> 3 LOB1  2022         3  1.00e6    1.00e6     1.00e6     1.00e6     1.00e6      1.00
#' #> 4 LOB1  2022         4  1.00e6    1.00e6     1.00e6     1.00e6     1.00e6      1.00
#' #> 5 LOB1  2022         5  1.00e6    1.00e6     1.00e6     1.00e6     1.00e6      1.00
#' #> 6 LOB1  2022         6  1.00e6    1.00e6     1.00e6     1.00e6     1.00e6      1.00
#' #> # ... with 6 more variables: closed_counts <dbl>, open_counts <dbl>,
#' #> #   ave_rpt_loss <dbl>, ave_paid_loss <dbl>, ave_case_os <dbl>, idx <dbl>
build_model_df <- function(loss.data.path, year, quarter, lob, col.ord = c('lob', 'ay', 'dev_month', 'cum_olep', 'rpt_loss', 'paid_loss', 'case_resv', 'paid_dcce', 'rpt_counts', 'closed_counts', 'open_counts', 'ave_rpt_loss', 'ave_paid_loss', 'ave_case_os', 'idx')) {
  
  # call the build_all_lines_csu_data function to get all lines data frame
  all_lines_df <- build_all_lines_csu_data(loss.data.path, year, quarter)
  
  # reorder the columns of the all lines data frame and filter for the specified lob
  modeldf <- all_lines_df[col.ord] %>% filter(lob==lob) %>%
    # remove records with zero reported losses
    filter(round(rpt_loss) != 0) %>%
    ## drop records before CY 2009
    mutate(idx = 12*ay + dev_month) %>%
    # filter(idx > 12*2008 + 12) %>%
    # remove the index column
    select(-idx) %>% 
    # add columns for weight and development month
    mutate(w=ay - min(ay) + 1) %>% mutate(d=dev_month / 3) %>%
    # sort the data frame by lob, development month, and accident year
    arrange(lob, dev_month, ay)
  
  # return the model data frame
  return(modeldf)
}