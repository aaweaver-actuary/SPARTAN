#' @title Create a ggplot2 plot of a Kolmogorov-Smirnov test
#'
#' @description This function uses the ks.test() function to perform a Kolmogorov-Smirnov test on the input data, x. The function then uses ggplot2 to create a plot of the empirical cumulative distribution function (CDF) against the theoretical CDF.
#'
#' @param x A numeric vector of data to be tested.
#' @return A ggplot2 plot object.
#' @examples
#' x <- rnorm(1000)
#' ks.test.ggplot(x)
ks.test.ggplot <- function(x) {
  # Use the built-in ks.test() function to do the Kolmogorov-Smirnov test
  test.result <- ks.test(x, "punif")
  
  # Use ggplot2 to create a plot of the empirical CDF against the theoretical CDF
  ggplot(data=data.frame(x=test.result$ecdf$x, y=test.result$ecdf$y),
         aes(x=x, y=y)) +
    # Add a line for the theoretical CDF
    geom_line(color="blue", size=1) +

    # Add a line for the empirical CDF
    geom_line(data=data.frame(x=test.result$reference$x, y=test.result$reference$y),
              aes(x=x, y=y), color="red", size=1)
}