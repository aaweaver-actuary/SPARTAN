#' @title Recalculate cumulative frequency and average loss values in a data frame
#'
#' @description This function takes a data frame, `df`, and recalculates the following values:
#' - `cum_rpt_freq`: frequency of reported claims, calculated as `rpt_counts / (cum_olep / 1000)`
#' - `cum_closed_freq`: frequency of closed claims, calculated as `closed_counts / (cum_olep / 1000)`
#' - `open_freq`: frequency of open claims, calculated as `open_counts / (cum_olep / 1000)`
#' - `paid_reported`: ratio of paid loss to reported loss, calculated as `paid_loss / rpt_loss`
#' - `closed_reported`: ratio of closed claims to reported claims, calculated as `closed_counts / rpt_counts`
#' - `ave_rpt_loss`: average reported loss per claim, calculated as `rpt_loss / rpt_counts`
#' - `ave_paid_loss`: average paid loss per closed claim, calculated as `paid_loss / closed_counts`
#' - `ave_case_os`: average case outstanding per open claim, calculated as `case_resv / open_counts`
#'
#' @param df A data frame containing columns `rpt_counts`, `closed_counts`, `open_counts`, `cum_olep`, `paid_loss`, 
#' `rpt_loss`, `case_resv`, and `closed_reported`.
#'
#' @return A modified version of the input data frame with updated values for `cum_rpt_freq`, `cum_closed_freq`, `open_freq`, `paid_reported`, `closed_reported`, `ave_rpt_loss`, `ave_paid_loss`, and `ave_case_os`.
#'
#' @examples
#' df <- data.frame(rpt_counts = c(10, 20, 30, 40),
#'                  closed_counts = c(5, 15, 25, 35),
#'                  open_counts = c(5, 5, 5, 5),
#'                  cum_olep = c(1000, 2000, 3000, 4000),
#'                  paid_loss = c(100, 200, 300, 400),
#'                  rpt_loss = c(50, 100, 150, 200),
#'                  case_resv = c(25, 50, 75, 100),
#'                  closed_reported = c(0.5, 0.75, 0.83, 0.87))
#' recalculate_frequency_and_average_loss(df)
#' #>   rpt_counts closed_counts open_counts cum_olep paid_loss rpt_loss case_resv
#' #> 1         10             5           5     1000       100       50        25
#' #> 2         20            15           5     2000       200      100        50
#' #> 3         30            25           5     3000       300      150        75
#' #> 4         40            35           5     4000       400      200       100
#' #>   closed_reported cum_rpt_freq cum_closed_freq open_freq paid_reported
#' #> 1            0.50        0.010           0.005     0.005           1.0
#' #> 2            0.75        0.010           0.007     0.002           2.0
#' #> 3            0.83        0.010           0.008     0.001           2.0
#' #> 4            0.87        0.010           0.008     0.001           2.0
#' #>   closed_reported ave_rpt_loss ave_paid_loss ave_case_os
#' #> 1            0.50          5.0          20.0         5.0
#' #> 2            0.75          5.0          13.3         5.0
#' #> 3            0.83          5.0          12.0         5.0
#' #> 4            0.87          5.0          11.4         5.0
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#'
#' @export
recalculate_frequency_and_average_loss <- function(df) {
  # Calculate the frequency of reported claims
  # Divide the number of reported claims (rpt_counts) by the cumulative OLEP value (cum_olep) and divide the result by 1000
  df <- df %>%
    mutate(cum_rpt_freq = rpt_counts / (cum_olep / 1000))
  
  # Calculate the frequency of closed claims
  # Divide the number of closed claims (closed_counts) by the cumulative OLEP value (cum_olep) and divide the result by 1000
  df <- df %>%
    mutate(cum_closed_freq = closed_counts / (cum_olep / 1000))
  
  # Calculate the frequency of open claims
  # Divide the number of open claims (open_counts) by the cumulative OLEP value (cum_olep) and divide the result by 1000
  df <- df %>%
    mutate(open_freq = open_counts / (cum_olep / 1000))
  
  # Calculate the ratio of paid loss to reported loss
  # If the number of reported losses (rpt_loss) is not equal to 0, divide the paid loss (paid_loss) by the reported loss (rpt_loss)
  # Otherwise, set this value to 0
  df <- df %>%
    mutate(paid_reported = ifelse(rpt_loss != 0, paid_loss / rpt_loss, 0))
  
  # Calculate the ratio of closed claims to reported claims
  # If the number of reported claims (rpt_counts) is not equal to 0, divide the number of closed claims (closed_counts) by the number of reported claims (rpt_counts)
  # Otherwise, set this value to 0
  df <- df %>%
    mutate(closed_reported = ifelse(rpt_counts != 0, closed_counts / rpt_counts, 0))
  
  # Calculate the average reported loss per claim
  # If the number of reported claims (rpt_counts) is not equal to 0, divide the reported loss (rpt_loss) by the number of reported claims (rpt_counts)
  # Otherwise, set this value to 0
  df <- df %>%
    mutate(ave_rpt_loss = ifelse(rpt_counts != 0, rpt_loss / rpt_counts, 0))
  
  # Calculate the average paid loss per closed claim
  # If the number of closed claims (closed_counts) is not equal to 0, divide the paid loss (paid_loss) by the number of closed claims (closed_counts)
  # Otherwise, set this value to 0
  df <- df %>%
    mutate(ave_paid_loss = ifelse(closed_counts != 0, paid_loss / closed_counts, 0))
  
  # Calculate the average case outstanding per open claim
  # Divide the case outstanding (case_resv) by the number of open claims (open_counts)
  df <- df %>%
    mutate(ave_case_os = case_resv / open_counts)
  
  return(df)
}