# need to source several functions
source("../src/build_csu_all_lines_olep_pt1.R")
source("../src/build_all_lines_csu_data.R")
source("../src/build_model_df.R")
source("../src/add_missing_data.R")
source("../src/update_loss_prem_at_least_one.R")
source("../src/update_counts_at_least_one.R")
source("../src/recalculate_frequency_and_average_loss.R")
source("../src/filter_by_calendar_idx.R")

#' @title Build Model df
#' @description Build the model df
#' @param loss.data.path Loss data path
#' @param year Year
#' @param qtr Quarter
#' @param lob Line of Business
#' @return Model df
#' @export
#' @examples
#' build_model_df(loss.data.path, year, qtr, lob)
all_in_one_model_df <- function(loss.data.path, params){
  # build the all lines olep
  all_lines_olep <- build_csu_all_lines_olep_pt1(loss.data.path, year, qtr)

  # build the all lines df
  all_lines_df <- build_all_lines_csu_data(loss.data.path, params$year, params$qtr)
  
  # column order
  col.ord <- c('lob', 'ay', 'dev_month', 'cum_olep', 'rpt_loss', 'paid_loss', 'case_resv', 'paid_dcce', 'rpt_counts', 'closed_counts', 'open_counts', 'ave_rpt_loss', 'ave_paid_loss', 'ave_case_os')
  
  # build the model df
  modeldf <- build_model_df(loss.data.path, as.character(params$year), as.character(params$qtr), params$lob) %>%
  
    # add missing data
    add_missing_data(min_ay=params$first_ay, n_w=params$n_ay, n_d=max(.$d)) %>%
  
    # update loss and prem so that each cell has at least one
    update_loss_prem_at_least_one(params$year, params$qtr) %>%

    # update counts so that each cell has at least one
    update_counts_at_least_one() %>%

    # recalculate frequency and average loss
    recalculate_frequency_and_average_loss() %>%

    # filter by calendar index
    filter_by_calendar_idx(params$year, params$qtr) %>%
    
    # create new columns that are numeric versions of w and d
    mutate(a=as.numeric(w), b=as.numeric(d)) %>%

    # sort by lob, ay, dev_month
    arrange(lob, b, a) %>%

    # drop the a and b columns
    select(-c(a, b)) %>%

    # filter by lob
    filter(lob==params$lob) %>%

    # select the columns in the correct order
    select(col.ord)
  
  return(modeldf)
}