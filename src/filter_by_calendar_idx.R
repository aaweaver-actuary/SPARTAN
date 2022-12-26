#' @title Filter by calendar index
#' 
#' @description This function filters a dataframe by calendar index. 
#' The calendar index is calculated as 12 * accident year + development month.
#' 
#' @param df dataframe, the dataframe to filter
#' @param year string, the year to filter by
#' @param qtr string, the quarter to filter by
#' 
#' @return A dataframe with the specified columns and filtered and
#' transformed according to the specified lob and rpt_loss.
#' @export
#' 
#' @examples
#' modeldf <- build_model_df(loss.data.path, '2022', '2', 'LOB1')
#' modeldf <- filter_by_calendar_idx(modeldf, '2022', '2')
#' #> Warning in filter_by_calendar_idx(modeldf, "2022", "2"): NAs introduced by coercion
#' head(modeldf)
#' #> # A tibble: 6 x 15
#' #>   lob    ay dev_month cum_olep rpt_loss paid_loss case_resv paid_dcce rpt_counts
#' #>   <chr> <dbl>     <dbl>    <dbl>    <dbl>     <dbl>     <dbl>     <dbl>      <dbl>
#' #> 1 LOB1  2009         1  1.00e+6  1.00e+6  1.00e+6  1.00e+6  1.00e+6          1
#' #> 2 LOB1  2009         2  2.00e+6  1.00e+6  1.00e+6  1.00e+6  1.00e+6          1
#' #> 3 LOB1  2009         3  3.00e+6  1.00e+6  1.00e+6  1.00e+6  1.00e+6          1
#' #> 4 LOB1  2009         4  4.00e+6  1.00e+6  1.00e+6  1.00e+6  1.00e+6          1
#' #> 5 LOB1  2009         5  5.00e+6  1.00e+6  1.00e+6  1.00e+6  1.00e+6          1
#' #> 6 LOB1  2009         6  6.00e+6  1.00e+6  1.00e+6  1.00e+6  1.00e+6          1
#' #> # ... with 6 more variables: cum_paid_loss <dbl>, cum_case_resv <dbl>,
filter_by_calendar_idx <- function(df, year, qtr) {
  # Ensure that year and qtr are numeric
  year <- as.numeric(year)
  qtr <- as.numeric(qtr)

  # Filter by calendar index and return
  df %>%

    # Calculate calendar index
    mutate(idx=(12*ay) + (dev_month)) %>% 

    # Filter by calendar index
    filter(idx <= (12 * year) + (3 * qtr)) %>%

    # Remove calendar index
    select(-idx)
}