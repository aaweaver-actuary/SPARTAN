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