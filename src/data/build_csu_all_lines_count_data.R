#' @title build_csu_all_lines_count_data
#' @description This function generates a data frame of loss data for all lines of business, with additional columns for counts of open, closed, and reported losses, as well as additional metrics such as average reported loss and average paid loss per closed case.
#' @param loss.data.path character. The file path for the loss data file.
#' @param year numeric. The year for which to generate the data.
#' @param quarter numeric. The quarter for which to generate the data.
#' @return A data frame with loss data for all lines of business, including additional columns for counts of open, closed, and reported losses, as well as additional metrics such as average reported loss and average paid loss per closed case.
#' @export
#' @examples
#' build_csu_all_lines_count_data("loss_data.csv", 2020, 1)
build_csu_all_lines_count_data <- function(loss.data.path, year, quarter) {
  all_lines_df <- build_csu_all_lines_loss_data(loss.data.path, year, quarter) %>%
    # Calculate the number of reported losses in thousands by multiplying the cumulative frequency of reported losses by the cumulative expected losses per occurrence
    mutate(rpt_counts = cum_rpt_freq * cum_olep / 1000) %>%
    # Calculate the number of closed losses in thousands by multiplying the cumulative frequency of closed losses by the cumulative expected losses per occurrence
    mutate(closed_counts = cum_closed_freq * cum_olep / 1000) %>%
    
    # Convert the cum_olep column from thousands of dollars to actual dollars
    mutate(new_olep = cum_olep * 1000) %>% 
    select(-cum_olep) %>% 
    rename(cum_olep = new_olep) %>%
    
    # Calculate the number of open losses by subtracting the number of closed losses from the number of reported losses
    mutate(open_counts = rpt_counts - closed_counts) %>% 
    # If the number of open losses is negative, set the number of reported losses equal to the absolute value of the number of open losses and the number of open losses equal to 0
    mutate(new_rpt = ifelse(open_counts < 0, rpt_counts - open_counts, rpt_counts)) %>%
    mutate(new_open = ifelse(open_counts < 0, 0, open_counts)) %>%
    # Drop the original rpt_counts and open_counts columns and rename the new columns
    select(-c(rpt_counts, open_counts)) %>%
    rename(rpt_counts = new_rpt) %>%
    rename(open_counts = new_open)
  
  return(all_lines_df)
}