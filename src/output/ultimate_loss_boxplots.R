# function that takes a stan model as input and plots boxplots of the estimated ultimate loss by accident period
# by first getting the columns from the stanfit object that correspond to the estimated ultimate loss by accident period
# extracting the integer representing the accident period from the column names, adding params$min_ay to get the actual 
# accident year, and then plotting the boxplots of the estimated ultimate loss by accident year in ggplot2
# where all the boxplots are on the same plot and the accident years are ordered from earliest to latest
# plots all the accident years by default, but can be restricted to a subset of the accident years by specifying
# the accident years to plot in the accident.years argument

ultimate_loss_boxplots <- function(stanfit, params, accident.years = NULL) {
  # get the columns from the stanfit object
  cols <- stanfit$extract(cols = grep("ultimate_loss", names(stanfit$stanfit$extract()), value = TRUE))


  # only include the columns that correspond to the estimated ultimate loss by accident period
  # if accident.years is specified, only include the columns that correspond to the specified accident years
  if (is.null(accident.years)) {
    cols <- cols[, grep("ultimate_loss", names(cols), value = TRUE)]
  } else {
    cols <- cols[, grep(paste0("ultimate_loss_", accident.years), names(cols), value = TRUE)]
  }

  # get the integer representing the accident period from the column names
  accident.periods <- as.integer(gsub("ultimate_loss_", "", names(cols)))
}