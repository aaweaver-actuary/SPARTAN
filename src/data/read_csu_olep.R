#' @title Calculate cumulative on-level earned premium (olep) by line of business and accident year for CSU
#'
#' @description This function reads in on-level earned premium data from an Excel sheet, calculates the cumulative sum 
#' of the incremental on-level earned premium by line of business and accident year, drops the incremental column, and 
#' returns a modified data frame with the cumulative on-level earned premium by line of business and accident year. 
#' The function also includes a check to see if the data has already been processed and saved to a file in the fst format. 
#' If the data has been processed and saved, the function will read in the data from the saved file instead of processing it again.
#'
#' @param loss.data.path Path to the Excel file containing the on-level earned premium data.
#' @param year A character string specifying the year for which the data should be processed.
#' @param quarter A character string specifying the quarter for which the data should be processed.
#' @return A data frame with the cumulative on-level earned premium by line of business and accident year.
#' @export
#' @examples
#' read_csu_olep("path/to/olep_data.xlsx", "2022", "1")
read_csu_olep <- function(loss.data.path, year, quarter) {
  # load tidyverse if it isn't already
  library(tidyverse)
  
  # Check if the file exists
  file_name <- stringr::str_c("csu_olep_", year, "q", quarter, ".fst")
  if (file.exists(file_name)) {
    # If the file exists, read it in and return it
    return(fst::read_fst(file_name))
  } else {
    # Use the readxl package to read in the excel sheet named "olep_data"
    all_lines_olep <- readxl::read_xlsx(loss.data.path, sheet="olep_data")
    
    # Group the data by line of business (LOB) and accident year (ay)
    all_lines_olep <- all_lines_olep %>%
      group_by(LOB, ay)
    
    # Calculate the cumulative sum of the incremental on-level earned premium (incr_olep)
    # by line of business and accident year and add it as a new column named "cum_olep"
    all_lines_olep <- all_lines_olep %>%
      mutate(cum_olep=cumsum(incr_olep))
    
    # Drop the "incr_olep" column from the data frame
    all_lines_olep <- all_lines_olep %>%
      select(-incr_olep)
    
    # Save the modified data frame to a file
    fst::write_fst(all_lines_olep, file_name)
    
    # Return the modified data frame
    return(all_lines_olep)
  }
}