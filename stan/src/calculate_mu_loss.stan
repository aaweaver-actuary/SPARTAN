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
