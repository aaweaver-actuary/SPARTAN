functions{
  // function that takes a matrix representing an incremental loss development triangle
  // and a matrix of 1's and 0's representing whether or not a cell is part of the upper half of the triangle
  // and returns a matrix representing a cumulative loss development triangle
  // starts with the first column of the incremental loss development triangle as
  // the first column of the cumulative loss development triangle
  // then loops through each column of the incremental loss development triangle
  // if the cell is part of the upper half of the triangle, add the incremental cell to the previous column's cumulative cell
  // if the cell is not part of the upper half of the triangle, set that cell to 0
  // rechecks the cumulative loss development triangle to ensure that there are no negative values in the upper half of the triangle
  // if there are negative values in the upper half of the triangle, it adjusts the cumulative loss development triangle, setting
  // the cell to 0 and subtracting 1 from the cell to the right of it, unless that would make the cell to the right of it negative
  // in that case just set the cell to 0
  /**
    * @title Cumulative loss development triangle
    * @description Creates a cumulative loss development triangle from an incremental loss development triangle.
    * @param incremental_loss matrix representing an incremental loss development triangle
    * @param upper_half matrix of 1's and 0's representing whether or not a cell is part of the upper half of the triangle
    * @param n_rows int number of rows in matrix
    * @param n_cols int number of columns in matrix
    *
    * @return matrix representing a cumulative loss development triangle
    * @raise error if number of rows is not equal to number of rows in incremental_loss matrix
    * @raise error if number of columns is not equal to number of columns in incremental_loss matrix
    * @raise error if number of rows is not equal to number of rows in upper_half matrix
    * @raise error if number of columns is not equal to number of columns in upper_half matrix
    * @raise error if number of rows is not equal to number of rows in cumulative_loss matrix
    * @raise error if number of columns is not equal to number of columns in cumulative_loss matrix
    * @raise error if there are negative values in the upper half of the cumulative_loss matrix
    *
    * @example
    * incremental_loss = [[1, 2, 3], [0, 5, 0], [7, 0, 0]]
    * upper_half = [[1, 1, 1], [1, 1, 0], [1, 0, 0]]
    * n_rows = 3
    * n_cols = 3
    * // cumulative_loss(incremental_loss, upper_half, n_rows, n_cols)
    * // should return [[1, 3, 6], [0, 5, 0], [7, 0, 0]]  
    * // the first policy does not have any missing values or any values equal to 0 
    * // and all of the cells are (1) in the upper half of the triangle and (2) are positive
    * // so the cumulative loss development triangle is taken normally, adding the incremental cell
    * // to the previous column's cumulative cell
    *
    * // the second policy has a 0 value in the first development period and
    * // it has a 0 value in the third development period
    * // the third development period is not in the upper half of the triangle
    * // so the cumulative loss in that cell is 0
    * // the first two cells in the second policy are in the upper half of the triangle
    * // so the cumulative loss in the first cell is the incremental loss in the first cell and
    * // the cumulative loss in the second cell is the incremental loss in the second cell
    * // plus the cumulative loss in the first cell
    *
    * // the third policy has a 0 value in the second and third development periods
    * // the second development period is not in the upper half of the triangle
    * // so the cumulative loss in that cell is 0
    * // the third development period is not in the upper half of the triangle either
    * // so the cumulative loss in that cell is 0
    * // the first cell in the third policy is in the upper half of the triangle and
    * // it is the only cell in the first column for that policy
    * // so the cumulative loss in that cell is the incremental loss in that cell
    *
    * cumulative_loss(incremental_loss, upper_half, n_rows, n_cols)
    * # returns [[1, 3, 6], [0, 5, 0], [7, 0, 0]]

    * incremental_loss = [[1, 2, 1, 2], [1, 0, 5, 0], [7, -2, 0, 0]]
    * upper_half = [[1, 1, 1, 1], [1, 1, 1, 0], [1, 1, 0, 0]]
    * n_rows = 3
    * n_cols = 4
    * // cumulative_loss(incremental_loss, upper_half, n_rows, n_cols)
    * // should return [[1, 3, 4, 6], [1, 1, 6, 0], [7, 5, 0, 0]]
    * // the first policy is all in the upper half of the triangle and
    * // the cumulative loss development triangle is taken normally, adding the incremental cell
    * // to the previous column's cumulative cell
    *
    * // the second policy has a 0 value in the first development period and
    * // it has a 0 value in the fourth development period
    * // the fourth development period is not in the upper half of the triangle
    * // so the cumulative loss in that cell is 0
    * // the first three cells in the second policy are in the upper half of the triangle 
    * // based on the 2nd row of the upper_half matrix: [1, 1, 1, 0]
    * // so the cumulative loss in the first cell is the incremental loss in the first cell and
    * // the cumulative loss in the second cell is the incremental loss in the second cell
    * // plus the cumulative loss in the first cell
    * // the cumulative loss in the third cell is the incremental loss in the third cell
    * // plus the cumulative loss in the second cell
    *
    * // the third policy has a negative value in the second development period and
    * // it has a 0 value in the third and fourth development periods
    * // the third development period is not in the upper half of the triangle
    * // so the cumulative loss in that cell is 0
    * // the fourth development period is not in the upper half of the triangle either
    * // so the cumulative loss in that cell is 0
    * // the first cell in the third policy is in the upper half of the triangle
    * // so the cumulative loss in that cell is the incremental loss in that cell
    * // the second cell in the third policy is in the upper half of the triangle
    * // so the cumulative loss in that cell is the incremental loss in that cell
    * // plus the cumulative loss in the first cell
    *
    * cumulative_loss(incremental_loss, upper_half, n_rows, n_cols)
    * # returns [[1, 3, 4, 6], [1, 1, 6, 0], [7, 5, 0, 0]]
    */
  matrix cumulative_loss(matrix incremental_loss, int[,] upper_half, int n_rows, int n_cols) {
    // test that the number of rows in incremental_loss is equal to n_rows
    if (rows(incremental_loss) != n_rows) {
      print("Number of rows in incremental_loss: ", rows(incremental_loss));
      print("n_rows: ", n_rows);
      reject("The number of rows in incremental_loss is not equal to `n_rows`");
    }

    // test that the number of columns in incremental_loss is equal to n_cols
    if (cols(incremental_loss) != n_cols) {
      print("Number of columns in incremental_loss: ", cols(incremental_loss));
      print("n_cols: ", n_cols);
      reject("The number of columns in incremental_loss is not equal to `n_cols`");
    }
    
    // test that the number of rows in upper_half is equal to n_rows
    if (rows(upper_half) != n_rows) {
      print("Number of rows in upper_half: ", rows(upper_half));
      print("n_rows: ", n_rows);
      reject("The number of rows in upper_half is not equal to `n_rows`");
    }

    // test that the number of columns in upper_half is equal to n_cols
    if (cols(upper_half) != n_cols) {
      print("Number of columns in upper_half: ", cols(upper_half));
      print("n_cols: ", n_cols);
      reject("The number of columns in upper_half is not equal to `n_cols`");
    }

    // test that the values in upper_half are either 0 or 1
    for (i in 1:n_rows) {
      for (j in 1:n_cols) {
        if (upper_half[i, j] != 0 && upper_half[i, j] != 1) {
          print("upper_half[", i, ", ", j, "]: ", upper_half[i, j]);
          reject("The values in upper_half must be either 0 or 1");
        }
      }
    }

    // create a matrix to hold the cumulative loss
    matrix[n_rows, n_cols] cum;

    // loop through the rows and columns of the matrix
    for (i in 1:n_rows) {
      for (j in 1:n_cols) {
        
        // if the cell is in the upper half of the triangle, calculate the cumulative loss
        if (upper_half[i, j] == 1){
          
          // if the cell is in the first column, the cumulative loss is just the incremental loss
          if (j == 1) {
            cum[i, j] = incremental_loss[i, j];
          } 

          // if the cell is not in the first column, the cumulative loss is the incremental loss
          // plus the cumulative loss in the previous column
          else {
            cum[i, j] = incremental_loss[i, j] + cum[i, j - 1];
          }
        } 
        
        // if the cell is not in the upper half of the triangle, the cumulative loss is 0
        else {
          cum[i, j] = 0;
        }
      }
    }

    return cum;
  }
  
  // function that takes a matrix and returns an adjusted matrix where each element is the log of the original element
  // if the original element is > 0, the log is taken
  // if the original element is <= 0, don't take the log, but just return 0 in that cell
  // if the original element is missing, don't take the log, but just return 0 in that cell
  /**
    * @title Take log of matrix
    * @description Takes the log of each element in a matrix.
    * If the element is > 0, the log is taken.
    * If the element is <= 0, don't take the log, but just return 0 in that cell.
    * If the element is missing, don't take the log, but just return 0 in that cell.
    * @param loss matrix to take log of
    * @param n_rows int number of rows in matrix
    * @param n_cols int number of columns in matrix
    *
    * @return matrix with each element taken on a log scale
    * @raise error if number of rows is not equal to number of rows in matrix
    * @raise error if number of columns is not equal to number of columns in matrix
    * @raise error before the function tries to take the log of a value <= 0
    *
    * @example
    * loss = [[1, 2, 3], [0, 5, 0], [7, 0, 0]]
    * n_rows = 3
    * n_cols = 3
    * // take_log(loss, n_rows, n_cols)
    * // should return [[0, 0.6931471805599453, 1.0986122886681098], [0, 1.6094379124341003, 0], [1.9459101490553132, 0, 0]]
    * // the first policy is NOT ADJUSTED because it does not have any missing values or any values equal to 0
    * // the second policy is adjusted IN THE FIRST AND THIRD CELLS because
    * // it has a 0 value in the first development period and
    * // it has a 0 value in the third development period
    * // the third policy is ADJUSTED in the 2nd and 3rd cells because those values are 0
    * 
    * take_log(loss, n_rows, n_cols)
    * # returns [[0, 0.6931471805599453, 1.0986122886681098], [0, 1.6094379124341003, 0], [1.9459101490553132, 0, 0]]
    */
    matrix take_log(matrix loss, int n_rows, int n_cols){
    // test that number of rows is equal to number of rows in loss matrix
    if (n_rows != rows(loss)){
      print("Number of rows passed: ", n_rows);
      print("Number of rows in loss matrix: ", rows(loss));
      reject("Number of rows is not equal to number of rows in `loss` matrix.");
    }

    // test that number of columns is equal to number of columns in loss matrix
    if (n_cols != cols(loss)){
      print("Number of columns passed: ", n_cols);
      print("Number of columns in loss matrix: ", cols(loss));
      reject("Number of columns is not equal to number of columns in `loss` matrix.");
    }

    // create a matrix to hold the log of the loss matrix
    matrix[n_rows, n_cols] log_loss;

    // loop through each cell in the loss matrix
    for (i in 1:n_rows){
      for (j in 1:n_cols){
        // if the cell is missing, set the corresponding cell in the log_loss matrix to 0
        if (is_nan(loss[i, j])){
          log_loss[i, j] = 0;
        }
        // if the cell is 0, set the corresponding cell in the log_loss matrix to 0
        else if (loss[i, j] == 0){
          log_loss[i, j] = 0;
        }
        // if the cell is > 0, take the log of the cell and set the corresponding cell in the log_loss matrix to the log
        else if (loss[i, j] > 0){
          log_loss[i, j] = log(loss[i, j]);
        }
      }
    }

    return log_loss;
  }

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
      }
    }
  }

  // function that combines the two above functions to return an adjusted loss development triangle
  // on a log scale
  /**
    * @title Adjust loss development triangle
    * @description Adjusts loss development triangle on a log scale
    * @param loss matrix with rows as policies and columns as development periods
    * @param n_policies int number of policies.
    * This should be the same as the number of rows in loss matrix.
    * @param n_development_periods int number of development periods.
    * This should be the same as the number of columns in loss matrix.
    *
    * @return matrix with rows as policies and columns as development periods
    * where each element is adjusted for 0's in the original loss development triangle
    * and then converted to a log scale, adjusting for remaining 0's
    * @raise error if number of policies is not equal to number of columns in
    * loss development triangle
    * @raise error if number of development periods is not equal to number of columns in
    * adjusted loss development triangle
    * @raise error before the function tries to take the log of a value <= 0
    */
  matrix log_adjusted_triangle(matrix loss, int n_policies, int n_development_periods){
      
    // create matrix to hold adjusted loss development triangle
    matrix[n_policies, n_development_periods] adjusted_loss_development_triangles;
  
    // adjust loss development triangle
    adjusted_loss_development_triangles = adjust_loss_development_triangle(loss, n_policies, n_development_periods);
  
    // convert adjusted loss development triangle to log scale
    adjusted_loss_development_triangles = log_loss_development_triangle(adjusted_loss_development_triangles, n_policies, n_development_periods);
  
    // return adjusted loss development triangle on a log scale
    return adjusted_loss_development_triangles;
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

  // indicator for whether the triangle is cumulative or not
  // 1 if cumulative, 0 if not
  int<lower=0, upper=1> cumulative;
}
transformed data {
  // adjusted reported & paid loss development triangles
  // adjusted to ensure that each cell in the triangle is >= $1
  // this is done by adding the difference between the cell and $1 to the next cell
  // then taking the log of each cell
  matrix log_adj_reported_loss[n_policies, n_development_periods] = 
  log_adjusted_triangle(reported_loss, n_policies, n_development_periods);
  matrix log_adj_paid_loss[n_policies, n_development_periods] =
  log_adjusted_triangle(paid_loss, n_policies, n_development_periods);
  
  
}

parameters{
  // all the parameters for the exposure time series model
  // the exposure time series model is a multivariate ARIMA model
  // the parameters are the coefficients for the ARIMA model
  vector arima_alpha[n_development_periods];
  vector arima_theta[n_development_periods];
  vector arima_epsilon[n_development_periods];




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
  
}