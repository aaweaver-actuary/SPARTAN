#' Divide Columns of a Data Frame by Corresponding Elements in a Vector
#'
#' This function divides each column of a data frame by the corresponding element in a vector.
#'
#' @param df A data frame.
#' @param vec A vector.
#' @return A data frame with each column divided by the corresponding element in the vector.
#' @examples
#' # Test the function with a sample data frame and vector
#' df <- data.frame(a = c(1, 2, 3), b = c(4, 5, 6), c = c(7, 8, 9))
#' vec <- c(10, 20, 30)
#' divide_columns(df, vec)
#'
#' @export
divide_columns <- function(df, vec = exp(stan_dat$log_prem_ay)) {
  library(tidyverse)
  # Use the mutate() function from the dplyr package to apply a function to each column of the data frame
  # The .fns argument specifies the function to apply to each column. In this case, we're using the map2() function from the purrr package
  # The .x argument specifies the first argument to pass to map2(). In this case, it's the vec vector
  # The .y argument specifies the second argument to pass to map2(). In this case, it's the data frame, which is represented by the . symbol
  df %>% mutate(across(.fns = map2, .x = vec, .y = .))
}


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




#' @title Extract Integer in Brackets
#'
#' @description The extract_integer_in_brackets() function is used to extract an integer from a string that is surrounded by brackets. 
#' It takes a single argument, `string`, which is the string from which the integer should be extracted. 
#' The function first uses the `gsub()` function to extract the substring inside the brackets and stores it in the 
#' `substring` variable. It then attempts to convert this `substring` to an integer using the `as.integer()` function 
#' and stores the result in the `result` variable. If the conversion fails, the function returns `NA`. 
#' If the conversion is successful, the function returns the integer value stored in `result`. 
#'
#' @param string A character string from which the integer should be extracted.
#' @return The integer value extracted from the string, or `NA` if the extraction fails.
#' @examples
#' extract_integer_in_brackets("The value is [3]")
#' #> 3
#' extract_integer_in_brackets("The value is [abc]")
#' #> NA
#' @export
extract_integer_in_brackets <- function(string) {
  # Use the gsub() function to extract the substring inside the brackets
  substring <- gsub(".*\\[(.*)\\].*", "\\1", string)
  
  # Try to convert the substring to an integer using as.integer()
  result <- as.integer(substring)
  
  # If the conversion fails (e.g. because the substring is not a valid integer), return NA
  ifelse(is.na(result), NA, result)
}

#' @title Extract Code Blocks
#'
#' @description This function extracts code blocks from a fitted Stan model object.
#'
#' @param fit a fitted Stan model object
#' @return code_blocks_list a list containing the names and code blocks of the Stan model
#' @examples
#' # Fit a Stan model
#' fit <- stan_model(file = "model.stan")
#'
#' # Extract code blocks from the fitted model
#' code_blocks_list <- extract_code_blocks(fit)
#' @export
extract_code_blocks <- function(fit) {
  # Get the Stan model code from the fitted model object
  model_code <- stan_model(fit)$model_code
  
  # Split the model code into a list of code blocks
  code_blocks <- strsplit(model_code, "}")[[1]]
  
  # Extract the names of the code blocks
  block_names <- gsub("^.*\\b(\\w+)\\s*\\{.*$", "\\1", code_blocks)
  
  # Create a list with the names and code blocks
  code_blocks_list <- list()
  for (i in 1:length(block_names)) {
    code_blocks_list[[block_names[i]]] <- code_blocks[i]
  }
  
  return(code_blocks_list)
}


