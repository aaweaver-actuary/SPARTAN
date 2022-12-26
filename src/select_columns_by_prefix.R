#' @title Select columns in a data frame that start with a given parameter name
#'
#' @description This function takes a data frame `data` and a vector of parameter names
#' `param_names` as input. It finds all columns in `data` that start with any
#' of the parameter names in `param_names`, selects only those columns, and
#' computes the standard deviation, mean, median, and coefficient of variation
#' for each column. It returns a data frame with one row for each selected
#' column, with the first column being the parameter name, the second column
#' being the standard deviation, the third column being the mean, the fourth
#' column being the median, and the fifth column being the coefficient of
#' variation.
#'
#' @param data A data frame.
#' @param param_names A vector of parameter names.
#' @return A data frame with one row for each selected column.
#' @examples
#' # Load the data frame
#' data <- read.csv("data.csv")
#'
#' # Select columns that start with "param" and compute statistics
#' selected_data <- select_columns_by_prefix(data, c("param1", "param2"))
#'
#' # Print the selected data
#' print(selected_data)
select_columns_by_prefix <- function(data, param_names) {
  # Find columns that start with any element of param_names
  cols_to_select <- data %>%
    map(function(col) {
      any(map_lgl(param_names, function(param) {
        grepl(paste0("^", param), col)
      }))
    })
  
  # Select columns and compute statistics
  selected_data <- data[, cols_to_select]
  param_names <- names(selected_data)
  stdevs <- selected_data %>% map(sd)
  means <- selected_data %>% map(mean)
  medians <- selected_data %>% map(median)
  cvs <- stdevs / means
  
  # Return a data frame with one row for each selected column
  tibble(param_name=param_names, stdev=stdevs, mean=means, median=medians, cv=cvs)
}