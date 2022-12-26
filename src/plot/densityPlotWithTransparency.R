#' @title Density plot with transparent shading
#'
#' @description This function creates a density plot with transparent shading.
#'
#' @param colNames A vector of column names to create the density plot for. For example: c("height", "weight").
#' @param currData A data frame containing the current data. For example: data.frame(height=c(5.5, 6.5, 7.5), weight=c(150, 160, 170)).
#' @param priorData A data frame containing the prior data. For example: data.frame(height=c(5.0, 6.0, 7.0), weight=c(140, 145, 155)).
#' @param alpha A numeric value specifying the transparency of the shading. For example: 0.4.
#' @param currColor The color of the shading for the current data. For example: "red".
#' @param priorColor The color of the shading for the prior data. For example: "blue".
#'
#' @return A ggplot object containing the density plot with transparent shading.
#' @examples
#' # Create some data frames
#' currData <- data.frame(height=c(5.5, 6.5, 7.5), weight=c(150, 160, 170))
#' priorData <- data.frame(height=c(5.0, 6.0, 7.0), weight=c(140, 145, 155))
#'
#' # Create the density plot with transparent shading
#' densityPlotWithTransparency(c("height", "weight"), currData, priorData)
densityPlotWithTransparency <- function(colNames, currData, priorData, alpha=0.4, currColor ="red", priorColor="blue") {
  # Create an empty plot
  p <- ggplot()
  
  # Loop over the column names
  for (colName in colNames) {
    # Add a layer to the plot for the current data
    p <- p + geom_density(data = currData, aes(x = colName), fill = currColor, alpha = alpha)
    
    # Add a layer to the plot for the prior data
    p <- p + geom_density(data = priorData, aes(x = colName), fill = priorColor, alpha = alpha)
  }
  
  # If there are multiple column names, use facet_wrap to create separate plots
  if (length(colNames) > 1) {
    p <- p + facet_wrap(~ colName)
  }
  
  # Return the plot
  return(p)
}