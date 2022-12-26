#' @title Output cumulative loss data
#'
#' @description Processes a data frame and outputs a table of cumulative loss data, either as a table or as a data frame.
#'
#' @param df A data frame containing loss data. It should include the following columns:
#'   - 'lob': the type of line of business
#'   - 'ay': the accident year
#'   - 'dev_month': the development month
#'   - 'type_of_loss': the type of loss being measured (e.g. 'paid_loss', 'incurred_loss')
#' @param type_of_loss The name of the column in 'df' that contains the type of loss being measured.
#' @param divide_by An optional argument to divide the values in the 'type_of_loss' column by. Default is 1000.
#' @param round_digits An optional argument specifying the number of decimal points to round to. Default is 0.
#' @param returndf An optional logical argument specifying whether to return the processed data frame (TRUE) or a table (FALSE). Default is FALSE.
#' @return If 'returndf' is TRUE, a data frame with the processed data is returned. If 'returndf' is FALSE, a table of the processed data is returned.
#' @examples
#' output_cumulative(loss_data, 'paid_loss', divide_by=100000, round_digits=2)
#' output_cumulative(loss_data, 'incurred_loss', returndf=TRUE)
#' output_cumulative(loss_data, 'paid_loss', divide_by=1000, round_digits=0)
#'
#' @export
output_cumulative <- function(df, type_of_loss, divide_by=1000, round_digits=0, returndf=FALSE){
  # Subset the data frame to only include the 'lob', 'ay', 'dev_month' columns, 
  # as well as the 'type_of_loss' column specified in the function argument
  outdf <- df[, c('lob', 'ay', 'dev_month') %>% append(type_of_loss)] %>%
    # Join this subsetted data frame with the 'cur_year' data frame, keeping only 
    # the rows where 'ay' and 'dev_month' match
    left_join(cur_year %>% select(ay, dev_month)) %>%
    # Group the resulting data frame by 'lob' and 'ay'
    group_by(lob, ay) %>% 
    # Keep only the rows where 'dev_month' is the maximum value within each group
    filter(dev_month==max(dev_month)) %>% 
    # Remove the grouping
    ungroup()
  
  # If the 'returndf' argument is TRUE, return the modified data frame
  if(returndf){
    return(outdf)
  }
  # If 'returndf' is FALSE, modify and format the data frame for output as a table
  else{
    # Convert the 'ay' column to a factor
    outdf$ay <- outdf$ay %>% as.factor()
    # Remove spaces from the 'lob' column
    outdf$lob <- outdf$lob %>% str_remove(" ")
    
    # Divide the values in the specified 'type_of_loss' column by the 'divide_by' argument
    outdf[, type_of_loss] <- outdf[, type_of_loss]/divide_by
    
    # Rename the columns of the data frame
    names(outdf) <- c('LOB', "AY", 'Dev. Month') %>% 
      # Append a modified version of the 'type_of_loss' column name as the final column
      append("Cumulative " %>% str_c(str_replace(type_of_loss, "_", " ") %>% str_to_title()))
    
    # Set the 'knitr.kable.NA' option to an empty string
    options(knitr.kable.NA='')
    # Use the 'kable' function to format the data frame as a table, with commas as the 
    # thousand separator, the number of decimal points specified by 'round_digits', and 
    # scientific notation disabled
    return(outdf %>% kable(format.args = list(big.mark=",", digits=round_digits, scientific=F)))
  }
}