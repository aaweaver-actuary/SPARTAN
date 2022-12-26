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