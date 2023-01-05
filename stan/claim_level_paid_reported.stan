/** need to generate these somewhere...:
  * // mean of expected exposure from the exposure time series model
  * // each element is the mean of the expected exposure for a development period
  * matrix[n_policies, n_exposure_development_periods] expected_exposure;
*/

functions{
  // include spartan_functions.stan functions
  #include spartan_functions.stan

  // function that takes a matrix representing a loss triangle,
  // an indicator of whether or not the triangle is cumulative,
  // and a vector of the number of development periods containing a normal-scale development pattern
  // expressed as the percent of ultimate loss in the final development period
  // and returns a vector of size n_origin_periods representing the expected loss for each origin period
  // using the age-to-ultimate method
  // if the triangle is incremental, it first calculates the cumulative loss triangle
  // either way, it then calculates the expected loss for each origin period
  // by taking the sum of the final development period of each origin period
  // and then dividing that sum by the percent of ultimate loss in the final development period

  /**
    * @title Calculate Chain-Ladder Ultimate Loss
    * @description Calculates the expected loss for each origin period using the chain-ladder method.
    * If the number of unique origin periods is less than the number of rows in the loss matrix,
    * uses the aggregated_loss function to aggregate the loss matrix by origin period from the 
    * spartan_functions.stan file: 
    * aggregated_loss(matrix loss, vector group, int n_rows, int n_cols, int n_groups)
    * If the triangle is incremental, it first calculates the cumulative loss triangle.
    * Either way, it then calculates the expected loss for each origin period
    * by taking the sum of the final development period of each origin period
    * and then dividing that sum by the percent of ultimate loss in the final development period.
    *
    * @param loss matrix representing a loss triangle
    * @param cumulative_loss indicator of whether or not the triangle is cumulative
    * @param n_origin_periods int number of origin periods in matrix
    * @param n_development_periods int number of development periods in matrix
    * @param development_pattern vector of the number of development periods containing
    * a normal-scale development pattern
    * expressed as the percent of ultimate loss in the final development period
    *
    * @return vector of size n_origin_periods representing the expected loss for each origin period
    * using the age-to-ultimate method
    * @examples
    * cumulative_loss = np.array([[1,2,3], [1,2,0], [1,0,0]])
    * expected_loss = chain_ladder_ultimate_loss(cumulative_loss, 1, 3, 3, np.array([0.5, (1/1.5), 1]))
    * expected_loss

    ISSUES HERE -- NEED TO KNOW WHERE THE FINAL DEVELOPMENT PERIOD IS FOR EACH ORIGIN PERIOD
    SHOULD BE ABLE TO DO THIS BY GETTING THE CURRENT YEAR AND MONTH AND PASSING THAT + ORIGIN PERIODS TO A NEW FUNCTION
    THAT THEN CALCULATES THE FINAL DEVELOPMENT PERIOD FOR EACH ORIGIN PERIOD
    THEN CAN USE THAT TO CALCULATE THE EXPECTED LOSS FOR EACH ORIGIN PERIOD




    */


  
}

data{
  // number of policies
  int<lower=1> n_policies;

  // number of origin periods (usually accident period)
  int<lower=1> n_origin_periods;

  // number of development periods
  int<lower=1> n_development_periods;

  // number of exposure development periods
  int<lower=1> n_exposure_development_periods;

  // policy reported loss development triangle
  // each row is a policy
  // each column is a development period
  matrix[n_policies, n_development_periods] reported_loss;

  // policy paid loss development triangle
  // each row is a policy
  // each column is a development period
  matrix[n_policies, n_development_periods] paid_loss;

  // matrix indicating whether a cell in either reported_loss or paid_loss 
  // is in the upper triangle or not
  // each row is a policy
  // each column is a development period
  // each element is 1 if the cell is in the upper triangle, 0 if not
  matrix<lower=0, upper=1>[n_policies, n_development_periods] upper_half;

  // vector of policy origin periods
  // each element is an origin period
  // each element corresponds to a row in reported_loss and paid_loss
  // origin periods are indexed starting at 1 (not 0) for 2015, 2016, 2017, etc.
  vector[n_policies] origin_period;  

  // number of expected loss ratio groups (ELR) to cluster policies into
  int<lower=1> n_expected_loss_ratio_groups;

  // number of development pattern groups (DP) to cluster policies into (may be different than ELR groups)
  int<lower=1> n_development_pattern_groups;

  // matrix representing the estimated exposure for each policy
  // each row is a policy
  // each column is an evaluation period
  // each element is the estimated exposure for the policy at the evaluation period
  matrix[n_policies, n_exposure_development_periods] exposure;

  // indicator for whether the triangle is cumulative or not
  // 1 if cumulative, 0 if not
  int<lower=0, upper=1> cumulative;
}
transformed data {
  // adjusted reported & paid loss development triangles
  // adjusted to ensure that each cell in the triangle is >= $1
  // this is done by adding the difference between the cell and $1 to the next cell
  // then taking the log of each cell
  // if `cumulative`=0, then the triangle is not cumulative and should be adjusted before taking the log
  // if `cumulative`=1, then the triangle is cumulative and should not be adjusted before taking the log
  if (cumulative == 0){
    matrix log_adj_reported_loss[n_policies, n_development_periods] = 
    log_adjusted_triangle(cumulative_loss(reported_loss, upper_half, n_policies, n_development_periods), n_policies, n_development_periods);
    matrix log_adj_paid_loss[n_policies, n_development_periods] =
    log_adjusted_triangle(cumulative_loss(paid_loss, upper_half, n_policies, n_development_periods), n_policies, n_development_periods);
  }
  else {
    matrix log_adj_reported_loss[n_policies, n_development_periods] = 
    log_triangle(reported_loss, n_policies, n_development_periods);
    matrix log_adj_paid_loss[n_policies, n_development_periods] =
    log_triangle(paid_loss, n_policies, n_development_periods);
  }  
}
transformed parameters {
  // accident year `alpha` parameters for the total loss triangle
  // each element is the alpha parameter corresponding
  // to an origin period (indexed starting at 1)
  // both reported and paid loss triangles use the same alpha parameters
  vector[n_origin_periods] alpha_loss_total;

  // error parameters for the accident year `alpha` parameters
  // error is highest for the largest origin indices
  // and lowest for the smallest origin indices
  // does not necessarily decrease monotonically
  // both reported and paid loss triangles use the same alpha parameters
  vector<lower=0>[n_origin_periods] alpha_loss_total_error;




}