#' @title Calculate cumulative on-level earned premium (olep) by line of business and accident year for CSU
#'
#' @description This function reads in on-level earned premium data from an Excel sheet, calculates the cumulative sum 
#' of the incremental on-level earned premium by line of business and accident year, drops the incremental column, and 
#' returns a modified data frame with the cumulative on-level earned premium by line of business and accident year. 
#' The function also includes a check to see if the data has already been processed and saved to a file in the fst format. 
#' If the data has been processed and saved, the function will read in the data from the saved file instead of processing it again.
#'
#' @param loss.data.path Path to the Excel file containing the on-level earned premium data.
#' @param year A character string specifying the year for which the data should be processed.
#' @param quarter A character string specifying the quarter for which the data should be processed.
#' @return A data frame with the cumulative on-level earned premium by line of business and accident year.
#' @export
#' @examples
#' read_csu_olep("path/to/olep_data.xlsx", "2022", "1")
read_csu_olep <- function(loss.data.path, year, quarter) {
  # load tidyverse if it isn't already
  library(tidyverse)
  
  # Check if the file exists
  file_name <- stringr::str_c("csu_olep_", year, "q", quarter, ".fst")
  if (file.exists(file_name)) {
    # If the file exists, read it in and return it
    return(fst::read_fst(file_name))
  } else {
    # Use the readxl package to read in the excel sheet named "olep_data"
    all_lines_olep <- readxl::read_xlsx(loss.data.path, sheet="olep_data")
    
    # Group the data by line of business (LOB) and accident year (ay)
    all_lines_olep <- all_lines_olep %>%
      group_by(LOB, ay)
    
    # Calculate the cumulative sum of the incremental on-level earned premium (incr_olep)
    # by line of business and accident year and add it as a new column named "cum_olep"
    all_lines_olep <- all_lines_olep %>%
      mutate(cum_olep=cumsum(incr_olep))
    
    # Drop the "incr_olep" column from the data frame
    all_lines_olep <- all_lines_olep %>%
      select(-incr_olep)
    
    # Save the modified data frame to a file
    fst::write_fst(all_lines_olep, file_name)
    
    # Return the modified data frame
    return(all_lines_olep)
  }
}

#' @title Calculate cumulative on-level earned premium (olep) by line of business and accident year for CSU
#'
#' @description This function reads in on-level earned premium data from an Excel sheet, calculates the cumulative sum 
#' of the incremental on-level earned premium by line of business and accident year, drops the incremental column, and 
#' returns a modified data frame with the cumulative on-level earned premium by line of business and accident year. 
#' The function also includes a check to see if the data has already been processed and saved to a file in the fst format. 
#' If the data has been processed and saved, the function will read in the data from the saved file instead of processing it again.
#'
#' @param loss.data.path Path to the Excel file containing the on-level earned premium data.
#' @param year A character string specifying the year for which the data should be processed.
#' @param quarter A character string specifying the quarter for which the data should be processed.
#' @return A data frame with the cumulative on-level earned premium by line of business and accident year.
#' @export
#' @examples
#' read_csu_olep("path/to/olep_data.xlsx", "2022", "1")
read_csu_olep2 <- function(loss.data.path, year, quarter) {
  # load tidyverse if it isn't already
  library(tidyverse)
  
  # Check if the file exists
  file_name <- stringr::str_c("csu_olep_", year, "q", quarter, ".fst")
  if (file.exists(file_name)) {
    # If the file exists, read it in and return it
    return(fst::read_fst(file_name))
  } else {
    # Use the readxl package to read in the excel sheet named "olep_data"
    all_lines_olep <- readxl::read_xlsx(loss.data.path, sheet="olep_data")
    
    # Group the data by line of business (LOB) and accident year (ay)
    all_lines_olep <- all_lines_olep %>%
      group_by(LOB, ay)
    
    # Calculate the cumulative sum of the incremental on-level earned premium (incr_olep)
    # by line of business and accident year and add it as a new column named "cum_olep"
    all_lines_olep <- all_lines_olep %>%
      mutate(cum_olep=cumsum(incr_olep))
    
    # Drop the "incr_olep" column from the data frame
    all_lines_olep <- all_lines_olep %>%
      select(-incr_olep)
    
    # Save the modified data frame to a file
    fst::write_fst(all_lines_olep, file_name)
    
    # Return the modified data frame
    return(all_lines_olep)
  }
}

