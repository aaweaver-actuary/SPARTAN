functions{
  // function that takes a matrix with rows as policies and columns as development periods
  // starts at the right-hand side of the matrix and checks for the first value that is both non-missing and non-zero
  // from that point, it scans cell-by-cell to the left and checks for the first value that is 0
  // when it finds a 0 in a cell, it changes that cell to 1 and subtracts 1 from the cell to the right of it
  // this function is used to ensure that the loss development triangles can be taken on a log scale
  /**
    * @title Adjust loss development triangles
    * @description Adjusts loss development triangles to ensure that they can be taken
    * on a log scale. Basically looks for the first 0 in the upper half of the triangle
    * and adjusts the triangle so that the 0 is replaced by 1 and the cell to the right
    * of the 0 is reduced by 1. This way every cell in the upper half of the triangle
    * is non-zero and the triangle can be taken on a log scale.
    * @param loss matrix with rows as policies and columns as development periods
    * @param n_policies int number of policies
    * @param n_development_periods int number of development periods
    *
    * @return matrix with rows as policies and columns as development periods
    * where each element is adjusted to ensure that the loss development triangles can be taken on a log scale
    * @raise error if number of policies is not equal to number of rows in loss
    * @raise error if number of development periods is not equal to number of columns in loss
    *
    * @example
    * loss = [[1, 2, 3], [0, 5, 0], [7, 0, 0]]
    * n_policies = 3
    * n_development_periods = 3
    * // adjust_loss_development_triangles(loss, n_policies, n_development_periods)
    * // should return [[1, 2, 3], [1, 4, 0], [7, 0, 0]]
    * // the first policy is NOT ADJUSTED because it does not have any missing values
    * // the second policy is adjusted IN THE FIRST CELL ONLY because
    * // it has a missing value in the first development period and
    * // the first non-zero value is in the second development period
    * // the third policy is NOT ADJUSTED because it has missing values in
    * // the 2nd and 3rd development periods and
    * // the first non-zero value is in the 1st development period
    * 

    * adjust_loss_development_triangles(loss, n_policies, n_development_periods)
    * # returns [[1, 2, 3], [1, 4, 0], [7, 0, 0]]
    */

  matrix adjust_loss_development_triangles(matrix loss, int n_policies, int n_development_periods){
    // test that number of policies is equal to number of rows in loss matrix
    if (n_policies != rows(loss)){
      print("Number of policies passed: ", n_policies);
      print("Number of rows in loss matrix: ", rows(loss));
      error("Number of policies is not equal to number of rows in `loss` matrix.");
    }

    // test that number of development periods is equal to number of columns in loss matrix
    if (n_development_periods != cols(loss)){
      print("Number of development periods passed: ", n_development_periods);
      print("Number of columns in loss matrix: ", cols(loss));
      error("Number of development periods is not equal to number of columns in `loss` matrix.");
    }

    // initialize matrix to hold adjusted loss development triangles
    matrix[n_policies, n_development_periods] adjusted_loss_development_triangles;

    // loop over policies
    for (p in 1:n_policies){

      // initialize boolean to indicate whether policy has been adjusted
      int policy_adjusted = 0;

      // loop backwards over development periods
      for (d in n_development_periods:-1:1){

        // if policy has not been adjusted
        if (policy_adjusted == 0){

          // if policy has a missing value or a zero in the current development period
          // and the current development period is not the FIRST development period
          // don't adjust the cell for the current development period
          if ((is_missing(loss[p, d]) || loss[p, d] == 0) && d != 1){

            // set adjusted loss development triangle to the same value as the original loss development triangle
            adjusted_loss_development_triangles[p, d] = loss[p, d];
          }
          // otherwise, if policy has a non-missing and non-zero value in the current development period
          // and the current development period is not the FIRST development period
          // check to see that the cell immediately to the left of the current development period is non-zero
          // if it is non-zero, don't adjust the cell for the current development period
          // if it is zero, adjust the cell for the current development period
          else if (!is_missing(loss[p, d]) && loss[p, d] != 0 && d != 1){

            // if cell immediately to the left of the current development period is non-zero
            if (loss[p, d - 1] != 0){

              // set adjusted loss development triangle to the same value as the original loss development triangle
              adjusted_loss_development_triangles[p, d] = loss[p, d];
            }
            // otherwise, if cell immediately to the left of the current development period is zero
            else{

              // set adjusted loss development triangle to the same value as the original loss development triangle minus 1
              adjusted_loss_development_triangles[p, d] = loss[p, d] - 1;

              // set cell to the left to be 1
              adjusted_loss_development_triangles[p, d - 1] = 1;

              // set policy adjusted to 1
              policy_adjusted = 1;
            }
          }
          // otherwise, if policy has a non-missing and non-zero value in the FIRST development period
          // don't adjust the cell for the current development period
          else if (d == 1){

            // if policy has a missing value or a zero in the FIRST development period and the SECOND development period is non-zero
            // set first development period to 1 and second to be the same as the original second development period minus 1
            if ((is_missing(loss[p, d]) || loss[p, d] == 0) && loss[p, d + 1] != 0){

              // set adjusted loss development triangle to 1
              adjusted_loss_development_triangles[p, d] = 1;

              // set adjusted loss development triangle to the same value as the original loss development triangle minus 1
              adjusted_loss_development_triangles[p, d + 1] = loss[p, d + 1] - 1;

              // set policy adjusted to 1
              policy_adjusted = 1;
            }
            // otherwise, if policy has a non-missing and non-zero value in the FIRST development period
            // set adjusted loss development triangle to the same value as the original loss development triangle
            else{

              // set adjusted loss development triangle to the same value as the original loss development triangle
              adjusted_loss_development_triangles[p, d] = loss[p, d];
            }
          }
        }
        // otherwise, if policy has been adjusted
        else{

          // check to see that the cell immediately to the right of the current development period in the adjusted loss development triangle is 1
          // if it is 1, check to see that the cell in the original loss development triangle is non-zero
          // if so, set the cell in the adjusted loss development triangle to be the same as the cell in the original loss development triangle
          // if not, set the cell in the adjusted loss development triangle to be 1 as well
          if (adjusted_loss_development_triangles[p, d + 1] == 1){

            // if cell in original loss development triangle is non-zero
            if (loss[p, d + 1] != 0){
              // check if the current cell in the original triangle is zero
              if (loss[p, d] == 0){
                // set adjusted loss development triangle to 1
                adjusted_loss_development_triangles[p, d] = 1;

                // set the cell to the right to be 1 less than the original cell
                adjusted_loss_development_triangles[p, d + 1] = loss[p, d + 1] - 1;
              }
              else{
                // set adjusted loss development triangle to the same value as the original loss development triangle
                adjusted_loss_development_triangles[p, d] = loss[p, d];
              }
            }
            // otherwise, if cell to the right in original loss development triangle is zero
            else{
              // check whether the current cell in the original triangle is zero
              // if so, set the current cell in the adjusted triangle to 1 as well
              // if not, set the current cell in the adjusted triangle to be the same as the original cell
              if (loss[p, d] == 0){
                // set adjusted loss development triangle to 1
                adjusted_loss_development_triangles[p, d] = 1;
              }
              else{
                // set adjusted loss development triangle to the same value as the original loss development triangle
                adjusted_loss_development_triangles[p, d] = loss[p, d];
              }
            }
          }
        } 



  // function that takes a matrix with rows as policies and columns as development periods
  // and a vector of group assignments and returns a matrix with rows as groups and columns as development periods
  // where each element is the sum of the corresponding development period across all policies in the group
  /**
    * @title Sum development periods by group
    * @description Sums development periods by group
    * @param loss matrix with rows as policies and columns as development periods
    * @param groups vector vector of group assignments
    * @param n_groups int number of groups.
    * This should be the same as the number of unique values in groups vector.
    * @param n_development_periods int number of development periods.
    * This should be the same as the number of columns in loss matrix.
    *
    * @return matrix with rows as groups and columns as development periods
    * where each element is the sum of the corresponding development period
    * across all policies in the group
    * @raise error if number of groups is not equal to number of rows in loss
    * @raise error if number of development periods is not equal to number of columns in loss
    *
    * @example
    * loss = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    * groups = [1, 2, 1]
    * n_groups = 2
    * n_development_periods = 3
    * sum_development_periods_by_group(loss, groups, n_groups, n_development_periods)
    * # returns [[8, 10, 12], [4, 5, 6]]
    */
  matrix sum_development_periods_by_group(matrix loss, vector groups, int n_groups, int n_development_periods){
    // test that number of groups is equal to number of unique values in groups vector, not the max value
    vector unique_groups = unique(groups);
    if (n_groups != size(unique_groups)){
      print("Number of groups passed: ", n_groups);
      print("Unique groups in the `groups` vector: ", unique_groups);
      print("Number of unique groups in the `groups` vector: ", size(unique_groups));
      error("Number of groups is not equal to number of unique values in `groups` vector.");
    }

    // test that number of development periods is equal to number of columns in loss matrix
    if (n_development_periods != cols(loss)){
      print("Number of development periods: ", n_development_periods);
      print("Number of columns in loss matrix: ", cols(loss));
      error("Number of development periods is not equal to number of columns in `loss` matrix.");
    }
    
    // number of groups
    int n_groups = max(groups);

    // number of development periods is the number of columns in loss
    int n_development_periods = cols(loss);

    // initialize matrix to hold sum of development periods by group
    matrix[n_groups, n_development_periods] sum_development_periods_by_group;

    // loop over groups
    for (g in 1:n_groups){

      // loop over development periods
      for (d in 1:n_development_periods){

        // initialize sum of development periods by group
        sum_development_periods_by_group[g, d] = 0;

        // loop over policies
        for (p in 1:rows(loss)){

          // if policy is in group
          if (groups[p] == g){

            // handle missing values:
            if (is_nan(loss[p, d])){
              // add a value of 0 to sum of development periods by group
              sum_development_periods_by_group[g, d] += 0;
            } 
            else {
              // add development period to sum of development periods by group
              // this is the same as summing the development period across all policies in the group
              sum_development_periods_by_group[g, d] += loss[p, d];
            }
          }
        }
      }
    }

    return sum_development_periods_by_group;
  }
}

data{
  // number of policies
  int<lower=1> n_policies;

  // number of origin periods (usually accident period)
  int<lower=1> n_origin_periods;

  // number of development periods
  int<lower=1> n_development_periods;

  // policy reported loss development triangle
  // each row is a policy
  // each column is a development period
  matrix[n_policies, n_development_periods] reported_loss;

  // policy paid loss development triangle
  // each row is a policy
  // each column is a development period
  matrix[n_policies, n_development_periods] paid_loss;

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
  matrix[n_policies, n_development_periods] exposure;
}
transformed data {
   // log of the reported loss

}

parameters{
  // all the parameters for the exposure time series model
  // the exposure time series model is a multivariate ARIMA model
  // the parameters are the coefficients for the ARIMA model
  matrix arima_alpha[n_policies, n_development_periods];
  matrix arima_theta[n_policies, n_development_periods];
  matrix arima_epsilon[n_policies, n_development_periods];




  // alpha parameter for each origin period
  // each element is an alpha parameter
  // each element is the alpha parameter corresponding
  // to an origin period (indexed starting at 1)
  vector[n_origin_periods] alpha_total;

  // the alpha parameters are the expected loss ratios (ELR) on a log scale

}
transformed parameters {
   // mean of expected exposure from the exposure time series model
   // each element is the mean of the expected exposure for a development period
   matrix[n_policies, n_development_periods] expected_exposure;
   
}

model{
  arima_epsilon ~ normal(0, 2);
}