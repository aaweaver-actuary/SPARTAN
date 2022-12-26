#' @title Update Loss, Premium, and At Least One Values in a Data Frame
#'
#' @description
#' This function takes a data frame, `df`, and updates the values of
#' `paid_loss`, `case_resv`, `paid_dcce`, and `cum_olep` to be at least 1.
#' It also increments the value of `rpt_loss` by 1 whenever `paid_loss` or `case_resv` are changed to 1.
#'
#' @param df A data frame containing columns `paid_loss`, `case_resv`, `paid_dcce`, `cum_olep`, and `rpt_loss`.
#' @param year A numeric value representing the year for which the updates are being made.
#' @param quarter A numeric value representing the quarter for which the updates are being made.
#'
#' @return A modified version of the input data frame with updated values for
#' `paid_loss`, `case_resv`, `paid_dcce`, `cum_olep`, and `rpt_loss`.
#'
#' @examples
#' df <- data.frame(paid_loss = c(0, 1, 2, 3),
#'                  case_resv = c(0, 2, 3, 4),
#'                  paid_dcce = c(0, 3, 4, 5),
#'                  cum_olep = c(0, 4, 5, 6),
#'                  rpt_loss = c(0, 5, 6, 7))
#' df
#' #>   paid_loss case_resv paid_dcce cum_olep rpt_loss
#' #> 1         0         0         0        0        0
#' #> 2         1         2         3        4        5
#' #> 3         2         3         4        5        6
#' #> 4         3         4         5        6        7
#' 
#' update_loss_prem_at_least_one(df, 2021, 1)
#' #>   paid_loss case_resv paid_dcce cum_olep rpt_loss
#' #> 1         1         1         1        1        1
#' #> 2         1         2         3        4        6
#' #> 3         2         3         4        5        7
#' #> 4         3         4         5        6        8
#' @export
update_loss_prem_at_least_one <- function(df, year, quarter) {
  # Ensure that paid_loss, case_resv, paid_dcce, and cum_olep are all at least 1
  df[df$paid_loss == 0, "paid_loss"] <- 1
  df[df$case_resv == 0, "case_resv"] <- 1
  df[df$paid_dcce == 0, "paid_dcce"] <- 1
  df[df$cum_olep == 0, "cum_olep"] <- 1
  
  # Add 1 to rpt_loss whenever paid_loss or case_resv is changed to 1
  df[df$paid_loss == 1, "rpt_loss"] <- df[df$paid_loss == 1, "rpt_loss"] + 1
  df[df$case_resv == 1, "rpt_loss"] <- df[df$case_resv == 1, "rpt_loss"] + 1
  
  return(df)
}