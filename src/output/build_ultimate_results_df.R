#' @title Build Ultimate Results data frame
#' @description This function takes a stanfit object, a quantity string, and a stan_dat list as input. It first transforms the samples in the stanfit object into a data frame called samples_df. It then selects only those columns in samples_df that start with the quantity string. Next, it extracts the log_prem and w columns from the stan_dat list and exponentiates log_prem to get the premium value. The function then creates a new data frame called out_df with the w and premium columns. It drops any duplicate values from out_df and sorts it by w from smallest to largest. Finally, the function adds a column to out_df called "Standard Deviation" where the element in the i-th row is the standard deviation of the i-th column in samples_df. Using similar definitions, it calculates a column in out_df called "Mean", one called "25th Percentile", "50th Percentile", "67th Percentile", "75th Percentile", "90th Percentile", "95th Percentile", and "99th Percentile". It returns the resulting out_df data frame.
#' @param stanfit a stanfit object containing the samples to be transformed into a data frame
#' @param quantity a string specifying which columns in samples_df to select
#' @param stan_dat a list containing the log_prem and w columns
#' @return a data frame with the columns w, premium, Standard Deviation, Mean, 25th Percentile, 50th Percentile, 67th Percentile, 75th Percentile, 90th Percentile, 95th Percentile, and 99th Percentile
#' @examples
#' # Example using the stanfit object from the rstan package
#' stan_dat <- list(log_prem = rnorm(10), w = rnorm(10))
#' fit <- stan(model_code = "parameters {real y;} model {y ~ normal(0,1);}", data = stan_dat, iter = 1000, chains = 1)
#' ultimate_results_df <- build_ultimate_results_df(fit, "y", stan_dat)
#' head(ultimate_results_df)
build_ultimate_results_df <- function(stanfit, quantity, stan_dat) {
  # Needs the tidyverse package
  library(tidyverse)
  
  # Transform samples into a samples_df data frame
  samples_df <- as.data.frame(stanfit)
  
  # Select only those columns starting with the passed quantity string
  samples_df <- samples_df %>% 
    select(starts_with(quantity))
  
  # get loss measures from stanfit
  loss_measures <- samples_df %>%
    select(starts_with(c('mean_abs_error', 'mean_squ_error', 'mean_asym_error')))
           
  
  # Get the log_prem and w columns from stan_dat
  log_prem <- stan_dat$log_prem
  w <- stan_dat$w
  
  # Exponentiate log_prem to get premium
  premium <- exp(log_prem)
  
  # Create out_df with w and premium columns
  out_df <- data.frame(w, premium)
  
  # Drop duplicate values from out_df and sort by w (smallest to largest)
  out_df <- out_df %>% 
    distinct(w) %>% 
    arrange(w)
  
  # Add a column to out_df called 'Standard Deviation'
  out_df$Standard_Deviation <- apply(samples_df, 2, sd) %>% round(0)
  
  # Calculate mean, CV, 50th percentile, 75th percentile, 90th percentile, 95th percentile, and 99th percentile
  out_df$Mean <- apply(samples_df, 2, mean) %>% round(0)
  out_df$CV <- apply(samples_df, 2, function(x) sd(x) / mean(x) * 100)  %>% round(1)
  out_df$`50th_Percentile` <- apply(samples_df, 2, quantile, probs = 0.50) %>% round(0)
  out_df$`75th_Percentile` <- apply(samples_df, 2, quantile, probs = 0.75) %>% round(0)
  out_df$`90th_Percentile` <- apply(samples_df, 2, quantile, probs = 0.90) %>% round(0)
  out_df$`95th_Percentile` <- apply(samples_df, 2, quantile, probs = 0.95) %>% round(0)
  out_df$`99th_Percentile` <- apply(samples_df, 2, quantile, probs = 0.99) %>% round(0)
  
  # calculate Min MAE, MSE, MAsymmE
  # out_df$Min_MAE <- apply(samples_df, 2, function(x) samples_df %>% filter()
  
  
  return(out_df)
}