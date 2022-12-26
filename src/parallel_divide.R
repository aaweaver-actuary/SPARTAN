#' Applies a function to each column of a data frame in parallel
#'
#' This function uses the mclapply() function from the parallel package to apply a specified function to each column of a data frame in parallel. The number of cores to use for parallel processing can also be specified.
#'
#' @param df A data frame.
#' @param vector A numeric vector with length equal to the number of columns in df.
#' @param fun The function to apply to each column of df. Default is divide_columns.
#' @param mc.cores The number of cores to use for parallel processing. Default is the number of cores detected on the current machine.
#' @return A list of the results of applying the function to each column of df.
#' @examples
#' df <- data.frame(x=1:10, y=11:20, z=21:30)
#' parallel_divide(df, vector=c(2, 3, 4))
#' parallel_divide(df, vector=c(2, 3, 4), fun=mean)
#' parallel_divide(df, vector=c(2, 3, 4), mc.cores=4)
#'
parallel_divide <- function(df, vector, mc.cores=parallel::detectCores()){
  # df: a data frame
  # vector: a numeric vector with length equal to the number of columns in df
  # mc.cores: the number of cores to use for parallel processing. Default is the number of cores detected on the current machine.
  
  # Define the divide_columns() function
  divide_columns <- function(x) x / vector
  
  # Use the parLapply() function from the parallel package to apply the divide_columns() function in parallel
  # parLapply() is a parallel version of lapply() that uses the snow package to perform the parallelization
  # In this case, the function will be applied to each column of df, which will be treated as a list of columns
  result <- parallel::parLapply(cl=parallel::makeCluster(mc.cores), df, divide_columns)
  
  # Return the list of results
  return(result)
}