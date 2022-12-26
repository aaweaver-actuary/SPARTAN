// recreates the `update_loss_prem_at_least_one` function from the "mcmc_funcs.R" file to be used with `Rcpp`

//' @title Update Loss and Premium at Least One
//' @description Updates the loss and premium to be at least one
//' @param df A data frame
//' @param all_lines_olep A data frame
//' @param year An integer
//' @param first_ay An integer
//' @param params A list
//' @return A data frame
//' @export

// [[Rcpp::depends(Rcpp)]]
#include <Rcpp.h>

// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::depends(RcppParallel)]]
#include <RcppParallel.h>

// then sets the function
// first define a helper function that takes a data frame and column name and returns a vector where
// values are changed to 1 if the value in the column is 0 and unchanged otherwise
Rcpp::NumericVector update_0_to_1(Rcpp::DataFrame df, std::string col_name)
  {
  // initialize the output vector
  Rcpp::NumericVector out;

  // get the column from the data frame
  Rcpp::NumericVector col = df[col_name];

  // loop through the column
  for (int i = 0; i < col.size(); i++)
    {
    // if the value is 0, set it to 1
    if (col[i] == 0)
      {
      out.push_back(1);
      }
    // otherwise, set it to the original value
    else
      {
      out.push_back(col[i]);
      }
    }

  return out;
  }

// this function updates the loss and premium to be at least one
// [[Rcpp::export]]
Rcpp::DataFrame update_loss_prem_at_least_one(
  Rcpp::DataFrame df, Rcpp::DataFrame all_lines_olep, int year, int first_ay, Rcpp::List params)
  {
  // initialize the output data frame
  Rcpp::DataFrame out;

  // set the output data frame to the input data frame
  out = df;

  // replace values in out input where 'paid_loss' equals 0 with 1
  out["paid_loss"] = update_0_to_1(out, "paid_loss");

  // vector of boolean values indicating whether or not a row had paid loss changed to 1
  Rcpp::LogicalVector paid_loss_changed = (out["paid_loss"] != df["paid_loss"]);

  // do the same for 'case_resv'
  out["case_resv"] = update_0_to_1(out, "case_resv");

  // vector of boolean values indicating whether or not a row had case resv changed to 1
  Rcpp::LogicalVector case_resv_changed = (out["case_resv"] != df["case_resv"]);

  // do the same for 'paid_dcce'
  out["paid_dcce"] = update_0_to_1(out, "paid_dcce");

  // vector of boolean values indicating whether or not a row had paid dcce changed to 1
  Rcpp::LogicalVector paid_dcce_changed = (out["paid_dcce"] != df["paid_dcce"]);

  // want the 1's to have come from the case resv column if the case resv column was not changed
  // and the paid loss column was changed
  Rcpp::LogicalVector paid_loss_from_case = (paid_loss_changed == true) & (case_resv_changed == false);

  // in this case subtract 1 from the case resv column
  out["case_resv"][paid_loss_from_case] = out["case_resv"][paid_loss_from_case] - 1;

  // same thing for paid dcce
  Rcpp::LogicalVector paid_dcce_from_case = (paid_dcce_changed == true) & (case_resv_changed == false);

  // in this case subtract 1 from the case resv column as long as the case resv column is not exactly 1 already
  out["case_resv"][paid_dcce_from_case] = out["case_resv"][paid_dcce_from_case] - 1;

  // update the cumulative OLEP column
  out["cum_olep"] = update_0_to_1(out, "cum_olep");

  



  
  
  

  
  df[df$paid_loss == 0, "paid_loss"] < -1 
  df[df$case_resv == 0, "case_resv"] < -1 
  df[df$paid_dcce == 0, "paid_dcce"] < -1 
  df[df$cum_olep == 0, "cum_olep"] < -1

  }