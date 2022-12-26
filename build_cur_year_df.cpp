// recreates the `build_cur_year_df` function from the "mcmc_funcs.R" file to be used with `Rcpp`

// first sets headers

// [[Rcpp::depends(Rcpp)]]
#include <Rcpp.h>

// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::depends(RcppParallel)]]
#include <RcppParallel.h>

// then sets namespaces
using namespace Rcpp;
using namespace arma;

// then sets the function
// this function builds a data frame for the current year
// [[Rcpp::export]]
Rcpp::DataFrame build_cur_year_df(Rcpp::DataFrame df, Rcpp::DataFrame all_lines_olep, int year, int first_ay, Rcpp::List params)
{
  // initialize the output data frame
  Rcpp::DataFrame out;

  // selects the column 'w' from the data frame
  Rcpp::NumericVector w = df["w"];

  // Remove duplicates and keep only the unique values of 'w'
  Rcpp::NumericVector w_unique = Rcpp::unique(w);

  // gets the number of unique values of 'w'
  int w_unique_size = w_unique.size();

  // Add a new column 'cur_d' to the data frame
  // The value of 'cur_d' for each row is calculated as 12 * (year - first_ay + 1 - w) + (quarter * 3)
  // 'year' and 'quarter' are assumed to be columns in the original data frame 'modeldf'
  // 'first_ay' is a parameter passed in the 'params' list
  Rcpp::NumericVector cur_d = 12 * (year - first_ay + 1 - w) + (df["quarter"] * 3);

  // Add a new column 'd' to the data frame
  // The value of 'd' for each row is calculated as the value of 'cur_d' divided by 3
  Rcpp::NumericVector d = cur_d / 3;

  // Left join the data frame with itself on the columns 'w' and 'd'
  // Select the columns 'w', 'd', 'paid_loss', 'rpt_loss', 'paid_dcce', 'rpt_counts', 'closed_counts' from the joined data frame
  Rcpp::DataFrame left_join1 = Rcpp::left_join(df, df, Rcpp::Named("by") = Rcpp::CharacterVector::create("w", "d"));
  Rcpp::DataFrame select1 = Rcpp::select(left_join1, Rcpp::CharacterVector::create("w", "d", "paid_loss", "rpt_loss", "paid_dcce", "rpt_counts", "closed_counts"));

  // Left join the data frame with itself on the column 'w'
  // Select the columns 'ay' and 'w' from the joined data frame, and keep only unique rows
  Rcpp::DataFrame left_join2 = Rcpp::left_join(df, df, Rcpp::Named("by") = Rcpp::CharacterVector::create("w"));
  Rcpp::DataFrame select2 = Rcpp::select(left_join2, Rcpp::CharacterVector::create("ay", "w"));
  Rcpp::DataFrame unique2 = Rcpp::unique(select2);

  // Left join the data frame with itself on the column 'd'
  // Select the columns 'dev_month' and 'd' from the joined data frame, and keep only unique rows
  Rcpp::DataFrame left_join3 = Rcpp::left_join(df, df, Rcpp::Named("by") = Rcpp::CharacterVector::create("d"));
  Rcpp::DataFrame select3 = Rcpp::select(left_join3, Rcpp::CharacterVector::create("dev_month", "d"));
  Rcpp::DataFrame unique3 = Rcpp::unique(select3);

  // Left join the data frame with the data frame 'all_lines_olep' on the column 'ay'
  // Select the column 'cum_olep' from the joined data frame
  // Filter the data frame 'all_lines_olep' to keep only rows where the value of 'dev_month' is 12 and 'lob' is equal to the value of 'lob' in the 'params' list
  // Select the columns 'ay' and 'cum_olep' from the filtered data frame
  Rcpp::DataFrame left_join4 = Rcpp::left_join(df, all_lines_olep, Rcpp::Named("by") = Rcpp::CharacterVector::create("ay"));
  Rcpp::DataFrame select4 = Rcpp::select(left_join4, Rcpp::CharacterVector::create("cum_olep"));
  Rcpp::DataFrame filter4 = Rcpp::filter(all_lines_olep, Rcpp::Named("dev_month") = 12, Rcpp::Named("lob") = params["lob"]);
  Rcpp::DataFrame select5 = Rcpp::select(filter4, Rcpp::CharacterVector::create("ay", "cum_olep"));

  // to get the current year EP
  // start with the all_lines_olep data frame
  Rcpp::DataFrame cur_year = all_lines_olep;

  // filter the data frame to keep only rows where the value of 'lob' is equal to the value of 'lob' in the 'params' list
  // and the value of 'ay' is equal to the value of 'year' in the 'params' list
  // and the value of 'dev_month' is equal to 12
  Rcpp::DataFrame filter5 = Rcpp::filter(cur_year, Rcpp::Named("lob") = params["lob"], Rcpp::Named("ay") = year, Rcpp::Named("dev_month") = 12);

  // set the current year cum_olep to the value of 'cum_olep' in the filtered data frame
  double current_ay = filter5["cum_olep"];

  // set current_ay to be the current year OLEP from the output data frame
  Rcpp::NumericVector cur_ay = current_ay;

  // Return the modified data frame
  return Rcpp::DataFrame::create(
      Rcpp::Named("w") = w, Rcpp::Named("ay") = year, Rcpp::Named("cur_d") = cur_d, Rcpp::Named("d") = d, Rcpp::Named("cur_ay") = cur_ay, Rcpp::Named("w_unique") = w_unique, Rcpp::Named("w_unique_size") = w_unique_size, Rcpp::Named("select1") = select1, Rcpp::Named("unique2") = unique2, Rcpp::Named("unique3") = unique3, Rcpp::Named("select5") = select5);
}