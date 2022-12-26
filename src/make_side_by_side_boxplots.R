#' @title Make side-by-side accident period and development period residual boxplots
#' 
#' @description This function creates side-by-side boxplots of standardized residuals for accident period and development period data. The plots are created using the `make_boxplot` function and arranged using the `gridExtra` package.
#' 
#' @param df A data frame of sampled values.
#' @param stan_dat A list with two elements: `w` and `d`, which are vectors of accident and development period indices, respectively.
#' @param actual A vector of actual values with length equal to the number of columns in the data frame.
#' @param N The number of samples to take from the data frame.
#' 
#' @return A single plot with two panels, one for the accident period residuals and one for the development period residuals.
make_side_by_side_boxplots <- function(df, stan_dat, actual, N) {
  library(ggplot2)
  library(gridExtra)
  library(stringr)
  
  # Create the accident period boxplot
  accident_plot <- make_boxplot(df, stan_dat, gp = "accident", actual, N) +
    labs(title = "Accident Period")
  
  # Create the development period boxplot
  development_plot <- make_boxplot(df, stan_dat, gp = "development", actual, N) +
    labs(title = "Development Period")
  
  # Arrange the plots side by side
  grid.arrange(accident_plot, development_plot, ncol = 2, main="Standardized Residuals from " %>% str_c(as.character(N), " sampled parameter sets"))
}
