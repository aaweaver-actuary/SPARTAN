#' @title Create a ggplot2 Boxplot of Standardized Residuals
#'
#' @description This function creates a ggplot2 boxplot of standardized residuals,
#' which are a measure of the difference between observed and expected values,
#' normalized by the standard deviation of the observed values. The standardized residuals are
#' grouped by accident period, development period, or calendar period,
#' depending on the value of the gp parameter.
#'
#' @param df A data frame of sampled values. The data frame should have columns for
#' the observed values and the corresponding accident or development period indices.
#' @param stan_dat A list with two elements: w and d, which are vectors of accident and
#' development period indices, respectively. These indices are used to group the standardized residuals
#' by accident or development period.
#' @param gp A character string specifying how the residuals should be grouped.
#' Possible values are "accident", "development", or "calendar". The default value is "accident".
#' @param actual A vector of actual values with length equal to the number of columns in the
#' data frame. These values are used to calculate the standardized residuals.
#' @param N The number of samples to take from the data frame.
#' The default value is 250.
#'
#' @return A ggplot object containing the boxplot of standardized residuals.
#' The x-axis of the plot shows the groups (accident period, development period,
#' or calendar period), and the y-axis shows the standardized residual values.
#' The plot includes a title and boxplots for each group.
#'
#' @examples
#' # create a sample data frame
#' df <- data.frame(
#' accident_1 = rnorm(10, mean = 100, sd = 20),
#' accident_2 = rnorm(10, mean = 120, sd = 30),
#' accident_3 = rnorm(10, mean = 90, sd = 10),
#' development_1 = rnorm(10, mean = 80, sd = 15),
#' development_2 = rnorm(10, mean = 110, sd = 25),
#' development_3 = rnorm(10, mean = 95, sd = 20)
#' )
#'
#' # create a list of accident and development indices
#' stan_dat <- list(w = c(1, 2, 3), d = c(1, 2, 3))
#'
#' # create a vector of actual values
#' actual <- c(100, 120, 90, 80, 110, 95)
#'
#' # create a boxplot of standardized residuals, grouped by accident period
#' p <- make_boxplot(df, stan_dat, actual, gp = "accident")
#'
#' # display the boxplot
#' p
make_residual_boxplot <- function(df, stan_dat, actual, quantity="est_cum_rpt_loss", N=250, gp="accident") {
  library(ggplot2)
  library(tidyverse)
  # browser()
  # print(df %>% head)
  
  # Transpose the data frame to join the groups
  df <- transpose_df(df, quantity)
  
  # print(df %>% head)
  
  # Take a random sample of N rows from the data frame
  sample_df <- df[sample(nrow(df)),]
  
  # Create a column of group names based on the value of the `gp` input
  sample_df <- sample_df %>%
    mutate(groups = case_when(
      gp == "accident" ~ paste0("accident_", stan_dat$w),
      gp == "development" ~ paste0("development_", stan_dat$d),
      TRUE ~ "calendar"
    ))
  
  ## fill in code here to pivot_longer, leaving groups as the only remaining lookup column and putting everything else in a single `value` column
  sample_df <- sample_df %>% pivot_longer(cols = -groups, names_to = "Year", values_to = "value")
  
  # Calculate the standardized residuals for each row in the sample data frame
  sample_df <- sample_df %>%
    mutate(stan_resid = (value - actual)/sd(value))
  
  # Convert the sample data frame to a long format data frame for ggplot
  long_df <- sample_df %>%
    gather(key = "Year", value = "Standardized_Residual", -groups)
  
  # Create the ggplot object
  p <- ggplot(long_df, aes(x = groups, y = Standardized_Residual)) +
    geom_boxplot() +
    labs(title = "Standardized Residuals by Group")
  
  # Return the ggplot object
  return(p)
}