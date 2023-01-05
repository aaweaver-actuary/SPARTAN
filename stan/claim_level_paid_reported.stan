/** need to generate these somewhere...:
  * // mean of expected exposure from the exposure time series model
  * // each element is the mean of the expected exposure for a development period
  * matrix[n_policies, n_exposure_development_periods] expected_exposure;
*/

functions{
  // include spartan_functions.stan functions
  #include spartan_functions.stan
  // function that takes current year, month, first origin year, and the number of origin periods
  // and returns a vector of the final development period for each origin period
  // the final development period is the number of months between the current year and month
  // and the first origin year and month
  // assuming working with origin years, not origin months or origin quarters
  // so the final development period is the number of months between the current year and month
  // and the March of the first origin year
  // expessed as a number of months
  
  /**
  * @title Calculate Final Development Period for Each Origin Year
  * @description Calculates the final development period for each origin year.
  * The final development period is the number of months between the current year and month
  * and the first origin year and month.
  * Assuming working with origin years, not origin months or origin quarters,
  * so the final development period is the number of months between the current year and month
  * and the March of the first origin year 
  * + 3 as a convention.
  * Expressed as a number of months.
  * development period = 12 * (current_year - first_origin_year) + (current_month)
  *
  * @param origins_to_test vector of origin years to test
  * @param current_year int current year
  * @param current_month int current month
  * @param first_origin_year int first origin year
  * @param n_origin_periods int number of origin periods
  *
  * @return vector of the final development period for each origin period
  * @examples
  * origins_to_test = np.array([2015, 2016, 2017])
  * current_year = 2017
  * current_month = 3
  * first_origin_year = 2015
  * n_origin_periods = 3
  * final_development_period_for_origin_year = final_development_period_for_origin_year(origins_to_test, current_year, current_month, first_origin_year, n_origin_periods)
  * # should be [27, 15, 3] because we always add 3 to the calculation at the end
  * final_development_period_for_origin_year
  * [27, 15, 3]

  * origins_to_test = np.array([2015, 2016, 2017, 2018, 2019, 2020])
  * current_year = 2021
  * current_month = 6
  * first_origin_year = 2015
  * n_origin_periods = 6
  * final_development_period_for_origin_year = final_development_period_for_origin_year(origins_to_test, current_year, current_month, first_origin_year, n_origin_periods)
  * final_development_period_for_origin_year
  * # should be [78, 66, 54, 42, 30, 18] 
  * # last one is 18 because the current year is 2021 and the current month is 6, so [12 * (2021 - 2020)] + 6 = 18
  * # the first one is 78 because the current year is 2021 and the current month is 6, so [12 * (2021 - 2015))] + 6 = 78
  * # 54 comes from [12 * (2021 - 2017)] + 6 = 54
  * using same parameters as above, but with current year and month as 2022 and 3
  * final_development_period_for_origin_year = final_development_period_for_origin_year(origins_to_test, 2022, 3, 2015, 6)
  * final_development_period_for_origin_year

  * origin_year = np.array([2010, 2011, 2012])
  * n_origin_periods = 3
  * development_pattern = np.array([0.25, 0.5, 0.75, 1])
  * current_year = 2012
  * current_month = 9
  * # test final development period for each origin period
  * final_development_period_for_origin_year = final_development_period_for_origin_year(origin_year, current_year, current_month, 2010, n_origin_periods)
  * print(final_development_period_for_origin_year)
  * # should be [27, 15, 3]
  */
  vector final_development_period_for_origin_year(int n_origin_periods, vector[n_origin_periods] origins_to_test, int current_year, int current_month, int first_origin_year){
    // test that the current year is greater than or equal to the largest origin year
    // if not, throw an error
    if (current_year < max(origins_to_test)){
      print("Current year: ", current_year)
      print("Largest origin year: ", max(origins_to_test))
      reject("Current year must be greater than or equal to the largest origin year.");
    }

    // test that the current month is between 1 and 12
    // if not, throw an error
    if (current_month < 1 || current_month > 12){
      print("Current month: ", current_month)
      reject("Current month must be between 1 and 12.");
    }

    // test that the first origin year is greater than or equal to 2000
    // if not, throw an error
    if (first_origin_year < 2000){
      print("First origin year: ", first_origin_year)
      reject("First origin year must be greater than or equal to 2000.");
    }

    // test that the length of the origins_to_test vector is equal to the number of origin periods
    // if not, throw an error
    if (size(origins_to_test) != n_origin_periods){
      print("Length of origins_to_test vector: ", size(origins_to_test))
      print("Number of origin periods: ", n_origin_periods)
      reject("Length of origins_to_test vector must be equal to the number of origin periods.");
    }

    // array of the final development period for each origin period
    real[n_origin_periods] final_development_period_for_origin_year;
    
    // loop through each origin period
    for (i in 1:n_origin_periods){
      // calculate the final development period for each origin period
      // final development period = 12 * (current_year - origin_year) + current_month
      final_development_period_for_origin_year[i] = 12 * (current_year - origins_to_test[i]) + current_month;
    }
    return final_development_period_for_origin_year; 
  }



  /**
  * @title Calculate Final Development Period for Each Origin Month
  * @description Calculates the final development period for each origin year/month.
  * The final development period is the number of months between the current year and month
  * and the first origin year and month.
  * Assuming working with origin months, so the final development period is
  * the number of months between the current year and month and the origin year and month
  * + 3 as a convention.
  * Expressed as a number of months.
  * development period = 12 * (current_year - origin_year) + (current_month - origin_month + 3)
  *
  * @param origins_to_test matrix with two columns origin years to test
  * @param current_year int current year
  * @param current_month int current month
  * @param first_origin_year int first origin year
  * @param n_origin_periods int number of origin periods
  *
  * @return vector of the final development period for each origin period
  * @examples
  * origins_to_test = np.array([[2015, 3], [2015, 6], [2015, 9], [2015, 12], [2016, 3], [2016, 6], [2016, 9], [2016, 12], [2017, 3], [2017, 6], [2017, 9], [2017, 12]])
  * current_year = 2018
  * current_month = 3
  * first_origin_year = 2015
  * n_origin_periods = origins_to_test.shape[0]
  * final_development_period_for_origin_year = final_development_period_for_origin_year(origins_to_test, current_year, current_month, first_origin_year, n_origin_periods)
  * final_development_period_for_origin_year
  * # should be [36, 33, 30, 27, 24, 21, 18, 15, 12, 9, 6, 3]

  * current_year = 2023
  * current_month = 6
  * first_origin_year = 2015
  * n_origin_periods = origins_to_test.shape[0]
  * final_development_period_for_origin_year = final_development_period_for_origin_year(origins_to_test, current_year, current_month, first_origin_year, n_origin_periods)
  * final_development_period_for_origin_year
  * # should be [63, 60, 57, 54, 51, 48, 45, 42, 39, 36, 33, 30]

  */
  vector final_development_period_for_origin_month(matrix origins_to_test, int current_year, int current_month, int first_origin_year, int n_origin_periods){
    // test that the current year is greater than or equal to the largest origin year
    // if not, throw an error
    if (current_year < max(origins_to_test[, 1])){
      print("Current year: ", current_year)
      print("Largest origin year: ", max(origins_to_test[, 1]))
      reject("Current year must be greater than or equal to the largest origin year.");
    }

    // test that the current month is between 1 and 12
    // if not, throw an error
    if (current_month < 1 || current_month > 12){
      print("Current month: ", current_month)
      reject("Current month must be between 1 and 12.");
    }

    // test that the first origin year is greater than or equal to 2000
    // if not, throw an error
    if (first_origin_year < 2000){
      print("First origin year: ", first_origin_year)
      reject("First origin year must be greater than or equal to 2000.");
    }

    // test that the number of columns in the origins_to_test matrix is equal to 2
    // if not, throw an error
    if (cols(origins_to_test) != 2){
      print("Number of columns in origins_to_test matrix: ", cols(origins_to_test))
      reject("Number of columns in origins_to_test matrix must be equal to 2.");
    }

    // test that the length of the origins_to_test matrix is equal to the number of origin periods
    // if not, throw an error
    if (rows(origins_to_test) != n_origin_periods){
      print("Length of origins_to_test matrix: ", rows(origins_to_test))
      print("Number of origin periods: ", n_origin_periods)
      reject("Length of origins_to_test matrix must be equal to the number of origin periods.");
    }

    // vector of the final development period for each origin period
    vector[n_origin_periods] final_development_period_for_origin_month;
    
    // loop through each origin period
    for (i in 1:n_origin_periods){
      // calculate the final development period for each origin period
      // final development period = 12 *
      // (current_year - origin_year) + (current_month - origin_month + 3)
      final_development_period_for_origin_month[i] = 12 * (current_year - origins_to_test[i, 1]) + (current_month - origins_to_test[i, 2] + 3);
    }
  }

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
    * @title Calculate Chain-Ladder Ultimate Loss for Origin Year Data
    * @description Calculates the expected loss for each origin period using the chain-ladder method.
    * Calculate the final development period for each origin year.
    * If the number of unique origin years is less than the number of rows in the loss matrix,
    * uses the aggregated_loss function to aggregate the loss matrix by origin year from the 
    * spartan_functions.stan file: 
    * aggregated_loss(matrix loss, vector group, int n_rows, int n_cols, int n_groups)
    * If the triangle is incremental, it first calculates the cumulative loss triangle.
    * Either way, it then calculates the expected loss for each origin period
    * by taking the sum of the final development period of each origin period
    * and then dividing that sum by the percent of ultimate loss in the final development period.
    * Uses `final_development_period_for_origin_year(vector origins_to_test, int current_year
    * , int current_month, int first_origin_year, int n_origin_periods)` function to calculate
    * the final development period for each origin year.
    * if the (current_year * 12 + current_month) is less than (max(origin_year) * 12 + 12,
    * then the final development period is set to the current month.
    *
    * @param loss matrix representing a loss triangle
    * @param origin_year vector of the origin year for each row of the loss matrix
    * @param cumulative_loss indicator of whether or not the triangle is cumulative
    * @param n_origin_periods int number of origin periods in matrix
    * @param n_development_periods int number of development periods in matrix
    * @param development_pattern vector of the number of development periods containing
    * a normal-scale development pattern
    * expressed as the percent of ultimate loss in the final development period
    * @param current_year int current year
    * @param current_month int current month
    *
    * @return vector of size n_origin_periods representing the expected loss for each origin period
    * using the age-to-ultimate method
    * @examples
    * cumulative_loss = np.array([[1,2,3,0], [1,2,0,0], [1,0,0,0]])
    * origin_year = np.array([2010, 2011, 2012])
    * n_origin_periods = 3
    * n_development_periods = 4
    * development_pattern = np.array([0.25, 0.5, 0.75, 1])
    * current_year = 2012
    * current_month = 9
    * # test final development period for each origin period
    * final_development_period_for_origin_year = final_development_period_for_origin_year(n_origin_periods, origin_year, current_year, current_month, 2010)
    * print(final_development_period_for_origin_year)
    */
    vector chain_ladder_ultimate_loss(matrix loss, vector origin_year, int cumulative_loss, int n_origin_periods, int n_development_periods, vector development_pattern, int current_year, int current_month){
    // initialize vector of the final development period for each origin period
    vector[n_origin_periods] final_development_period_for_origin_year;

    // loop through each origin period
    for (i in 1:n_origin_periods){
      // calculate the final development period for each origin period
      // final development period = 12 *
      // (current_year - origin_year) + current_month
      final_development_period_for_origin_year[i] = 12 * (current_year - origin_year[i]) + current_month;
    }

    // if the (current_year * 12 + current_month) is less than (max(origin_year) * 12 + 12,
    // then the final development period is set to the current month
    if ((current_year * 12 + current_month) < (max(origin_year) * 12 + 12)){
      // loop through each origin period
      for (i in 1:n_origin_periods){
        // set the final development period for each origin period to the current month
        final_development_period_for_origin_year[i] = current_month;
      }
    }

    // if the number of unique origin years is less than the number of rows in the loss matrix,
    // then aggregate the loss matrix by origin year
    if (n_origin_periods < rows(loss)){
      // aggregate the loss matrix by origin year
      loss = aggregated_loss(loss, origin_year, rows(loss), n_development_periods, n_origin_periods);
    }

    // if the triangle is incremental, calculate the cumulative loss triangle
    // using the cumulative_loss function from the spartan_functions.stan file
    if (cumulative_loss == 0){
      loss = cumulative_loss(loss, n_origin_periods, n_development_periods);
    }

    // initialize vector of the estimated ultimate loss for each origin period
    vector[n_origin_periods] estimated_ultimate_loss;

    // loop through each origin period
    for (i in 1:n_origin_periods){
      // calculate the estimated ultimate loss for each origin period
      // by taking the cumulative loss in the final development period
      // and then dividing by the percent of ultimate loss in the final development period 
      // unless the development pattern is 0, in which case the estimated ultimate loss is 0
      if (development_pattern[final_development_period_for_origin_year[i]] == 0){
        estimated_ultimate_loss[i] = 0;
      } else {
        estimated_ultimate_loss[i] = loss[i, final_development_period_for_origin_year[i]] / development_pattern[final_development_period_for_origin_year[i]];
      }
    }

    // return the estimated ultimate loss for each origin period
    return estimated_ultimate_loss;
    }

    // function that takes the cumulative loss for each origin period,
    // the exposure for each origin period,
    // the expected loss ratio for each origin period
    // and the development pattern
    // and returns the ultimate loss for each origin period based on the
    // Cape Cod method
    // cape cod ultimate = cumulative loss + (exposure * expected loss ratio * (1 - development pattern))
    /**
    * @param cumulative_loss vector of the cumulative loss for each origin period
    * @param exposure vector of the exposure for each origin period
    * @param final_development_period_for_origin_year vector of the final development period for each origin period
    * @param expected_loss_ratio vector of the expected loss ratio for each origin period
    * @param development_pattern vector of the number of development periods containing
    * a normal-scale development pattern
    * expressed as the percent of ultimate loss in the final development period
    * @param n_development_periods int number of development periods in matrix
    *
    * @return vector of size n_origin_periods representing the ultimate loss for each origin period
    * using the Cape Cod method (cumulative loss + (exposure * expected loss ratio * (1 - development pattern)))
    * @examples
    * cumulative_loss = np.array([1,2,3])
    * exposure = np.array([1,2,3])
    * final_development_period_for_origin_year = np.array([1,2,3])
    * expected_loss_ratio = np.array([0.25, 0.5, 0.75])
    * development_pattern = np.array([0.25, 0.5, 0.75, 1])
    * n_development_periods = 4
    * # test cape cod ultimate loss for each origin period
    * cape_cod_ultimate_loss = cape_cod_ultimate_loss(cumulative_loss, exposure, final_development_period_for_origin_year, expected_loss_ratio, development_pattern, n_development_periods)
    * print(cape_cod_ultimate_loss)
    */
    vector cape_cod_ultimate_loss(vector cumulative_loss, vector exposure, vector final_development_period_for_origin_year, vector expected_loss_ratio, vector development_pattern, int n_development_periods){
      // initialize vector of the ultimate loss for each origin period
      vector[rows(cumulative_loss)] ultimate_loss;

      // loop through each origin period
      for (i in 1:rows(cumulative_loss)){
        // calculate the ultimate loss for each origin period
        // by taking the cumulative loss for each origin period
        // and adding the exposure for each origin period
        // multiplied by the expected loss ratio for each origin period
        // multiplied by (1 - the development pattern for the final development period for each origin period)
        // unless the development pattern is 0, in which case the ultimate loss is 0
        if (development_pattern[final_development_period_for_origin_year[i]] == 0){
          ultimate_loss[i] = 0;
        } else {
          ultimate_loss[i] = cumulative_loss[i] + (exposure[i] * expected_loss_ratio[i] * (1 - development_pattern[final_development_period_for_origin_year[i]]));
        }
      }

      // return the ultimate loss for each origin period
      return ultimate_loss;
    }

    // function that takes the chain ladder estimated ultimate loss for each origin period,
    // the cape cod ultimate loss for each origin period,
    // and the development pattern 
    // and returns the ultimate loss for each origin period based on the
    // Benktander method (CL * (1 - DP) + CC * DP)


}

data{
  // current year, month
  int<lower=2000> current_year;
  int<lower=1, upper=12> current_month;

  // first year of origin period
  int<lower=2000> first_origin_year;

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