#' @title Build CSU All Lines OLEP (Pt. 1)
#'
#' @description This function reads in loss data from an Excel sheet and combines it with on-level earned premium (OLEP) data 
#' that has been processed and saved to a file in the fst format. The OLEP data is filtered to only include rows where 
#' the development month is equal to 12, and the cumulative sum of the incremental OLEP by line of business and accident 
#' year is calculated and added as a new column. The function then performs a left join with the OLEP data and the loss data, 
#' creating a new column called `olep` that takes the value of `cum_olep` if it is not `NA`, and `total_olep` otherwise. 
#' The function then drops the `cum_olep` and `total_olep` columns, renames the `olep` column to `cum_olep`, creates a new 
#' column called `idx` that is the sum of 12 times `ay` and `dev_month` and filters the dataframe to only include rows where 
#' `idx` is less than or equal to 12 times `year` plus 3 times `qtr`. The function returns 
#' the modified dataframe.
#'
#' @param loss.data.path A character string specifying the path to the Excel file containing the loss data.
#' @param year A character string specifying the year for which the data should be processed.
#' @param qtr A character string specifying the quarter for which the data should be processed.
#' @return A data frame with the modified loss data and OLEP data.
#' @export
#' @examples
#' build_csu_all_lines_olep_pt1("path/to/loss_data.xlsx", "2022", "1")
build_csu_all_lines_olep_pt1 <- function(loss.data.path, year, qtr) {
  # load tidyverse if it isn't already
  library(tidyverse)
  
  # Use the readxl package to read in the excel sheet named "olep_data"
  all_lines_olep <- read_csu_olep(loss.data.path, year, qtr)
  
  # Read in the loss data from the specified sheet in the Excel file at the specified path
  all_lines_df <- readxl::read_xlsx(loss.data.path, sheet="loss_data") 
  
  # Perform a left join with all_lines_olep, filtered to only include rows where dev_month is equal to 12,
  # and renaming the cum_olep column to total_olep
  all_lines_df <- all_lines_df %>%
    left_join(all_lines_olep %>%
                filter(dev_month==12) %>%
                select(-dev_month) %>%
                rename(total_olep=cum_olep), by=c('LOB', 'ay'))
  
  # Perform another left join with all_lines_olep
  all_lines_df <- all_lines_df %>%
    left_join(all_lines_olep, by=c('LOB', 'ay', 'dev_month'))
  
  # Create a new column called olep that takes the value of cum_olep if it is not NA, and total_olep otherwise
  all_lines_df <- all_lines_df %>%
    mutate(olep=ifelse(!is.na(cum_olep), cum_olep, total_olep))
  
  # Drop the cum_olep and total_olep columns
  all_lines_df <- all_lines_df %>%
    select(-c(cum_olep, total_olep))
  
  # Rename the olep column to cum_olep
  all_lines_df <- all_lines_df %>%
    rename(cum_olep=olep)
  
  # Create a new column called idx that is the sum of 12 times ay and dev_month
  all_lines_df <- all_lines_df %>%
    mutate(idx=12*ay + dev_month)
  
  # Filter the dataframe to only include rows where idx is less than or equal to 12 times year plus 3 times qtr
  all_lines_df <- all_lines_df %>%
    filter(idx <= (12 * as.numeric(year)) + (3 * as.numeric(qtr)))
  
  # Rename the `LOB` column to `lob`
  all_lines_df <- all_lines_df %>%
    rename(lob=LOB)
  
  return(all_lines_df)
}

#' @title Build CSU All Lines Loss Data
#'
#' @description This function takes in a loss data path, year, and quarter as input and returns a data frame containing 
#' all lines loss data for the specified year and quarter. The data frame includes columns for cumulative report loss cost, 
#' cumulative paid loss cost, cumulative paid DCCE cost, and cumulative OLEP. It also includes columns for calculated values 
#' for report loss, paid loss, case reserve, and new case and paid DCCE values that are adjusted for cases where the 
#' original values are zero.
#'
#' @param loss.data.path A character string specifying the file path to the loss data file.
#' @param year A character string or integer specifying the year for which to retrieve data.
#' @param qtr A character string or integer specifying the quarter for which to retrieve data.
#'
#' @return A data frame containing all lines loss data for the specified year and quarter.
#'
#' @examples
#' build_csu_all_lines_loss_data("path/to/loss/data/file.csv", "2020", "Q1")
build_csu_all_lines_loss_data <- function(loss.data.path, year, qtr) {
  # Load tidyverse if it isn't already
  library(tidyverse)
  
  all_lines_df <- build_csu_all_lines_olep_pt1(loss.data.path, year, qtr) %>%
    # reported loss
    mutate(rpt_loss = cum_rpt_loss_cost * cum_olep) %>%
    
    # paid loss
    mutate(paid_loss = cum_paid_loss_cost * cum_olep) %>%
    
    # case reserves
    mutate(case_resv = rpt_loss - paid_loss) %>%
    
    # paid dcce
    mutate(paid_dcce = cum_paid_dcce_cost * cum_olep) %>%
    
    # put $1 in any cell with $0 cumulative, and remove that from case reserve
    mutate(new_paid_loss=ifelse(paid_loss==0, 1, paid_loss)) %>%
    mutate(new_case=ifelse(paid_loss==0, case_resv - 1, case_resv)) %>%
    mutate(new_paid_dcce=ifelse(paid_dcce==0, 1, paid_dcce)) %>%
    mutate(new_case2=ifelse(paid_dcce==0, new_case - 1, new_case)) %>%
    select(-c(paid_loss, paid_dcce, case_resv, new_case)) %>%
    rename(paid_loss=new_paid_loss) %>%
    rename(paid_dcce=new_paid_dcce) %>%
    rename(case_resv=new_case2)
  
  return(all_lines_df)
}























































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
