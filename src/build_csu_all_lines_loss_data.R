#' @title Build CSU All Lines Loss Data
#'
#' @description This function takes in a loss data path, year, and quarter as input and returns a data frame containing 
#' all lines loss data for the specified year and quarter. The data frame includes columns for cumulative report loss cost, 
#' cumulative paid loss cost, cumulative paid DCCE cost, and cumulative OLEP. It also includes columns for calculated values 
#' for report loss, paid loss, case reserve, and new case and paid DCCE values that are adjusted for cases where the 
#' original values are zero.
#'
#' @param loss.data.path A character string specifying the file path to the loss data file.
#' @param year A character string or integer specifying the year for which to retrieve data.
#' @param qtr A character string or integer specifying the quarter for which to retrieve data.
#'
#' @return A data frame containing all lines loss data for the specified year and quarter.
#'
#' @examples
#' build_csu_all_lines_loss_data("path/to/loss/data/file.csv", "2020", "Q1")
build_csu_all_lines_loss_data <- function(loss.data.path, year, qtr) {
  # Load tidyverse if it isn't already
  library(tidyverse)
  
  all_lines_df <- build_csu_all_lines_olep_pt1(loss.data.path, year, qtr) %>%
    # reported loss
    mutate(rpt_loss = cum_rpt_loss_cost * cum_olep) %>%
    
    # paid loss
    mutate(paid_loss = cum_paid_loss_cost * cum_olep) %>%
    
    # case reserves
    mutate(case_resv = rpt_loss - paid_loss) %>%
    
    # paid dcce
    mutate(paid_dcce = cum_paid_dcce_cost * cum_olep) %>%
    
    # put $1 in any cell with $0 cumulative, and remove that from case reserve
    mutate(new_paid_loss=ifelse(paid_loss==0, 1, paid_loss)) %>%
    mutate(new_case=ifelse(paid_loss==0, case_resv - 1, case_resv)) %>%
    mutate(new_paid_dcce=ifelse(paid_dcce==0, 1, paid_dcce)) %>%
    mutate(new_case2=ifelse(paid_dcce==0, new_case - 1, new_case)) %>%
    select(-c(paid_loss, paid_dcce, case_resv, new_case)) %>%
    rename(paid_loss=new_paid_loss) %>%
    rename(paid_dcce=new_paid_dcce) %>%
    rename(case_resv=new_case2)
  
  return(all_lines_df)
}