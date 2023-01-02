functions {
// Include the functions from the "triangle_functions.stan" file
  #include triangle_functions.stan

 // Include the meyers_model_functions.stan file
  #include meyers_model_functions.stan

 // Include the loss_functions.stan file
  #include loss_functions.stan

  /**
  * Calculate the maximum value of a vector `maximize` for each group in a vector `group_by`.
  * For each group in `group_by`, find the maximum value of `maximize` in that group.
  * Then, for each group, find the value of `log_loss` that corresponds to
  * the maximum value of `maximize` in that group.
  * Return a matrix with `n_groups` rows with 3 columns:
  * the first column is the group_by value, the second column is the maximum value
  * of `maximize` in that group, and the third value is the exponentiated value of `log_loss`
  * that corresponds to the location of the group_by and maximize values for that group.
    * @param log_loss A vector of length `len_data` representing the log loss values.
    * @param len_data An integer representing the length of the input data.
    * @param group_by A vector of length `len_data` representing the group_by values.
    * @param n_groups An integer representing the number of groups.
    * @param maximize A vector of length `len_data` representing the maximize values.
    *
    * @return A matrix with `n_groups` rows with 3 columns:
    * the first column is the group_by value, the second column is the maximum value
    * of `maximize` in that group, and the third value is the exponentiated value of `log_loss`
    * that corresponds to the location of the group_by and maximize values for that group.
    */
  matrix max_log_loss_by_group(vector log_loss, int len_data, vector group_by, int n_groups, vector maximize){
    // test that the length of the input data is the same
    if (length(group_by) != length(log_loss)){
      print("There are ", length(group_by), " rows in the input vector `group_by`.");
      print("There are ", length(log_loss), " rows in the input vector `log_loss`.");
      reject("The length of the input vectors `group_by` and `log_loss` must be the same.");
    }

    // test that the length of log_loss and maximize are the same
    if (length(log_loss) != length(maximize)){
      print("There are ", length(log_loss), " rows in the input vector `log_loss`.");
      print("There are ", length(maximize), " rows in the input vector `maximize`.");
      reject("The length of the input vectors `log_loss` and `maximize` must be the same.");
    }

    // test that the length of log_loss equals len_data
    if (length(log_loss) != len_data){
      print("There are ", length(log_loss), " rows in the input vector `log_loss`.");
      print("The input integer `len_data` is ", len_data, ".");
      reject("The length of the input vector `log_loss` must be the same as the input integer `len_data`.");
    }

    // test that n_groups is greater than 0
    if (n_groups <= 0){
      print("The input integer `n_groups` is ", n_groups, ".");
      reject("The input integer `n_groups` must be greater than 0.");
    }

    // test that n_groups equals the number of unique values in group_by
    if (n_groups != length(unique(group_by))){
      print("The input integer `n_groups` is ", n_groups, ".");
      print("The number of unique values in the input vector `group_by` is ", length(unique(group_by)), ".");
      print("The unique values in the input vector `group_by` are ", unique(group_by), ".");
      reject("The input integer `n_groups` must be the same as the number of unique values in the input vector `group_by`.");
    }

    // test that there is at least one value in maximize for each unique group in group_by
    // consider group_by as a vector of categories rather than of numbers
    // for each category, filter maximize to only include values that correspond to that category
    // do not consider group_by as a vector of numbers but rather as a vector of the unique categories
    // then, check if the length of the filtered vector is greater than 0
    // if it is not, explain which category is the problem and reject
    // if it is, continue
    // initialize the current group
    int i;
    int cur_group;
    vector cur_maximize;
    for (i in 1:n_groups){
      // initialize the current group
      cur_group = i;

      // filter maximize to only include values that correspond to the current group
      cur_maximize = maximize[group_by == cur_group];

      // if the length of the filtered vector is 0, explain which category is the problem and reject
      if (length(cur_maximize) == 0){
        print("The number of unique values in the input vector `group_by` is ", length(unique(group_by)), ".");
        print("The unique values in the input vector `group_by` are ", unique(group_by), ".");
        print("The input integer `n_groups` is ", n_groups, ".");
        print("The input integer `n_groups` must be the same as the number of unique values in the input vector `group_by`.");
        print("The input vector `group_by` has a value of ", cur_group, " that does not correspond to any value in the input vector `maximize`.");
        reject("The input vector `group_by` must have at least one value in the input vector `maximize` for each unique value in the input vector `group_by`.");
      }
    }

    // initialize the output matrix
    matrix[n_groups, 3] out;

    // loop through the groups
    // initialize the current group, the current maximum value, and the current maximum value index
    int i;
    int j;
    int k;
    int cur_group;
    int cur_max;
    real cur_max_val;
    real cur_log_loss;

    // loop through the groups
    for (i in 1:n_groups){
      // initialize the current group, the current maximum value, and the current maximum value index
      cur_group = i;
      cur_max = 0;
      cur_max_val = -1e10;

      // loop through the data
      for (j in 1:len_data){

        // if the group_by value is the current group,
        // check if the maximize value is greater than the current maximum value
        if (group_by[j] == cur_group){

          // if it is, update the current maximum value and index
          if (maximize[j] > cur_max_val){
            cur_max = j;
            cur_max_val = maximize[j];
          }
        }
      }

      // after looping through the data, update the output matrix
      cur_log_loss = log_loss[cur_max];

      // first column is the group_by value
      out[i, 1] = cur_group;

      // second column is the maximum value of `maximize` in that group
      out[i, 2] = cur_max_val;

      // third column is the log value of `log_loss` that
      // corresponds to the location of the group_by and
      // maximize values for that group
      out[i, 3] = cur_log_loss;
    }

    // ensure out is sorted by the first column
    out = sort_asc(out);

    // return the output matrix
    return out;
  }

  // function that runs the `max_log_loss_by_group` function but only returns
  // a vector of the maximum `maximize` values for each group
  // should be of length `n_groups`

  /**
  * Return a vector of the maximum `maximize` values for each group
  * @param maximize A vector of length `len_data`.
  * @param group_by A vector of length `len_data`.
  * @param log_loss A vector of length `len_data`.
  * @param len_data An integer representing the length of the input vectors.
  * @param n_groups An integer representing the number of unique values in the input vector `group_by`.
  *
  * @return A vector of length `n_groups` representing the maximum `maximize` values for each group.
  */
  vector max_log_loss_by_group_maximize(vector maximize,
                                        vector group_by,
                                        vector log_loss,
                                        int len_data,
                                        int n_groups){
    // run the `max_log_loss_by_group` function
    matrix[n_groups, 3] out = max_log_loss_by_group(maximize,
                                                    group_by,
                                                    log_loss,
                                                    len_data,
                                                    n_groups);

    // initialize the output vector
    vector[n_groups] out_vec;

    // loop through the groups
    int i;
    for (i in 1:n_groups){
      // update the output vector
      out_vec[i] = out[i, 2];
    }
    return out_vec;
  }

 /**
  * Return the matrix (possibly with one row and/or one column)
  * that corresponds to the row from the matrix `lookup_table`
  * by matching the vector (possibly of length 1) from the `test_value` input
  * to a full row in the matrix `test_table`
  * @param lookup_table A matrix with `n_rows` rows and `n_cols` columns.
  * @param test_table A matrix with `n_rows` rows and `n_cols` columns.
  * @param test_value A vector of length `n_cols`.
  * @param n_rows An integer representing the number of rows in the input matrices.
  * @param n_cols An integer representing the number of columns in the input matrices.
  *
  * @return A matrix with `n_cols` rows and `n_row_match` columns representing all rows
  * from `lookup_table` that correspond to any
  * row from `test_table` that matches the `test_value` input.
  */
  matrix lookup_table_by_test_value(matrix lookup_table, matrix test_table, vector test_value, int n_rows, int n_cols){
    // test that the number of rows in the input matrices is the same
    if (rows(lookup_table) != rows(test_table)){
      print("There are ", rows(lookup_table), " rows in the input matrix `lookup_table`.");
      print("There are ", rows(test_table), " rows in the input matrix `test_table`.");
      reject("The number of rows in the input matrices `lookup_table` and `test_table` must be the same.");
    }

    // test that the number of columns in the input matrices is the same
    if (cols(lookup_table) != cols(test_table)){
      print("There are ", cols(lookup_table), " columns in the input matrix `lookup_table`.");
      print("There are ", cols(test_table), " columns in the input matrix `test_table`.");
      reject("The number of columns in the input matrices `lookup_table` and `test_table` must be the same.");
    }

    // test that `n_rows` and `n_cols` are the same as the number of rows and columns in the input matrices
    if (n_rows != rows(lookup_table)){
      print("There are ", rows(lookup_table), " rows in the input matrix `lookup_table`.");
      print("The input integer `n_rows` is ", n_rows, ".");
      reject("The input integer `n_rows` must be the same as the number of rows in the input matrices.");
    }
    if (n_cols != cols(lookup_table)){
      // print "There are ", cols(lookup_table), " columns in the input matrix `lookup_table`.
      // print "The input integer `n_cols` is ", n_cols, ".
      // then reject("The input integer `n_cols` must be the same as the number of columns in the input matrices.");

      print("There are ", cols(lookup_table), " columns in the input matrix `lookup_table`.");
      print("The input integer `n_cols` is ", n_cols, ".");
      reject("The input integer `n_cols` must be the same as the number of columns in the input matrices.");
    }

    // test that `test_value` is a vector of length `n_cols`
    if (size(test_value) != n_cols){
      print("The input vector `test_value` is a vector of length ", size(test_value), ".");
      print("The input integer `n_cols` is ", n_cols, ".");
      reject("The input vector `test_value` must be a vector of length `n_cols`.");
    }
    // initialize the output matrix without any rows
    // will need to update the number of rows after looping through the data
    matrix[n_rows, n_cols] out;

    // initialize the number of rows in the output matrix
    int n_row_match = 0;

    // initialize the current row
    int i;

    // loop through the rows
    for (i in 1:n_rows){
      // if the row from `test_table` matches the `test_value` input,
      // update the output matrix
      if (test_table[i] == test_value){
        n_row_match = n_row_match + 1;
        out[n_row_match] = lookup_table[i];
      }
    }

    // fill the output matrix with 0s in every column if the row index is 
    // greater than the n_row_match
    for (i in (n_row_match + 1):n_rows){
      out[i] = 0;
    }

    // return the output matrix
    return out[1:n_row_match];
  }
  
 /**
  * @brief A function that takes a loss vector, a lookup vector, and a test value and
  * returns the loss value that corresponds to where the lookup vector equals
  * the test value.
  *
  * @details The function calculates all the other parameters needed in this function:
  * `lookup_table_by_test_value(matrix lookup_table, matrix test_table, vector test_value, int n_rows, int n_cols)`
  * so that the user does not have to calculate them. `lookup_table_by_test_value` is called
  * as a helper function.
  *
  * @param loss_vector A vector of length `n_rows` representing the loss values.
  * @param lookup_vector A vector of length `n_rows` representing the lookup values.
  * @param test_value A scalar representing the test value.
  *
  * @return A vector of length `n_row_match` representing the loss values that
  * correspond to the test value.
  */  
  vector lookup_loss_by_test_value(vector loss_vector, vector lookup_vector, real test_value){
    // test that the number of elements in the input vectors is the same
    if (size(loss_vector) != size(lookup_vector)){
      print("There are ", size(loss_vector), " elements in the input vector `loss_vector`.");
      print("There are ", size(lookup_vector), " elements in the input vector `lookup_vector`.");
      reject("The number of elements in the input vectors `loss_vector` and `lookup_vector` must be the same.");
    }

    // test that `test_value` is a scalar and is not missing and is in the lookup vector
    if (size(test_value) != 1){
      print("The input scalar `test_value` is a vector of length ", size(test_value), ".");
      reject("The input scalar `test_value` must be a scalar.");
    }
    if (is_missing(test_value)){
      reject("The input scalar `test_value` must not be missing.");
    }
    if (!test_value in lookup_vector){
      print("The input scalar `test_value` is ", test_value, ".");
      print("The unique values in the input vector `lookup_vector` are ", unique(lookup_vector), ".");
      reject("The input scalar `test_value` must be in the input vector `lookup_vector`.");
    }

    // calculate the number of elements in the lookup_vector
    int n_rows = size(lookup_vector);

    // calculate the number of columns in the lookup table
    // this can be specified because the inputs are vectors
    int n_cols = 1;

    // calculate the test table
    matrix[n_rows, n_cols] test_table = rep_matrix(test_value, n_rows, n_cols);

    // calculate the lookup table
    matrix[n_rows, n_cols] lookup_table = rep_matrix(lookup_vector, n_rows, n_cols);

    // call the helper function
    matrix[n_rows, n_cols] out = lookup_table_by_test_value(lookup_table, test_table, test_value, n_rows, n_cols);

    // return only the loss column, not a matrix with all the columns
    return out[, 1];
  }

  /**
  * @brief A function that takes a premium vector, an accident period vector, and a development period vector
  * and returns a matrix of the premium values that correspond to the accident period and development period
  * combinations in sequential order. The accident period and development period vectors must be the same length.
  * Development periods 5 and above get filtered out. 
  *
  * @param premium A vector of length `n_rows` representing the premium values.
  * @param accident_period A vector of length `n_rows` representing the accident period values.
  * @param dev_period A vector of length `n_rows` representing the development period values.
  *
  * @return A matrix of size no larger than `n_rows` by 3 representing the premium values that
  * correspond to the accident period and development period combinations in sequential order.
  * The first column is the accident period, the second column is the development period,
  * and the third column is the premium value.
  * If there are development periods 5 and above, they are filtered out, and the matrix is returned with
  * fewer rows than `n_rows`.
  */
  matrix premium_by_accident_dev_period(vector premium, vector accident_period, vector dev_period){
    // test that the number of elements in the input vectors is the same
    if (size(premium) != size(accident_period)){
      print("There are ", size(premium), " elements in the input vector `premium`.");
      print("There are ", size(accident_period), " elements in the input vector `accident_period`.");
      reject("The number of elements in the input vectors `premium` and `accident_period` must be the same.");
    }
    if (size(premium) != size(dev_period)){
      print("There are ", size(premium), " elements in the input vector `premium`.");
      print("There are ", size(dev_period), " elements in the input vector `dev_period`.");
      reject("The number of elements in the input vectors `premium` and `dev_period` must be the same.");
    }

    // calculate the number of elements in the premium vector
    int n_rows = size(premium);

    // calculate the number of columns in the output matrix
    // this can be specified because the inputs are vectors and there are 3 of them
    int n_cols = 3;

    // calculate the output matrix
    matrix[n_rows, n_cols] out = rep_matrix(0, n_rows, n_cols);

    // calculate the accident period column
    out[, 1] = accident_period;

    // calculate the development period column
    out[, 2] = dev_period;

    // calculate the premium column
    out[, 3] = premium;

    // filter out the development periods 5 and above
    out = out[out[, 2] < 5];

    // sort the output matrix by accident period and development period
    out = sort_rows(out, 1);

    // return the output matrix
    return out;
  }

  /**
  * @brief A function that takes a matrix representing a premium time series and returns a new
  * matrix of the same size, but with the premium amounts converted from cumulative to incremental.
  * The first and second columns of the output matrix is the same as
  * the first and second columns of the input matrix.
  * The third column of the output matrix equals the third column of the input matrix if the 
  * development period is 1, and equals the difference between the third column of the input matrix
  * and the third column of the input matrix that has the same accident period but a development period
  * that is one less than the development period in the input matrix if the development period is 2 or greater.
  *
  * @param premium_time_series A matrix of size `n_rows` by 3 representing a premium time series.
  * The first column is the accident period, the second column is the development period,
  * and the third column is the cumulative premium value.
  *
  * @return A matrix of size `n_rows` by 3 representing a premium time series.
  * The first column is the accident period, the second column is the development period,
  * and the third column is the incremental premium value.
  */
  matrix premium_cumulative_to_incremental(matrix premium_time_series){
    // test that the number of columns in the input matrix is 3
    if (cols(premium_time_series) != 3){
      print("There are ", cols(premium_time_series), " columns in the input matrix `premium_time_series`.");
      reject("The input matrix `premium_time_series` must have 3 columns.");
    }

    // test that the second column of the input matrix is a vector of integers
    if (!is_integer(premium_time_series[, 2])){
      print("The second column of the input matrix `premium_time_series` is not a vector of integers.");
      reject("The second column of the input matrix `premium_time_series` must be a vector of integers.");
    }

    // test that the third column of the input matrix is a vector of positive numbers
    if (!is_positive(premium_time_series[, 3])){
      print("The third column of the input matrix `premium_time_series` is not a vector of positive numbers.");
      reject("The third column of the input matrix `premium_time_series` must be a vector of positive numbers.");
    }

    // calculate the number of rows in the input matrix
    int n_rows = rows(premium_time_series);

    // calculate the number of columns in the input matrix
    int n_cols = cols(premium_time_series);

    // calculate the output matrix
    matrix[n_rows, n_cols] out = rep_matrix(0, n_rows, n_cols);

    // calculate the accident period column
    out[, 1] = premium_time_series[, 1];

    // calculate the development period column
    out[, 2] = premium_time_series[, 2];

    // calculate the incremental premium column
    for (i in 1:n_rows){
      if (out[i, 2] == 1){
        out[i, 3] = premium_time_series[i, 3];
      } else {
        out[i, 3] = premium_time_series[i, 3] - premium_time_series[i - 1, 3];
      }
    }

    // raise an error if the incremental premium column contains any negative numbers,
    // and suggest that the user check the input matrix, as the premium may already 
    // be incremental
    if (!is_positive(out[, 3])){
      print("The third column of the output matrix `out` is not a vector of positive numbers");
      print("for the following rows of the input matrix `premium_time_series`:");
      for (i in 1:n_rows){
        if (out[i, 3] <= 0){
          print("w: ", premium_time_series[i, 1], ", d: ", premium_time_series[i, 2], ", p: ", out[i, 3]);
        }
      }
      reject("The third column of the output matrix `out` must be a vector of positive numbers.");
    }

    // otherwise, return the output matrix
    return out;
  }

  // function that simply takes, integer arrays w and d, and vector p as inputs and returns a matrix
  // with the same values

  /**
  * @brief A function that takes three arrays representing a premium time series and returns a matrix
  * of the same size, but with the premium amounts converted from cumulative to incremental.
  * Columns 1, 2, and 3 of the output come from w, d, p of the input, respectively.
  *
  * @param w An array of integers representing the accident period.
  * @param d An array of integers representing the development period.
  * @param p An array of positive numbers representing the cumulative premium value.
  *
  * @return An array of size `n_rows` by 3 representing a premium time series.
  * The first column is the integer for accident period.
  * The second column is the integer development period.
  * The third column is the positive real number for the cumulativepremium value.
  */
  matrix build_premium_table(int[] w, int[] d, vector p){
    // test that the length of the arrays w, d, and p are the same
    if (size(w) != size(d) || size(w) != size(p)){
      print("The lengths of the arrays `w`, `d`, and `p` are not the same.");
      print("w: ", size(w), ", d: ", size(d), ", p: ", size(p));
      reject("The lengths of the arrays `w`, `d`, and `p` must be the same.");
    }

    // test that the second column of the input matrix is a vector of integers
    if (!is_integer(d)){
      print("The second column of the input matrix `premium_time_series` is not a vector of integers.");
      reject("The second column of the input matrix `premium_time_series` must be a vector of integers.");
    }

    // test that the third column of the input matrix is a vector of positive numbers
    if (!is_positive(p)){
      print("The third column of the input matrix `premium_time_series` is not a vector of positive numbers.");
      print("The minimum value in the third column is: ", min(p), ".");
      reject("The third column of the input matrix `premium_time_series` must be a vector of positive numbers.");
    }

    // calculate the number of rows in the input matrix
    int n_rows = size(w);

    // calculate the output matrix
    matrix[n_rows, 3] out = rep_matrix(0, n_rows, 3);

    // calculate the accident period column
    out[, 1] = w;

    // calculate the development period column
    out[, 2] = d;

    // calculate the incremental premium column
    out[, 3] = p;

  }
}
data{
  // length of the arrays of loss data passed
  int<lower=1> len_data;
  
  // number of accident periods
  int<lower=1> n_w;
  
  // number of development periods
	int<lower=1> n_d;
  
  // array of length `len_data` with the log of the premium for each row in the table
  vector[len_data] log_prem;
  
  // array of length `n_w` with the log of the premium for each accident period
  // this is done as a convenience -- it is easier to manipulate data before putting it in
  // this modeling language
  // vector[n_w] log_prem_ay;
  
  // array of length `len_data` with the log of the cumulative paid loss for each row in the table
  vector[len_data] log_paid_loss;
  
  // array of length `len_data` with the log of the cumulative reported loss for each row in the table
  vector[len_data] log_rpt_loss;
  
  // array of length `n_w` with the log of the cumulative paid loss for each accident period
  // this is done as a convenience -- it is easier to manipulate data before putting it in
  // this modeling language
  // vector[n_w] log_paid_loss_ay;
  
  // array of length `n_w` with the log of the cumulative paid loss for each accident period
  // this is done as a convenience -- it is easier to manipulate data before putting it in
  // this modeling language
  // vector[n_w] log_rpt_loss_ay;
  
  // array of length `len_data` with the accident period index for each row in the table
  // these values range from 1 to `n_w`, with min accident period represented by 1
  // this is done so data manipulations inside this modelling language are simpler
  int<lower=1,upper=n_w> w[len_data];
  
  // array of length `len_data` with the development period index for each row in the table
  // these values range from 1 to `n_d`, with min development period represented by 1
  // this is done so data manipulations inside this modelling language are simpler
  int<lower=1,upper=n_d> d[len_data];
}
transformed data{
  // cumulative paid and reported loss for each data point
  vector[len_data] cum_paid_loss = exp(log_paid_loss);
  vector[len_data] cum_rpt_loss = exp(log_rpt_loss);

  // current development period for each accident period
  int<lower=1,upper=n_d> cur_d[n_w] = max_log_loss_by_group_maximize(cum_rpt_loss, len_data, w, n_w, d)[1];

  // use the `lookup_table_by_test_value` function to get the cumulative log paid loss for each accident period
  // testing that d = cur_d for each accident period
  vector[n_w] log_cum_paid_loss_ay = lookup_table_by_test_value(log_paid_loss, d, cur_d, n_w, 1)[1];
  vector[n_w] log_cum_rpt_loss_ay = lookup_table_by_test_value(log_rpt_loss, d, cur_d, n_w, 1)[1];

  // use the 
  // to calculate vector[n_w] log_prem_ay
  
}
parameters{
  // array of length `n_w` for the sample of normal draws used for the last `n_w - 1` alpha variables
  // the first alpha is set to 0
  vector[n_w] alpha_loss;
  
  // array of length `n_d` for the sample of normal draws used for the `n_d` paid beta variables
  vector[n_d] beta_paid_loss;
  
  // beta parameters for the reported loss pattern for each of the `n_d` development periods
  vector[n_d] beta_rpt_loss;
  
  // the expected loss ratio applied to each accident period  
  // drawn from normal(-0.4, sqrt(10))
  real logelr;
  
  // parameter that is used to get a lognormal sigma when simulating cumulative amounts
  // one for paid one for incurred
  // each is of length `n_d` and applies to each development period
  vector<lower=0,upper=100000>[n_d] a_p;
  vector<lower=0,upper=100000>[n_d] a_i;
  
  // parameter that controls the correlation between accident periods in the reported loss model
  real <lower=0,upper=1> r_rho;
  
  // parameter that controls the payment speedup/slowdown in the paid loss model
  real gamma;
}
transformed parameters{
  // This block contains transformations of the parameters introduced in the `parameters` block
  
  // parameter representing the year/year change in payment speed
  vector[n_w] speedup;
  
  // accident period correlation parameter
  real rho;
  
  // sigma parameters representing process variance, for each development period
  vector[n_d] sig_paid_loss;
  vector[n_d] sig_rpt_loss;
  
  // mu parameters for each row in the data that represent modelled estimated cumulative reported or paid
  // loss at the `w` and `d` corresponding to that row
  vector[len_data] mu_rpt_loss;
  vector[len_data] mu_paid_loss;
  
  
  // speedup parameter represents either the speedup or slowdown factor as paid / reported ratios
  // shift over time
  speedup = calculate_speedup(n_w, gamma);
  
  // non-squared versions of the sigma^2 parameters
  sig_rpt_loss = calculate_sig_loss(a_i, n_d);
  sig_paid_loss = calculate_sig_loss(a_p, n_d);
  
  // transformation to ensure rho is between -1 and +1
  rho = calculate_rho(r_rho);
  
  // development of the mu's: the expected cumulative loss on a log-scale for each row in the data
  mu_rpt_loss = calculate_mu_loss(0, len_data, w, d, log_prem, logelr, alpha_loss, beta_adj(n_d, beta_rpt_loss), speedup, rho, log_rpt_loss);
  mu_paid_loss = calculate_mu_loss(1, len_data, w, d, log_prem, logelr, alpha_loss, beta_adj(n_d, beta_paid_loss), speedup, rho, log_paid_loss);

}
model{
  // most of the parameters get relatively wide sigma values of 3.162, which is approximately equal to the
  // square root of 10. This is an arbitrary round number that is expected to be a bit higher than needed, but
  // stan enough freedom to actually fit the data rather than sticking too closely to these very 
  // weakly-informative prior estimates
  
  // raw alphas are normal with mean 0, variance 10
  alpha_loss ~ normal(0,3.162);
  
  // beta variables are normal with mean 0 variance 10
  // the first `n_d - 1` beta parameters for reported loss come from the draw in the parameters block
  beta_paid_loss[1:n_d] ~ normal(0,3.162);
  beta_rpt_loss[1:n_d] ~ normal(0,3.162);
  
  // the final loss beta parameter is 0 (indicating no further loss development outside the
  // triangle -- on a log scale, 0 is the same as an LDF of 1.000)
  // beta_rpt_loss[n_d] ~ uniform(-0.001, 0.001);
  // beta_paid_loss[n_d] ~ uniform(-0.001, 0.001);
  
  // process variance terms come from this inverse gamma distribution
  // they are then inverted to get something between 0 and 1
  a_p ~ inv_gamma(1,1);
  a_i ~ inv_gamma(1,1);
  
  // ELR is assumed to be lognormal with mu=67%, sigma^2=10
  logelr ~ normal(-.4,3.162);
  
  // paid loss settlement shift parameter is assumed normal, mu=0, sigma=0.05
  gamma ~ normal(0,0.05);
  
  // AY correlation parameter in the reported loss model is beta(a=2, b=2).
  r_rho ~ beta(2,2);

  // Modelling both cumulative paid and cumulative reported losses as lognormal random variables, where the
  // mu's are determined for each cell in the transformed parameters code block, and the sigmas (which represent 
  // the process variance) are also calculated in the transformed parameters block
  for (i in 1:len_data) {
    log_paid_loss[i] ~ normal(mu_paid_loss[i],sig_paid_loss[d[i]]);
    log_rpt_loss[i] ~ normal(mu_rpt_loss[i],sig_rpt_loss[d[i]]);
  }
}
generated quantities{
  // Initialize the vector that will store the estimated cumulative paid losses, and the estimated cumulative reported losses:
  vector[len_data] est_cum_paid_loss;
  vector[len_data] est_cum_rpt_loss;
  
  // Initialize the vector that will store the estimated ultimates
  vector[n_w] est_ult_loss;
  
  // Initialize real numbers for mean absolute error, mean squared error, and mean asymmetric error, for reported loss
  real mean_abs_error;
  real mean_squ_error;
  real mean_asym_error;
  
  // Loop through each accident period in the data.
  for (i in 1:len_data) {
    // Calculate the estimated cumulative paid losses for the current accident period.
    est_cum_paid_loss[i] = lognormal_rng(mu_paid_loss[i], sig_paid_loss[d[i]]);
	
	// Calculate the estimated cumulative reported losses for the current accident period.
    est_cum_rpt_loss[i] = lognormal_rng(mu_rpt_loss[i], sig_rpt_loss[d[i]]);
  }
    
  // generate estimates of ultimate by accident period
  // this is done by looping through each accident period, and calculating the ultimate loss for that accident period
  while(1){
    // create a matrix to store the ultimate loss parameters for each accident period
    matrix[n_w, 2] ul = calculate_ultimate_loss(n_w, n_d, log_prem_ay, logelr, alpha_loss, beta_adj(n_d, beta_rpt_loss), speedup, rho, log_rpt_loss_ay, sig_rpt_loss);
    
    // loop through each accident period
    for(i in 1:n_w){
      // generate the ultimate loss for the current accident period
      est_ult_loss[i] = lognormal_rng(
        // the mean of the lognormal distribution is the sum of the log of the ultimate loss parameters
        ul[i, 1],

        // the standard deviation of the lognormal distribution is the second element of the ultimate loss parameters
        ul[i, 2]
        );
    }
    // break out of the while loop
    break;
  }
  
  // generate mean absolute error
  mean_abs_error = mean_absolute_error(len_data, cum_rpt_loss, est_cum_rpt_loss);
  
  // generate mean squared error
  mean_squ_error = mean_squared_error(len_data, cum_rpt_loss, est_cum_rpt_loss);
  
  // generate mean asymmetric error
  mean_asym_error = mean_asymmetric_error(len_data, cum_rpt_loss, est_cum_rpt_loss);
}
