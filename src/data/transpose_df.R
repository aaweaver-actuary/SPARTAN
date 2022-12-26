#' @title Transpose a data frame with column names of the form `quantity`.`i` or `quantity`[`i`]
#'
#' @description This function takes a data frame `df` and a string `quantity` as input, and returns a data frame that has been transposed so that the first column is the `i` extracted from the original input `df` column name, and the rest of the columns in the output are the rows from the original input `df`. The column names in the input data frame are expected to have either the form `quantity`.`i` or `quantity`[`i`], where `quantity` is the input string and `i` is an integer.
#' 
#' @param df A data frame.
#' @param quantity A string specifying which columns to transpose in the input data frame.
#' @return A transposed data frame with the `i` values extracted from the original column names as the first column.
#' @export
#'
#' @examples
#' # Create an example data frame
#' df <- data.frame(quantity.1 = c(1, 2, 3),
#'                  quantity.2 = c(4, 5, 6),
#'                  quantity.3 = c(7, 8, 9))
#' 
#' # Print the data frame
#' df
#' #>   quantity.1 quantity.2 quantity.3
#' #> 1          1          4          7
#' #> 2          2          5          8
#' #> 3          3          6          9
#' 
#' # Transpose the data frame
#' transposed_df <- transpose_df(df, "quantity")
#' 
#' # Print the transposed data frame
#' transposed_df
#' #>   i X1 X2 X3
#' #> 1 1  1  4  7
#' #> 2 2  2  5  8
#' #> 3 3  3  6  9
transpose_df <- function(df, quantity) {
  library(stringr)
  # Extract the column names from the input data frame that match the specified quantity
  col_names <- grep(paste0("^", quantity, "(\\.|\\[)"), names(df), value = TRUE)
  # print('col_names:\n')
  # print(col_names)
  
  # Extract the integer values from the column names
  i_values <- as.integer(gsub(paste0("^", quantity, "(\\.|\\[)"), "", col_names) %>% sapply(function(x){x %>% str_replace("]", "")}))
  # print('i_values:\n')
  # print(i_values)
  
  # nrows
  row_names <- row.names(df)
  
  # Transpose the data frame
  transposed_df <- t(df[col_names])
  
  # rename columns
  names(transposed_df) <- sapply(row_names, function(x){"obs_" %>% str_c(as.character(x))})
  
  # Add the integer values as the first column of the transposed data frame
  transposed_df <- cbind(i_values, transposed_df) %>% 
    as.data.frame()
  
  # Set the column names of the transposed data frame to the integer values
  # colnames(transposed_df) <- c("i", 1:ncol(transposed_df)[-1])
  
  # Return the transposed data frame
  return(transposed_df)
}