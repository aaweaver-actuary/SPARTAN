#' @title Build CSU All Lines OLEP (Pt. 1)
#'
#' @description This function reads in loss data from an Excel sheet and combines it with on-level earned premium (OLEP) data 
#' that has been processed and saved to a file in the fst format. The OLEP data is filtered to only include rows where 
#' the development month is equal to 12, and the cumulative sum of the incremental OLEP by line of business and accident 
#' year is calculated and added as a new column. The function then performs a left join with the OLEP data and the loss data, 
#' creating a new column called `olep` that takes the value of `cum_olep` if it is not `NA`, and `total_olep` otherwise. 
#' The function then drops the `cum_olep` and `total_olep` columns, renames the `olep` column to `cum_olep`, creates a new 
#' column called `idx` that is the sum of 12 times `ay` and `dev_month` and filters the dataframe to only include rows where 
#' `idx` is less than or equal to 12 times `year` plus 3 times `qtr`. The function returns 
#' the modified dataframe.
#'
#' @param loss.data.path A character string specifying the path to the Excel file containing the loss data.
#' @param year A character string specifying the year for which the data should be processed.
#' @param qtr A character string specifying the quarter for which the data should be processed.
#' @return A data frame with the modified loss data and OLEP data.
#' @export
#' @examples
#' build_csu_all_lines_olep_pt1("path/to/loss_data.xlsx", "2022", "1")
build_csu_all_lines_olep_pt1 <- function(loss.data.path, year, qtr) {
  # load tidyverse if it isn't already
  library(tidyverse)
  
  # Use the readxl package to read in the excel sheet named "olep_data"
  all_lines_olep <- read_csu_olep(loss.data.path, year, qtr)
  
  # Read in the loss data from the specified sheet in the Excel file at the specified path
  all_lines_df <- readxl::read_xlsx(loss.data.path, sheet="loss_data") 
  
  # Perform a left join with all_lines_olep, filtered to only include rows where dev_month is equal to 12,
  # and renaming the cum_olep column to total_olep
  all_lines_df <- all_lines_df %>%
    left_join(all_lines_olep %>%
                filter(dev_month==12) %>%
                select(-dev_month) %>%
                rename(total_olep=cum_olep), by=c('LOB', 'ay'))
  
  # Perform another left join with all_lines_olep
  all_lines_df <- all_lines_df %>%
    left_join(all_lines_olep, by=c('LOB', 'ay', 'dev_month'))
  
  # Create a new column called olep that takes the value of cum_olep if it is not NA, and total_olep otherwise
  all_lines_df <- all_lines_df %>%
    mutate(olep=ifelse(!is.na(cum_olep), cum_olep, total_olep))
  
  # Drop the cum_olep and total_olep columns
  all_lines_df <- all_lines_df %>%
    select(-c(cum_olep, total_olep))
  
  # Rename the olep column to cum_olep
  all_lines_df <- all_lines_df %>%
    rename(cum_olep=olep)
  
  # Create a new column called idx that is the sum of 12 times ay and dev_month
  all_lines_df <- all_lines_df %>%
    mutate(idx=12*ay + dev_month)
  
  # Filter the dataframe to only include rows where idx is less than or equal to 12 times year plus 3 times qtr
  all_lines_df <- all_lines_df %>%
    filter(idx <= (12 * as.numeric(year)) + (3 * as.numeric(qtr)))
  
  # Rename the `LOB` column to `lob`
  all_lines_df <- all_lines_df %>%
    rename(lob=LOB)
  
  return(all_lines_df)
}