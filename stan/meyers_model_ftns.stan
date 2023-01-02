functions{
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
  *
  * @description Calculate the rho parameter for the given accident period.
  *
  * @param r_rho A real value representing the rho parameter for the previous accident period.
  *
  * @return A real value representing the rho parameter for the given accident period.
  */
  real calculate_rho(real r_rho){
    return -2*r_rho+1;
  }

  /**
  * @title Calculate the ultimate loss for each accident year in the given data.
  * 
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
}
