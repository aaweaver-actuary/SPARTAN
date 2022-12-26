#' @title Get Stan Code
#' @description Get the stan code used to fit the model
#' @param stanfit Stanfit object
#' @return Stan code
#' @export
#' @examples
#' get_stancode(stanfit)
#' #> [1] "data {"
#' #> [2] "  int<lower=0> N;"
#' #> [3] "  int<lower=0> n_w;"
#' #> [4] "  int<lower=0> n_d;"
#' #> [5] "  int<lower=0> n_ay;"
#' #> [6] "  int<lower=0> min_ay;"
#' #> ...
get_stancode <- function(stanfit){
  # get the stan code
  stancode <- stanfit$stanmodel$stan_code()
  
  # remove the blank lines
  stancode <- stancode[!grepl("^$", stancode)]

  # return the stan code
  return(stancode)