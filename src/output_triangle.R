#' @title Generate a Triangle Table
#' @description This function takes a data frame of loss data and generates a triangle table for a specified type of loss. 
#' The development months of the loss data can be displayed in a specified order, and the loss data can be normalized 
#' by dividing by a specified value and rounded to a specified number of digits.
#' Generate a triangle table for a given type of loss data.
#'
#' @param df A data frame containing the loss data. The data frame should include columns for 
#' 'lob' (line of business), 
#' 'ay' (accident year), 
#' 'dev_month' (development month), and 
#' the type of loss specified by the 'type_of_loss' input.
#' @param type_of_loss A string column name representing the type of loss to be processed.
#' @param dm_ord A character vector representing the order in which the development months should be displayed.
#' @param divide_by An optional numeric value representing the divisor to be used when normalizing the loss data. 
#' The default value is 1000.
#' @param round_digits An optional integer value representing the number of digits to round the normalized loss data to. 
#' The default value is 0.
#' @return A formatted table of the processed loss data.
#' @export
#'
#' @examples
#' # Create a sample data frame
#' df <- data.frame(lob=c("Auto", "Auto", "Homeowners"),
#'                 ay=c(2010, 2011, 2010),
#'                 dev_month=c("DM-1", "DM-1", "DM-1", "DM-2", "DM-2", "DM-2"),
#'                 loss=c(100, 200, 300, 400, 500, 600))
#' 
#' # Generate a triangle table for the 'loss' data, with development months displayed in the order "DM-2", "DM-1"
#' output_triangle(df, "loss", c("DM-2", "DM-1"))
#' 
#' # Generate a triangle table for the 'loss' data, with development months displayed in the order "DM-1", "DM-2", and 
#' normalized by dividing by 1000
#' output_triangle(df, "loss", c("DM-1", "DM-2"), divide_by=1000)
#' 
#' # Generate a triangle table for the 'loss' data, with development months displayed in the order "DM-1", "DM-2", normalized 
#' by dividing by 1000, and rounded to 1 decimal digit
#' output_triangle(df, "loss", c("DM-1", "DM-2"), divide_by=1000, round_digits=1)
output_triangle <- function(df, type_of_loss, dm_ord, divide_by=1000, round_digits=0){
  # The input 'df' is a data frame containing the data to be processed.
  # The input 'type_of_loss' is a string column name representing the type of loss to be processed.
  # The input 'dm_ord' is a character vector representing the order in which the development months should be displayed.
  # The input 'divide_by' is an optional numeric value representing the divisor to be used when normalizing the loss data. The default value is 1000.
  # The input 'round_digits' is an optional integer value representing the number of digits to round the normalized loss data to. The default value is 0.
  
  # Subset the input data frame to keep only the columns 'lob', 'ay', 'dev_month', and 'type_of_loss'.
  # Then pivot the data frame to wide format, using 'lob', 'ay' as id columns, 'dev_month' as the names from column, and 'type_of_loss' as the values from column.
  # Finally, keep only the columns 'lob', 'ay', and the development month columns specified in 'dm_ord'.
  df <- (df[, c('lob', 'ay', 'dev_month') %>% append(type_of_loss)] %>% 
           pivot_wider(id_cols=c('lob', 'ay'), 
                       names_from='dev_month', 
                       values_from=type_of_loss))[append(c('lob', 'ay'), dm_ord)]
  
  # Convert the 'ay' column to a factor.
  df$ay <- df$ay %>% as.factor()
  
  # Remove any spaces from the 'lob' column.
  df$lob <- df$lob %>% str_remove(" ")
  
  # Normalize the development month columns specified in 'dm_ord' by dividing them by the value of 'divide_by'.
  for(c in dm_ord){
    df[,c] <- df[,c]/divide_by
  }
  
  # Sort by AY
  df <- df %>% arrange(ay)
  
  # Set the option to display empty cells as an empty string in the resulting table.
  options(knitr.kable.NA='')
  
  # Return the processed data frame as a formatted table.
  return(df %>% kable(format.args = list(big.mark=",", digits=round_digits, scientific=F)))
}