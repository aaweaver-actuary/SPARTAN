#' @title Boxplots of Stan fit parameters
#' @description This function takes the results of a stanfit object and a string parameter_lookup as inputs and returns a ggplot2 boxplot. It does this by extracting the data frame from the stanfit object, selecting only the columns that start with parameter_lookup, sorting the columns by the number inside the square brackets at the end of the column name, and creating a boxplot for each column in the data frame.
#'
#' @param stanfit A stanfit object containing the results of a Stan fit.
#' @param parameter_lookup A string used to select the columns in the data frame to plot. Only columns that start with this string will be included in the plot.
#' @return A ggplot2 boxplot of the selected columns in the data frame.
#' @examples
#' # Load the rstan package
#' library(rstan)
#'
#' # Run a Stan model and store the results in a stanfit object
#' fit <- stan(model_code, data = model_data)
#'
#' # Plot boxplots of the model parameters with names starting with "beta"
#' plot_parameter_boxplots(fit, "beta")
#' @export
plot_parameter_boxplots <- function(stanfit, parameter_lookup) {
  # Extract the data frame from the stanfit object
  df <- as.data.frame(stanfit)
  # browser()
  
  # Select only the columns that start with the parameter_lookup string
  df <- df %>% select(starts_with(parameter_lookup))
  
  # Sort the columns by the number inside the square brackets at the end of the column name
  df <- df %>% select(order(as.numeric(str_remove_all(names(.), "^.*\\[|\\].*$"))))
  
  # Create a boxplot for each column in the data frame
  t(df) %>% as.data.frame() %>% ggplot() +
    geom_boxplot(aes(x = names(df)))
}