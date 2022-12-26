#' Build All Lines CSU Data
#'
#' Builds a data frame with modified columns, using the provided loss data path, year, and quarter.
#'
#' @param loss.data.path A character string representing the path to the loss data.
#' @param year A character string representing the year of the data.
#' @param quarter A character string representing the quarter of the data.
#'
#' @return A data frame with the modified columns.
#' @export
#'
#' @examples
#' build_all_lines_csu_data("path/to/loss/data", "2022", "2")
#'
#' @importFrom dplyr mutate
#'
build_all_lines_csu_data <- function(loss.data.path, year, quarter) {
  # Use the provided loss data path, year, and quarter to build the data frame
  all_lines_df <- build_csu_all_lines_count_data(loss.data.path, year, quarter)
  
  # Use the dplyr package's mutate function to add the following columns to the data frame:
  all_lines_df <- all_lines_df %>%
    mutate(paid_reported = ifelse(rpt_loss != 0, paid_loss / rpt_loss, 0)) %>%
    mutate(closed_reported = ifelse(rpt_counts != 0, closed_counts / rpt_counts, 0)) %>%
    mutate(ave_rpt_loss = ifelse(rpt_counts != 0, rpt_loss / rpt_counts, 0)) %>%
    mutate(ave_paid_loss = ifelse(closed_counts != 0, paid_loss / closed_counts, 0)) %>%
    mutate(ave_case_os = case_resv / open_counts)
  
  # Return the modified data frame
  return(all_lines_df)
}