parameters{
  // ============================================
  // === DEVELOPMENT PATTERN PARAMETERS =========
  // ============================================

  // development pattern parameters for the total loss triangle
  vector beta_reported_loss_total[n_development_periods];
  vector beta_paid_loss_total[n_development_periods];

  // error parameters for the development pattern betas
  // error is highest for the earliest development periods
  // and lowest for the latest development periods
  // does not necessarily decrease monotonically
  vector<lower=0> beta_reported_loss_total_error[n_development_periods];
  vector<lower=0> beta_paid_loss_total_error[n_development_periods];

  // development pattern parameters for each development pattern group
  // matrix of beta parameters for each development pattern group
  // rows represent development pattern groups, indexed starting at 1
  // columns represent development periods, indexed starting at 1
  matrix[n_development_pattern_groups, n_development_periods] beta_reported_loss_group;
  matrix[n_development_pattern_groups, n_development_periods] beta_paid_loss_group;

  // error parameters for the development pattern betas
  // error is highest for the earliest development periods
  // and lowest for the latest development periods
  // does not necessarily decrease monotonically
  // matrix of error parameters for each development pattern group
  // rows represent development pattern groups, indexed starting at 1
  // columns represent development periods, indexed starting at 1
  matrix<lower=0>[n_development_pattern_groups, n_development_periods] beta_reported_loss_group_error;
  matrix<lower=0>[n_development_pattern_groups, n_development_periods] beta_paid_loss_group_error;

  // accident year `alpha` parameters for each development pattern group
  // matrix of alpha parameters for each development pattern group
  // rows represent development pattern groups, indexed starting at 1
  // columns represent origin periods, indexed starting at 1
  // both reported and paid loss triangles use the same alpha parameters
  matrix[n_development_pattern_groups, n_origin_periods] alpha_loss_group;

  // error parameters for the accident year `alpha` parameters
  // error is highest for the largest origin indices
  // and lowest for the smallest origin indices
  // does not necessarily decrease monotonically
  // both reported and paid loss triangles use the same alpha parameters
  matrix<lower=0>[n_development_pattern_groups, n_origin_periods] alpha_loss_group_error;

  // ======================================
  // === ORIGIN PERIOD PARAMETERS =========
  // ======================================

  // error parameters for the accident year `alpha` parameters
  // error is highest for the largest origin indices
  // and lowest for the smallest origin indices
  // does not necessarily decrease monotonically
  // both reported and paid loss triangles use the same alpha parameters
  vector<lower=0>[n_origin_periods] alpha_loss_total_error;

  // ============================================
  // === EXPECTED LOSS RATIO PARAMETERS =========
  // ============================================
  // vector of expected loss ratios for each origin period



  // all the parameters for the exposure time series model
  // the exposure time series model is a multivariate ARIMA model
  // the parameters are the coefficients for the ARIMA model
  // vector arima_alpha[n_exposure_development_periods];
  // vector arima_theta[n_exposure_development_periods];
  // vector arima_epsilon[n_exposure_development_periods];





}
transformed parameters {
   
   
}

model{
  
}