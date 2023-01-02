functions{
/**
  * Calculate the mean absolute error (MAE) for a set of observed and predicted losses. 
  * The MAE is defined as the average absolute difference between the predicted losses and the corresponding observed losses. 
  * It is used as a measure of how closely the model fits the data.
  * 
  * @param len_data An integer representing the number of data points.
  * @param y_true A vector of observed losses.
  * @param y_pred A vector of predicted losses.
  * 
  * @return The MAE value for the set of observed and predicted losses.
  * 
  * @examples
  * mean_absolute_error(2, {100, 200}, {90, 180})
  * # returns 20
  */
  real mean_absolute_error(int len_data, vector y_true, vector y_pred) {
    // test that the input vectors are the same length
    if (len(y_true) != len(y_pred)) {
      print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
      reject("The input vectors must be the same length.");
    }

    // test that `len_data` is the same as the length of the input vectors
    if (len_data != len(y_true)) {
      print("The length of y_true is ", len(y_true), " and the input length from `len_data` is ", len_data, "." );
      reject("These must be the same length.");
    }

    // test to see if `len_data` is a positive integer
    if (len_data <= 0) {
      print("`len_data`: ", len_data);
      reject("This must be a positive integer.");
    }

    // test to ensure that the input vectors are not empty and are not equal to each other
    if (len(y_true) == 0 || len(y_pred) == 0) {
      print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
      reject("The input vectors cannot be empty.");
    }
    if (y_true == y_pred) {
        print("y_true: ", y_true);
        print("y_pred: ", y_pred);
      reject("The input vectors cannot be equal.");
    }

    // Calculate the absolute difference between the two input vectors.
    vector[len_data] abs_errors = fabs(y_true - y_pred);

    // Return the mean of the absolute differences.
    return sum(abs_errors) / len_data;
  }

 /**
  * @title Mean Squared Error
  * @description Calculate the mean squared error (MSE) between the predicted losses and the actual losses.
  * 
  * The MSE is a common metric for evaluating the accuracy of a prediction. It is calculated by taking the average of the squared differences between the predicted values and the actual values. A lower MSE indicates a better fit between the predicted and actual values.
  * 
  * @param len_data An integer representing the number of data points.
  * @param y_pred A vector of predicted losses.
  * @param y_true A vector of actual losses.
  * @return The MSE between the predicted and actual losses.
  * 
  * @examples
  * mean_squared_error(3, [1, 2, 3], [1, 2, 3])
  * # returns 0
  * mean_squared_error(3, [1, 2, 3], [1, 2, 4])
  * # returns 0.33
  * mean_squared_error(3, [1, 2, 3], [0, 2, 3])
  * # returns 0.33
  */
  real mean_squared_error(int len_data, vector y_true, vector y_pred) {
    // test that the input vectors are the same length
    if (len(y_true) != len(y_pred)) {
      print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
      reject("The input vectors must be the same length.");
    }

    // test that `len_data` is the same as the length of the input vectors
    if (len_data != len(y_true)) {
      print("The length of y_true is ", len(y_true), " and the input length from `len_data` is ", len_data, "." );
      reject("These must be the same length.");
    }

    // test to see if `len_data` is a positive integer
    if (len_data <= 0) {
      print("`len_data`: ", len_data);
      reject("This must be a positive integer.");
    }

    // test to ensure that the input vectors are not empty and are not equal to each other
    if (len(y_true) == 0 || len(y_pred) == 0) {
      print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
      reject("The input vectors cannot be empty.");
    }
    if (y_true == y_pred) {
        print("y_true: ", y_true);
        print("y_pred: ", y_pred);
      reject("The input vectors cannot be equal.");
    }

    // Calculate the squared difference between the two input vectors.
    vector[len_data] squared_errors;
    for(i in 1:len_data){
      squared_errors[i] = (y_true[i] - y_pred[i]) ^ 2;  
    }
    // Return the mean of the squared differences.
    return sum(squared_errors) / len_data;
  }

 /**
  * Calculate the mean error between true values `y_true` and predicted values `y_pred`.
  * The error is calculated differently depending on whether the actual value is greater than or less than the predicted value.
  * Specifically, for each element in the input vectors:
  * - If the actual value is greater than the predicted value, the error is the squared difference between the actual and predicted values.
  * - If the actual value is less than the predicted value, the error is the absolute difference between the actual and predicted values.
  * The mean of the errors vector is then returned.
  * 
  * @param len_data An integer representing the length of the input data.
  * @param y_true A vector of true values.
  * @param y_pred A vector of predicted values.
  * 
  * @return A real value representing the mean error between `y_true` and `y_pred`.
  */
  real mean_asymmetric_error1(int len_data, vector y_true, vector y_pred) {
    // test that the input vectors are the same length
    if (len(y_true) != len(y_pred)) {
      print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
      reject("The input vectors must be the same length.");
    }

    // test that `len_data` is the same as the length of the input vectors
    if (len_data != len(y_true)) {
      print("The length of y_true is ", len(y_true), " and the input length from `len_data` is ", len_data, "." );
      reject("These must be the same length.");
    }

    // test to see if `len_data` is a positive integer
    if (len_data <= 0) {
      print("`len_data`: ", len_data);
      reject("This must be a positive integer.");
    }

    // test to ensure that the input vectors are not empty and are not equal to each other
    if (len(y_true) == 0 || len(y_pred) == 0) {
      print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
      reject("The input vectors cannot be empty.");
    }
    if (y_true == y_pred) {
        print("y_true: ", y_true);
        print("y_pred: ", y_pred);
      reject("The input vectors cannot be equal.");
    }


    // Initialize a vector of asymmetric errors with the same length as the input vectors.
    vector[len_data] asymmetric_errors;

    // Loop over each element in the input vectors and calculate the error.
    for (i in 1:len_data) {
      // If the actual value is greater than the predicted value, use the squared error.
      if (y_true[i] > y_pred[i]) {
        asymmetric_errors[i] = (y_true[i] - y_pred[i])^2;
      }
      // Otherwise, use the absolute error.
      else {
        asymmetric_errors[i] = fabs(y_true[i] - y_pred[i]);
      }
    }
    // Return the mean of the errors vector.
    return mean(asymmetric_errors);
  }

 /**
  * Calculate the mean error between true values `y_true` and predicted values `y_pred`.
  * Takes upside and downside inputs to calculate the error differently depending on whether the actual value is greater than or less than the predicted value.
  * The error is calculated differently depending on whether the actual value is greater than or less than the predicted value.
  * Specifically, for each element in the input vectors:
  * - If the actual value is greater than the predicted value, the error is calculated by the lambda function `upside`.
  * - If the actual value is less than the predicted value, the error is calculated by the lambda function `downside`.
  * The mean of the errors vector is then returned.
    * @param len_data An integer representing the length of the input data.
    * @param y_true A vector of true values.
    * @param y_pred A vector of predicted values.
    * @param upside A lambda function representing calculated error when the actual value is greater than the predicted value.
    * @param downside A lambda function representing calculated error when the actual value is greater than the predicted value.
    *
    * @return A real value representing the mean asymmetric error between `y_true` and `y_pred`.
    */
    real mean_asymmetric_error(int len_data, vector y_true, vector y_pred, real(^upside)(real, real), real(^downside)(real, real)) {
      // Initialize a vector of asymmetric errors with the same length as the input vectors.
      vector[len_data] asymmetric_errors;

      // Loop over each element in the input vectors and calculate the error.
      for (i in 1:len_data) {
        // If the actual value is greater than the predicted value, use the upside function.
        if (y_true[i] > y_pred[i]) {
          asymmetric_errors[i] = upside(y_true[i], y_pred[i]);
        }
        // Otherwise, use the downside function.
        else {
          asymmetric_errors[i] = downside(y_true[i], y_pred[i]);
        }
      }
      // Return the mean of the errors vector.
      return mean(asymmetric_errors);
    }

     /**
   * @title Adjust Beta Vector
   * @description Adjust the values in the `beta` vector by adding a value of 0 to the end.
   * 
   * This function is used to add a dummy value of 0 to the end of the `beta` vector, which is used as an input to other functions in the model. The added value of 0 is needed because the `beta` vector is used to calculate the `mu_loss` for each development quarter, and the number of development quarters can vary depending on the data. By adding a value of 0 to the end of the `beta` vector, this function ensures that the `mu_loss` can be calculated for the maximum number of development quarters, even if some accident years have fewer development quarters than the maximum.
   * 
   * @param N An integer indicating the maximum number of development quarters in the data.
   * @param beta A vector of beta parameters for each development quarter. Can be based on either paid or reported loss.
   * @return A vector of adjusted values for `beta`, with an additional value of 0 added to the end.
   * 
   * @examples
   * beta_adj(3, {0.1, 0.2, 0.3})
   * # returns {0.1, 0.2, 0.3, 0}
   * beta_adj(2, {0.4, 0.5})
   * # returns {0.4, 0.5, 0}
   */
  vector beta_adj(int N, vector beta){
    // test that N is a positive integer
    if (N <= 0) {
      print("`N`: ", N);
      reject("This must be a positive integer.");
    }

    // test that the input vector is not empty
    if (len(beta) == 0) {
      print("The length of beta is ", len(beta), "." );
      reject("The input vector cannot be empty.");
    }

    // test that `beta` is a vector of length N
    if (len(beta) != N) {
      print("The length of beta is ", len(beta), " and `N` is ", N, "." );
      reject("The input vector must be of length `N`.");
    }

    // Declare a vector of size N to store the adjusted values of beta
    vector[N] out;
  
    // Assign the values in beta to the out vector
    out = beta;
  
    // Add a value of 0 to the end of the out vector
    out[N]=0;
  
    // Return the adjusted values of beta
    return out;
  }
  
 /**
   * Calculate the `mu_loss` for each accident/development period. 
   * This is done by using a combination of the `beta_loss` parameter at the current development period, 
   * and a `speedup` correction term for either a speedup or slowdown in paid or reported loss relative to reported loss over time.
   * The calculated `mu_loss` is then used in the model to estimate the cumulative paid or reported losses for each accident period and development period.
   * 
   * @param is_paid_loss A binary variable indicating whether to calculate `mu_loss` for paid (1) or reported (0) loss.
   * @param len_data The number of data points.
   * @param w A vector of binary variables indicating whether an accident period is the first in a sequence of multiple accident periods (1) or not (0).
   * @param d A vector of development period indices for each accident period, indicating the number of development periods since the accident period.
   * @param log_prem A vector of logged premiums for each data point.
   * @param logelr A scalar value representing the logged expected loss ratio.
   * @param alpha_loss A vector of alpha parameters for each accident period. Does not depend on the choice of paid or reported loss.
   * @param beta_loss A vector of beta parameters for each development period. Can be based on either paid or reported loss.
   * @param speedup A vector of speedup correction terms for each accident period.
   * @param rho A scalar value representing the autocorrelation between reported loss at the current and previous accident period.
   * @param log_rpt_loss A vector of logged reported losses for each accident period.
   * 
   * @return A vector of calculated `mu_loss` values for each accident period.
   */
  vector calculate_mu_loss(int is_paid_loss, int len_data, int[] w, int[] d, vector log_prem, real logelr, vector alpha_loss, vector beta_loss, vector speedup, real rho, vector log_rpt_loss) {
      // test if `is_paid_loss` is a binary variable
        if (is_paid_loss != 0 && is_paid_loss != 1) {
            print("`is_paid_loss`: ", is_paid_loss);
            reject("This must be a binary variable.");
        }

        // test if `len_data` is a positive integer
        if (len_data <= 0) {
            print("`len_data`: ", len_data);
            reject("This must be a positive integer.");
        }

        // test if `w` is a vector of length `len_data`
        if (len(w) != len_data) {
            print("The length of `w` is ", len(w), " and `len_data` is ", len_data, "." );
            reject("The input vector must be of length `len_data`.");
        }

        // test if `w` is a vector of integers, not a vector of reals
        if (is_int(w) == 0) {
            print("`w`: ", w);
            reject("This must be a vector of integers.");
        }

        // test if `d` is a vector of length `len_data`
        if (len(d) != len_data) {
            print("The length of `d` is ", len(d), " and `len_data` is ", len_data, "." );
            reject("The input vector must be of length `len_data`.");
        }

        // test if `d` is a vector of integers, not a vector of reals
        if (is_int(d) == 0) {
            print("`d`: ", d);
            reject("This must be a vector of integers.");
        }

        // test if `log_prem` is a vector of length `len_data`
        if (len(log_prem) != len_data) {
            print("The length of `log_prem` is ", len(log_prem), " and `len_data` is ", len_data, "." );
            reject("The input vector must be of length `len_data`.");
        }

        // test if `log_prem` is a vector of reals, not a vector of integers
        if (is_real(log_prem) == 0) {
            print("`log_prem`: ", log_prem);
            reject("This must be a vector of reals.");
        }

        // test if `logelr` is a real number
        if (is_real(logelr) == 0) {
            print("`logelr`: ", logelr);
            reject("This must be a real number.");
        }

        // test if `alpha_loss` is a vector whose length equals the maximum value in the `w` vector 
        if (len(alpha_loss) != max(w)) {
            print("The length of `alpha_loss` is ", len(alpha_loss), " and the maximum value in `w` is ", max(w), "." );
            print("`alpha` parameters should be one per accident period.")
            reject("The input vector must be of length equal to the maximum value in `w`.");
        }

        // test if `beta_loss` is a vector whose length equals the maximum value in the `d` vector
        if (len(beta_loss) != max(d)) {
            print("The length of `beta_loss` is ", len(beta_loss), " and the maximum value in `d` is ", max(d), "." );
            print("`beta` parameters should be one per development period.")
            reject("The input vector must be of length equal to the maximum value in `d`.");
        }

        // test if `speedup` is a vector with one element per accident period
        if (len(speedup) != max(w)) {
            print("The length of `speedup` is ", len(speedup), " and the maximum value in `w` is ", max(w), "." );
            print("`speedup` parameters should be one per accident period.")
            reject("The input vector must be of length equal to the maximum value in `w`.");
        }

        // test if `rho` is a real number
        if (is_real(rho) == 0) {
            print("`rho`: ", rho);
            reject("This must be a real number.");
        }

        // test if `log_rpt_loss` is a vector of length `len_data`
        if (len(log_rpt_loss) != len_data) {
            print("The length of `log_rpt_loss` is ", len(log_rpt_loss), " and `len_data` is ", len_data, "." );
            reject("The input vector must be of length `len_data`.");
        }

        // test if `log_rpt_loss` is a vector of reals, not a vector of integers
        if (is_real(log_rpt_loss) == 0) {
            print("`log_rpt_loss`: ", log_rpt_loss);
            reject("This must be a vector of reals.");
        }

      // Initialize a vector to store the mu parameters for paid or reported loss.
      vector[len_data] mu_loss;
  
      // Loop through each accident period in the data.
      for (i in 1:len_data) {
        // Calculate the mu parameter for paid or reported loss at the current development period.
        if (is_paid_loss==1) {
          // Calculate the mu parameter for paid loss.
          mu_loss[i] = log_prem[i] + logelr + alpha_loss[w[i]] + (beta_adj(max(d), beta_loss)[d[i]] * speedup[w[i]]);
        } 
  	  else {
          // Calculate the mu parameter for reported loss.
          mu_loss[i] = log_prem[i] + logelr + beta_adj(max(d), beta_loss)[d[i]] + 
          
  		// if w==1, do not include the alpha parameter
          (w[i] == 1 ? 0 : alpha_loss[w[i]]) + 
          
  		// if w==1, will not be able to use autocorrelation with prior accident period
          (w[i] == 1 ? 0 : (rho * (log_rpt_loss[i-1] - mu_loss[i-1]))); 
      }
    }
  
    // Return the calculated mu parameters.
    return mu_loss;
  }
  
  /**
  * @title Calculate the `sig_loss` for each accident/development period. 
  * @description The `sig_loss` is the standard deviation of the log of
  * the ultimate loss distribution for each accident period. 
  * It is used to calculate the absolute, squared error, and
  * asymmetric loss functions for each accident/development period,
  * which are used to determine the minimum loss point estimate.
  * 
  * @param len_data The number of data points.
  * @param w A vector of binary variables indicating whether an accident period is
  the first in a sequence of multiple accident periods (1) or not (0).
  * @param log_ult_loss A vector of logged ultimate losses for each accident period.
  * @param prior_log_ult_loss A vector of logged ultimate losses for
  each prior accident period.
  * @param log_prem A vector of logged premiums for each data point.
  * @param logelr A scalar value representing the logged expected loss ratio.
  * @param alpha_loss A vector of alpha parameters for each accident period.
  Does not depend on the choice of paid or reported loss.
  * @param rho A scalar value representing the autocorrelation between
  logged ultimate loss at the current and previous accident period.
  * 
  * @return A vector of calculated `sig_loss` values, one for each accident period in the data.
  * 
  * @examples
  * calculate_sig_loss(5, {1, 0, 0, 0, 0}, {1.2, 1.3, 1.4, 1.5, 1.6}
  , {0, 1.2, 1.3, 1.4, 1.5}, {1, 2, 3, 4, 5}, 0.5, {0.1, 0.2, 0.3, 0.4, 0.5}, 0.6)
  * # returns {0.4, 0.3, 0.3, 0.3, 0.3}
  */
  vector calculate_sig_loss(vector a, int n_d) {
    // test if `a` is a vector with one element per development period
    if (len(a) != n_d) {
        print("The length of `a` is ", len(a), " and `n_d` is ", n_d, "." );
        print("`a` parameters should be one per development period.")
        reject("The input vector must be of length `n_d`.");
    }

    // test if `n_d` is an integer
    if (is_integer(n_d) == 0) {
        print("`n_d`: ", n_d);
        reject("This must be an integer.");
    }

    // Initialize the sig2_loss vector, which will store the sig2_loss values for each development period.
    vector[n_d] sig2_loss;
  
    // Initialize the sig_loss vector, which will store the square root of the sig2_loss values for each development period.
    vector[n_d] sig_loss;
  
    // Calculate the last sig2_loss for the current development period using the input a parameter.
    sig2_loss[n_d] = gamma_cdf(1/a[n_d],1,1);
	
    // Calculate the last sig_loss value in the vector
    sig_loss[n_d] = sqrt(sig2_loss[n_d]); 
  
    // Loop through each development period.
    for (i in 1:(n_d-1)) {
	  // Calculate the sig2_loss for the current development period using the input a parameter, and adding it to the previously-determined value
      sig2_loss[n_d - i] = sig2_loss[(n_d + 1) - i] + gamma_cdf(1/a[i],1,1);
    }
    
    for(i in 1:(n_d - 1)){
      // Calculate the sig_loss value as the square root of the sigma^2 value
      sig_loss[i] = sqrt(sig2_loss[i]);
    }
    
      // Return the sig_loss vector.
      return sig_loss;
    }

/**
  * @title Calculate the speedup terms for each accident period.
  * 
  * @description Calculate the speedup terms for each accident period.
  *
  * @param n_w An integer representing the number of accident periods.
  * @param gamma A real value representing the speedup parameter.
  *
  * @return A vector of length `n_w`, where `speedup[i]` is the speedup
  * correction term for the i-th accident period.
  */
  vector calculate_speedup(int n_w, real gamma){
    // test if `n_w` is an integer
    if (is_integer(n_w) == 0) {
      print("`n_w`: ", n_w);
      reject("This must be an integer.");
    }

    // test if `gamma` is a real value
    if (is_real(gamma) == 0) {
      print("`gamma`: ", gamma);
      reject("This must be a real value.");
    }

    // initialize a vector to store the speedup terms
    vector[n_w] speedup;

    // calculate the speedup terms
    // speedup parameter represents either the speedup or slowdown factor
    // as paid / reported ratios shift over time
    // speedup parameter starts at 1.000
    speedup[1] = 1;

    // for each subsequent accident period,
    // the speedup parameter gets multiplied by `(1 - gamma)`
    for (i in 2:(n_w)){
      speedup[i] = speedup[i-1] * (1 - gamma);
    }

    // return the speedup terms
    return speedup;
  }

  /**
  * @title Calculate the rho parameter for the given accident period.
  * @description Calculate the rho parameter for the given accident period.
  *
  * @param r_rho A real value representing the rho parameter for the previous accident period.
  *
  * @return A real value representing the rho parameter for the given accident period.
  * @examples
    * calculate_rho(0.5)
    * # returns 0.5
  */
  real calculate_rho(real r_rho){
    // test if `r_rho` is a real value
    if (is_real(r_rho) == 0) {
      print("`r_rho`: ", r_rho);
      reject("This must be a real value.");
    }

    return -2*r_rho+1;
  }

  /**
  * @title Calculate the ultimate loss for each accident year in the given data.
  * @description Calculate the ultimate loss for each accident year in the given data.
  *
  * @param n_w An integer representing the number of accident years in the data.
  * @param n_d An integer representing the number of development periods
  in each accident year.
  * @param log_prem_ay A vector of length `n_w`, where `log_prem_ay[i]` is
  the log of the premium for the most recent data point in the i-th accident year.
  * @param logelr The log of the ultimate loss ratio for all accident years.
  * @param alpha_loss A vector of length `n_w`, where `alpha_loss[i]` is
  the alpha parameter for the i-th accident year.
  * @param beta_rpt_loss A vector of beta parameters for each development period,
  based on reported loss.
  * @param speedup A vector of speedup correction terms for each accident period.
  * @param rho A scalar value representing the autocorrelation between
  reported loss at the current and previous accident period.
  * @param log_rpt_loss_ay A vector of length `n_w`, where `log_rpt_loss_ay[i]` is
  the log of the reported loss for the most recent data point in the i-th accident year.
  * @param sig_rpt_loss A vector of the standard deviation of reported loss
  for each development period.
  * 
  * @return A matrix of length `n_w`, where the i-th row represents
  the ultimate loss for the i-th accident year.
  The first column of the matrix represents the expected value and
  the second column represents the standard deviation.
  */
  matrix calculate_ultimate_loss(int n_w, int n_d, vector log_prem_ay, real logelr, vector alpha_loss, vector beta_rpt_loss, vector speedup, real rho, vector log_rpt_loss_ay, vector sig_rpt_loss) {
    // test if `n_w` is an integer
    if (is_integer(n_w) == 0) {
      print("`n_w`: ", n_w);
      reject("This must be an integer.");
    }

    // test if `n_d` is an integer
    if (is_integer(n_d) == 0) {
      print("`n_d`: ", n_d);
      reject("This must be an integer.");
    }

    // test if `log_prem_ay` is a vector of length `n_w`
    if (size(log_prem_ay) != n_w) {
      print("`size(log_prem_ay)`: ", size(log_prem_ay));
      print("`n_w`: ", n_w);
      reject("This must be a vector of length `n_w`.");
    }

    // test if `logelr` is a real value
    if (is_real(logelr) == 0) {
      print("`logelr`: ", logelr);
      reject("This must be a real value.");
    }

    // test if `alpha_loss` is a vector of length `n_w`
    if (size(alpha_loss) != n_w) {
      print("`size(alpha_loss)`: ", size(alpha_loss));
      print("`n_w`: ", n_w);
      reject("This must be a vector of length `n_w`.");
    }

    // test if `beta_rpt_loss` is a vector of length `n_d`
    if (size(beta_rpt_loss) != n_d) {
      print("`size(beta_rpt_loss)`: ", size(beta_rpt_loss));
      print("`n_d`: ", n_d);
      reject("This must be a vector of length `n_d`.");
    }

    // test if `speedup` is a vector of length `n_w`
    if (size(speedup) != n_w) {
      print("`size(speedup)`: ", size(speedup));
      print("`n_w`: ", n_w);
      reject("This must be a vector of length `n_w`.");
    }

    // test if `rho` is a real value
    if (is_real(rho) == 0) {
      print("`rho`: ", rho);
      reject("This must be a real value.");
    }

    // test if `log_rpt_loss_ay` is a vector of length `n_w`
    if (size(log_rpt_loss_ay) != n_w) {
      print("`size(log_rpt_loss_ay)`: ", size(log_rpt_loss_ay));
      print("`n_w`: ", n_w);
      reject("This must be a vector of length `n_w`.");
    }

    // test if `sig_rpt_loss` is a vector of length `n_d`
    if (size(sig_rpt_loss) != n_d) {
      print("`size(sig_rpt_loss)`: ", size(sig_rpt_loss));
      print("`n_d`: ", n_d);
      reject("This must be a vector of length `n_d`.");
    }

    // Initialize a vector to store the ultimate loss for each accident year.
    matrix[n_w, 2] ultimate_loss;
    
    // Initialize a vector to store the mu's for reported loss
    // for each accident year at the most recent valuation
    vector[n_w] rpt_loss_mu;
    
    // Initialize a vector to store accident period indices
    // and development period indices
    int w_ay[n_w];
    int d_ay[n_w];
    
    // Accident period indices are just 1, 2, ..., n_w
    // Development period indices are all n_d
    for(i in 1:n_w){
      w_ay[i] = i;
      d_ay[i] = n_d;
    }
    
    // get the reported loss mus
    rpt_loss_mu = calculate_mu_loss(0, n_w, w_ay, d_ay, log_prem_ay, logelr
    , alpha_loss, beta_adj(n_d, beta_rpt_loss), speedup, rho, log_rpt_loss_ay);
    
    // Loop through each accident year.
    for (i in 1:n_w) {
      // Calculate the ultimate loss for the current accident year.
      ultimate_loss[i, 1] = rpt_loss_mu[i];
      ultimate_loss[i, 2] = sig_rpt_loss[n_d];
    }
    
    // Return the calculated ultimate loss.
    return ultimate_loss;
  }

  /**
    * @title Calendar Period
    * @description This function takes the number of accident periods
    * and the number of development periods
    * and returns a matrix of size N_w x N_d, where the ijth element
    * is i + j - 1
    * @param N_w number of accident periods
    * @param N_d number of development periods
    * @return matrix of size N_w x N_d, where the ijth element
    * is i + j - 1
    * @examples
    * N_w <- 4
    * N_d <- 4
    * calendar_period(N_w, N_d)
    * #>      [,1] [,2] [,3] [,4]
    * #> [1,]    1    2    3    4
    * #> [2,]    2    3    4    5
    * #> [3,]    3    4    5    6
    * #> [4,]    4    5    6    7
    */
  matrix calendar_period(int N_w, int N_d) {
      // test if `N_w` is a positive integer
        if (is_positive_integer(N_w) == 0) {
            print("`N_w`: ", N_w);
            reject("This must be a positive integer.");
        }

        // test if `N_d` is a positive integer
        if (is_positive_integer(N_d) == 0) {
            print("`N_d`: ", N_d);
            reject("This must be a positive integer.");
        }


      // declare output matrix
      matrix[N_w, N_d] out;
      // fill in output matrix
      for (i in 1:N_w) {
          for (j in 1:N_d) {
              out[i, j] = i + j - 1;
          }
      }
      return out;
  }

  /**
        ===========================================================================================
        THIS DOES NOT WORK ========================================================================
        ===========================================================================================

  */
  /**
    * @title Calendar Period Indicator
    * @description This function takes the number of accident periods and the number of development periods and 
    * the current quarter and returns a matrix of size N_w x N_d, where the [w, d]-th element
    * is 1 if w + d <= N_w + current quarter and 0 otherwise
    * @param N_w number of accident periods
    * @param N_d number of development periods
    * @param current_quarter current quarter
    * @return matrix of size N_w x N_d, where the [w, d]-th element
    * is 1 if 12*w + 3*d <= (12*N_w) + (3*current_quarter) and 0 otherwise
    * @examples
    * calendar_period_indicator(5, 4, 1)
    * #>      [,1] [,2] [,3] [,4]
    * #> [1,]    1    1    1    1
    * #> [2,]    1    1    1    1
    * #> [3,]    1    1    1    1
    * #> [4,]    1    1    1    1
    * #> [5,]    1    1    1    1

    * @export
    */
  matrix calendar_period_indicator(int N_w, int N_d, int current_quarter) {
      // declare output matrix
      matrix[N_w, N_d] out;
      // fill in output matrix
      for (i in 1:N_w) {
          for (j in 1:N_d) {
            // if i + j <= N_w + current quarter, fill in 1
            // otherwise fill in 0
              if (i + j <= N_w + current_quarter) {
                  out[i, j] = 1;
              } else {
                  out[i, j] = 0;
              }
          }
      }
      return out;
  }

  /**
    * @title Loss Matrix
    * @description This function takes the number of accident periods and the number of development periods and
    * the number of data points, and a vector with loss values, and vectors with accident periods
    * and development periods, and returns a matrix of size N_w x N_d, where the ijth element
    * is the loss value in the loss vector associated with the ith accident period and jth development period
    * but only if the calendar period indicator is 1, and returns 0 otherwise
    * @param N_w number of accident periods
    * @param N_d number of development periods
    * @param N number of data points
    * @param loss vector of loss values
    * @param accident_period vector of accident periods
    * @param development_period vector of development periods
    * @param current_quarter current quarter
    * @return matrix of size N_w x N_d, where the ijth element
    * is the loss value in the loss vector associated with the ith accident period and jth development period
    * but only if the calendar period indicator is 1, and returns 0 otherwise
    * @examples
    * N_w <- 3
    * N_d <- 2
    * N <- 5
    * loss <- c(1, 2, 3, 4, 5)
    * accident_period <- c(1, 2, 3)
    * development_period <- c(1, 2)
    * current_quarter <- 1
    * calendar_period_loss(N_w, N_d, N, loss, accident_period, development_period, current_quarter)
    * @export
    */

  matrix calendar_period_loss(
      int N_w
      , int N_d
      , int N
      , vector loss
      , vector accident_period
      , vector development_period
      , int current_quarter) {
      // declare output matrix
      matrix[N_w, N_d] out;
      // fill in output matrix
      for (i in 1:N_w) {
          for (j in 1:N_d) {
              // if the calendar period indicator is 1 fill in the loss value
              if (calendar_period_indicator[N_w, N_d, current_quarter][i, j] == 1) {
                  out[i, j] = loss[accident_period[i] + development_period[j] - 1];
              } 
              // otherwise fill in 0
              else {
                  out[i, j] = 0;
              }
          }
      }
      return out;
  }

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

  // function that runs the `max_log_loss_by_group` function but takes a matrix
  // of log loss values and returns a matrix of the maximum log loss values for each group
  // by running the `max_log_loss_by_group` function for each column of the input matrix
  // should be of dimensions `n_groups` by (`n_cols` + 2) for the group_by and maximize values

  /**
  * Return a matrix of the maximum log loss values for each group
  * by running the `max_log_loss_by_group` function for each column of the input matrix
  * @param maximize A vector of size `len_data`. This vector is common across
    all columns of the input matrix `log_loss`.
  * @param group_by A vector of size `len_data`. This vector is common across
    all columns of the input matrix `log_loss`.
  * @param log_loss A matrix with `len_data` rows and `n_cols` columns.
  * @param len_data An integer representing the number of rows in the input matrix `log_loss`.
  * @param n_cols An integer representing the number of columns in the input matrix `log_loss`.
  * @param n_groups An integer representing the number of unique values in the input vector `group_by`.
  *
  * @raise An error if the input integer `n_groups` is not the same as
    the number of unique values in the input vector `group_by`.
  * @return A matrix with `n_groups` rows and `n_cols` columns representing the maximum log loss values for each group.
  * @example
  *   maximize = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  *   group_by = [1, 1, 1, 2, 2, 2, 3, 3, 3, 3];
  *   log_loss = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  *               [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]];
  *   len_data = 10;
  *   n_cols = 2;
  *   n_groups = 3;
  *   max_log_loss_by_group_matrix(maximize, group_by, log_loss, len_data, n_cols, n_groups);
  *   // returns [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  *   //          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]]
  */
  matrix max_log_loss_by_group_matrix(vector maximize,
                                      vector group_by,
                                      matrix log_loss,
                                      int len_data,
                                      int n_cols,
                                      int n_groups){
    // initialize the output matrix
    matrix[n_groups, n_cols] out;

    // check that the input integer `n_groups` is the same as
    // the number of unique values in the input vector `group_by`
    if (n_groups != num_unique(group_by)){
      error("The input integer `n_groups` is not the same as the number of unique values in the input vector `group_by`.");
    }

    // loop through the columns of the input matrix
    int i;
    for (i in 1:n_cols){
      // run the `max_log_loss_by_group` function for each column
      matrix[n_groups, 3] out_col = max_log_loss_by_group(maximize,
                                                          group_by,
                                                          log_loss[, i],
                                                          len_data,
                                                          n_groups);

      // update the output matrix
      out[, i] = out_col[, 3];
    }
    return out;
  }
  */

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

  // function to calculate the elastic net regularization penalty
  // l1l2_mix is the mixing parameter, lambda is the regularization parameter, 
  // and beta is the vector of coefficients

  /**
  * @brief A function that takes a mixing parameter, a regularization parameter, and a vector of coefficients
  * and returns the elastic net regularization penalty.
  *
  * @param l1l2_mix A scalar representing the mixing parameter. Must be between 0 and 1.
  * A value of 0 corresponds to L2 regularization, and a value of 1 corresponds to L1 regularization.
  * @param lambda A scalar representing the regularization parameter. Must be greater than 0.
  * Larger values of lambda correspond to more regularization.
  * @param beta A vector of length greater than 0 representing the vector of coefficients.
  *
  * @return A scalar representing the elastic net regularization penalty.
  */
  real elastic_net_penalty(real l1l2_mix, real lambda, vector beta){
    // test that the input scalar l1l2_mix is between 0 and 1
    if (l1l2_mix < 0){
      print("The input scalar `l1l2_mix` is ", l1l2_mix, ".");
      reject("The input scalar `l1l2_mix` must be greater than or equal to 0.");
    }
    if (l1l2_mix > 1){
      print("The input scalar `l1l2_mix` is ", l1l2_mix, ".");
      reject("The input scalar `l1l2_mix` must be less than or equal to 1.");
    }

    // test that the input scalar lambda is greater than 0
    if (lambda <= 0){
      print("The input scalar `lambda` is ", lambda, ".");
      reject("The input scalar `lambda` must be greater than 0.");
    }

    // test that the input vector beta is not empty
    if (size(beta) == 0){
      reject("The input vector `beta` must not be empty.");
    }

    // calculate the L1 penalty
    real l1_penalty = sum(abs(beta));

    // calculate the L2 penalty
    real l2_penalty = sum(square(beta));

    // calculate the elastic net penalty
    real penalty = l1l2_mix * l1_penalty + (1 - l1l2_mix) * l2_penalty;

    // return the elastic net penalty
    return lambda * penalty;
  }


  /**
  * @brief A function that takes an array representing a premium time series and returns a new
  * array of the same size, but with the premium amounts converted from cumulative to incremental.
  * The first and second columns of the output array is the same as
  * the first and second columns of the input array.
  * The third column of the output array equals the third column of the input array if the 
  * development period is 1, and equals the difference between the third column of the input array
  * and the third column of the input array that has the same accident period but a development period
  * that is one less than the development period in the input array if the development period is 2 or greater.
  *
  * @param premium_time_series A array of size `n_rows` by 3 representing a premium time series.
  * The first column is the accident period, the second column is the development period,
  * and the third column is the cumulative premium value.
  *
  * @return A array of size `n_rows` by 3 representing a premium time series.
  * The first column is the accident period, the second column is the development period,
  * and the third column is the incremental premium value.
  */
  array premium_to_incremental(array premium_time_series){
    // test that the accident period column of the input matrix is a vector of integers
    if (!is_integer(premium_time_series[, 1])){
      print("The accident period column of the input matrix `premium_time_series` is not a vector of integers.");
      print("The first 5 non-integer values are: ");
      int n_non_integer = 0;
      for (i in 1:size(premium_time_series[, 1])){
        if (!is_integer(premium_time_series[i, 1])){
          if (n_non_integer < 5){
            print("i: ", i, ", value: ", premium_time_series[i, 1], ", ", sep="");
          }
          n_non_integer = n_non_integer + 1;
        }
      }
      reject("The accident period column of the input matrix `premium_time_series` must be a vector of integers.");
    }

    // test that the development period column of the input matrix is a vector of integers
    if (!is_integer(premium_time_series[, 2])){
      print("The development period column of the input matrix `premium_time_series` is not a vector of integers.");
      print("The first 5 non-integer values are: ");
      int n_non_integer = 0;
      for (i in 1:size(premium_time_series[, 2])){
        if (!is_integer(premium_time_series[i, 2])){
          if (n_non_integer < 5){
            print("i: ", i, ", value: ", premium_time_series[i, 2], ", ", sep="");
          }
          n_non_integer = n_non_integer + 1;
        }
      }
      reject("The development period column of the input matrix `premium_time_series` must be a vector of integers.");
    }

    // test that the premium column of the input matrix is a vector of positive numbers
    if (!is_positive(premium_time_series[, 3])){
      print("The premium column of the input matrix `premium_time_series` is not a vector of positive numbers.");
      print("The minimum value in the premium column of the input matrix `premium_time_series` is ", min(premium_time_series[, 3]), ".");
      print("There are ", count(premium_time_series[, 3] < 0), " total negatives in the premium column of the input matrix `premium_time_series`. ");
      reject("The premium column of the input matrix `premium_time_series` must be a vector of positive numbers.");
    }

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

    // return the output matrix
    return out;

  }

 /**
  * @brief A function that takes a matrix representing a premium time series and returns a matrix
  * with rows equal to the number of accident periods, and 3 columns: accident period, development
  * period, and cumulative premium.
  * For all prior accident periods, the cumulative premium is the premium amount at development
  * period 4.
  * For the current accident period, the cumulative premium is the premium amount at the largest 
  * development period in that accident period.
  * The number of rows in the output matrix is equal to the number of unique accident periods in the
  * input matrix.
  *
  * @param premium_time_series A matrix of size `n_rows` by 3 representing a premium time series.
  * The first column is the integer for accident period.
  * The second column is the integer development period.
  * The third column is the positive real number for the cumulative premium value.
  *
  * @return An array of size at most `n_rows` by 3 representing a premium time series.
  * The first column is the integer for accident period.
  * The second column is the integer development period.
  * The third column is the positive real number for the cumulative premium value.
  * The number of rows in the output matrix is equal to the number of
  * unique accident periods in the input matrix, so the output matrix may have fewer rows than the
  * input matrix.
  */
  matrix get_cumulative_premium(matrix premium_time_series){
    // calculate the number of rows in the input matrix
    int n_rows = rows(premium_time_series);

    // calculate the number of unique accident periods in the input matrix
    int n_w = max(premium_time_series[, 1]);

    // calculate the output matrix
    matrix[n_w, 3] out = rep_matrix(0, n_w, 3);

    // calculate the accident period column
    out[, 1] = 1:n_w;

    // calculate the development period column
    out[, 2] = 4;

    // when out[, 1] == n_w, the cumulative premium comes from the row with
    // the maximum value in the second column of the input matrix filtered by the first column
    // when out[, 1] < n_w, the cumulative premium comes from the row with
    // the value 4 in the second column of the input matrix filtered by the first column
    for (i in 1:n_w){
      if (i == n_w){
        // for the current year, the cumulative premium is the premium amount at the largest
        // development period in that accident period
        out[i, 3] = max(premium_time_series[premium_time_series[, 1] == i, 3]);
      } 
      else {
        // for all prior years, the cumulative premium is the premium amount at development period 4
        out[i, 3] = premium_time_series[premium_time_series[, 1] == i && premium_time_series[, 2] == 4, 3];
      }
    }

    // calculate the cumulative premium column
    for (i in 1:n_w){
      out[i, 3] = max(premium_time_series[premium_time_series[, 1] == i, 3]);
    }

    // return the output matrix
    return out;
  }

  /** function that takes:
  1. a matrix with log loss data with `n_l` columns
  2. a vector of length `n_l` representing the group that column `i` of the input matrix belongs to

  takes the log loss matrix, exponetiates it, and returns a matrix with
  1. the same number of rows as the input matrix
  2. one column for each unique group in the input vector, and
  3. the sum of the exponential of the log loss data in each column
  of the input matrix that belongs to the same group
  4. after summing up the rows, the function takes the log each cell in the output matrix
 */

 /**
  * @brief A function that takes a matrix with log loss data with `n_l` columns and a vector of
  * length `n_l` representing the group that column `i` of the input matrix belongs to.
  * Takes the log loss matrix, exponetiates it, and returns a matrix with
  * 1. the same number of rows as the input matrix
  * 2. one column for each unique group in the input vector, and
  * 3. the sum of the exponential of the log loss data in each column
  * of the input matrix that belongs to the same group
  * 4. after summing up the rows, the function takes the log each cell in the output matrix.
  *
  * @param log_loss A matrix of size `n_rows` by `n_l` representing log loss data.
  * @param group A vector of length `n_l` representing the group that column `i` of the input matrix
  * belongs to.
  *
  * @raises `std::invalid_argument` if the number of rows in the input matrix is not equal to the
  * length of the input vector.
  *
  * @return A matrix of size `n_rows` by `n_groups` representing the log loss data grouped by group.
  * @example
  * // log loss data
  * matrix log_loss = [[-0.1, -0.2, -0.3], [-0.4, -0.5, -0.6]];
  *
  * // group vector
  * vector group = [1, 1, 2];
  *
  * // grouped log loss data
  * matrix grouped_log_loss = [[-0.1, -0.2], [-0.4, -0.5]];
  */
  matrix grouped_log_loss(matrix log_loss, vector group){
    // calculate the number of rows in the input matrix
    int n_rows = rows(log_loss);

    // calculate the number of unique groups in the input vector
    // by counting the number of unique elements in the group vector
    int n_groups = size(unique(group));

    // calculate the output matrix
    // uses `rep_matrix`, which is a Stan function that takes a scalar,
    // a number of rows, and a number of columns, and returns a matrix
    // with the scalar repeated in each cell
    matrix[n_rows, n_groups] out = rep_matrix(0, n_rows, n_groups);

    // calculate the log loss column
    for (i in 1:n_groups){
      // calculate the sum of the exponential of the log loss data in each column
      // of the input matrix that belongs to the same group
      // uses `log_sum_exp`, which is a Stan function that takes a vector
      // and returns the log of the sum of the exponential of
      // the elements in the vector
      out[, i] = log_sum_exp(log_loss[, group == i]);
    }

    // return the output matrix
    return out;
  }
}
