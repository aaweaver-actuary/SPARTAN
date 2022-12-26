#' @title Extract tuples from a data frame
#'
#' @description This function takes a data frame and a vector of column names as inputs, and returns a list with a tuple of each 
#' unique row as each element, where each tuple contains the values of the columns specified in the `col_names` 
#' vector. The function first selects only the columns of interest, removes duplicate rows, and then iterates over 
#' the unique rows to create the tuples.
#'
#' @param df A data frame.
#' @param col_names A vector of column names to extract from the data frame.
#' @return A list with a tuple of each unique row as each element.
#' @examples
#' df <- data.frame(col1 = c(1, 2, 2, 3, 3, 3), col2 = c(4, 5, 5, 6, 6, 6))
#' table_gp_tuples(df, c("col1", "col2"))
#' #> [[1]]
#' #>   col1 col2
#' #> 1    1    4
#' #>
#' #> [[2]]
#' #>   col1 col2
#' #> 1    2    5
#' #>
#' #> [[3]]
#' #>   col1 col2
#' #> 1    3    6 
#' @export
table_gp_tuples <- function(df, col_names) {
  # Select only the columns of interest, remove duplicate rows, and store the resulting data frame in a new variable
  df_unique <- df %>%
    select(col_names) %>%
    distinct()
  # browser()
  # Create an empty list to store the tuples
  tuple_list <- ct()

  for(i in 1:dim(df_unique)[1]){
    tuple_list[[i]] <- df_unique[i,]
  }
  # for  
  # # Iterate over the rows of the data frame using the map_dfr function
  # df_unique %>%
  #   map_dfr(~ .x[col_names]) %>%
  #   as.list() -> tuple_list
  
  # Return the list with the tuples
  return(tuple_list)
}