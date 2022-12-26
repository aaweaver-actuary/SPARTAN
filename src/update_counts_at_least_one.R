#' @title Update Counts in a Data Frame
#' @description This function updates the values of the `rpt_counts`, `closed_counts`, and `open_counts` columns in a data frame.
#' It sets `rpt_counts` and `closed_counts` to 1 if the difference between `analysis_year` and `ay` is less than the 
#' difference between 2012 and `ay` and the value is currently 0. It then sets `open_counts` equal to `rpt_counts - closed_counts`.
#'
#' @param df A data frame with columns `rpt_counts`, `closed_counts`, `analysis_year`, and `ay`.
#' @return A modified version of `df` with updated values of `rpt_counts`, `closed_counts`, and `open_counts`.
#' @export
#' @examples
#' df <- tibble(rpt_counts = c(0, 0, 0, 0, 1, 1), closed_counts = c(0, 0, 1, 1, 0, 0),
#'             analysis_year = rep(2012, 6), ay = rep(2008, 6))
#' update_counts_at_least_one(df)
#' #> # A tibble: 6 x 4
#' #>   rpt_counts closed_counts analysis_year ay
#' #>        <dbl>         <dbl>         <dbl> <dbl>
#' #> 1          1             1           2012 2008
#' #> 2          1             1           2012 2008
#' #> 3          1             1           2012 2008
#' #> 4          1             1           2012 2008
#' #> 5          1             0           2012 2008
#' #> 6          1             0           2012 2008
update_counts_at_least_one <- function(df) {
  # Update rpt_counts and closed_counts values to 1 if (analysis_year - ay) < 2012 - ay and the value is currently 0
  df$rpt_counts[(df$analysis_year - df$ay) < (2012 - df$ay) & df$rpt_counts == 0] <- 1
  df$closed_counts[(df$analysis_year - df$ay) < (2012 - df$ay) & df$closed_counts == 0] <- 1
  
  # Set open_counts equal to rpt_counts - closed_counts
  df$open_counts <- df$rpt_counts - df$closed_counts
  
  return(df)
}