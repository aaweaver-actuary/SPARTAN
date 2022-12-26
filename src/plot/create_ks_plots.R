#' @title Create ks.ggplot plots for paid and reported loss
#'
#' @description This function takes a matrix of reported loss estimates, a matrix of paid loss estimates, a vector of actual reported losses, and a vector of actual paid losses as inputs and produces a single ggplot2 plot object that has two ks.ggplot plots side by side, one for paid and one for reported loss, that are very clearly labeled.
#'
#' @param reported_loss_estimates A matrix of reported loss estimates
#' @param paid_loss_estimates A matrix of paid loss estimates
#' @param actual_reported_losses A vector of actual reported losses
#' @param actual_paid_losses A vector of actual paid losses
#' @return A ggplot2 plot object containing two ks.ggplot plots, one for paid loss and one for reported loss
#' @examples
#' create_ks_plots(reported_loss_estimates, paid_loss_estimates, actual_reported_losses, actual_paid_losses)
create_ks_plots <- function(reported_loss_estimates, paid_loss_estimates, actual_reported_losses, actual_paid_losses) {
  # Need the gridExtra package
  library(gridExtra)
  
  # Create a vector of reported loss empirical percentiles using the apply_empirical_percentile function
  reported_loss_percentiles <- apply_empirical_percentile(reported_loss_estimates, actual_reported_losses)
  
  # Create a vector of paid loss empirical percentiles using the apply_empirical_percentile function
  paid_loss_percentiles <- apply_empirical_percentile(paid_loss_estimates, actual_paid_losses)
  
  # Create a plot of the reported loss percentiles using the ks.test.ggplot function
  reported_loss_plot <- ks.test.ggplot(reported_loss_percentiles) +
    ggtitle("Reported Loss Estimates")
  
  # Create a plot of the paid loss percentiles using the ks.test.ggplot function
  paid_loss_plot <- ks.test.ggplot(paid_loss_percentiles) +
    ggtitle("Paid Loss Estimates")
  
  # Use the grid.arrange function from the gridExtra package to create a single plot with the two plots side by side
  plot <- grid.arrange(reported_loss_plot, paid_loss_plot, nrow = 1, main = "Kolmogorov-Smirnov Test")
  
  # Return the plot
  return(plot)
}