functions {
  /**
    * @title Calendar Period
    * @description This function takes the number of accident periods and the number of development periods
    * and returns a matrix of size N_w x N_d, where the ijth element
    * is i + j - 1
    * @param N_w number of accident periods
    * @param N_d number of development periods
    * @return matrix of size N_w x N_d, where the ijth element
    * is i + j - 1
    * @examples
    * N_w <- 3
    * N_d <- 2
    * calendar_period(N_w, N_d)
    * @export
    */
  matrix calendar_period(int N_w, int N_d) {
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

  // function that takes the number of accident periods and the number of development periods and 
  // the current quarter and returns a matrix of size N_w x N_d, where the ijth element
  // is 1 if i + j <= N_w + current quarter and 0 otherwise

  // starts with extremely detailed documentation using roxygen2 syntax, including a title, description, and parametersn
  // as well as examples and return values
  /**
    * @title Calendar Period Indicator
    * @description This function takes the number of accident periods and the number of development periods and 
    * the current quarter and returns a matrix of size N_w x N_d, where the ijth element
    * is 1 if i + j <= N_w + current quarter and 0 otherwise
    * @param N_w number of accident periods
    * @param N_d number of development periods
    * @param current_quarter current quarter
    * @return matrix of size N_w x N_d, where the ijth element
    * is 1 if i + j <= N_w + current quarter and 0 otherwise
    * @examples
    * N_w <- 3
    * N_d <- 2
    * current_quarter <- 1
    * calendar_period_indicator(N_w, N_d, current_quarter)
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
  * mean_absolute_error(5, {100, 200, 300, 400, 500}, {90, 180, 270, 360, 450})
  * # returns 30
  */
  real mean_absolute_error(int len_data, vector y_true, vector y_pred) {
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
  real mean_asymmetric_error(int len_data, vector y_true, vector y_pred) {
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
  vector[n_w] log_prem_ay;
  
  // array of length `len_data` with the log of the cumulative paid loss for each row in the table
  vector[len_data] log_paid_loss;
  
  // array of length `len_data` with the log of the cumulative reported loss for each row in the table
  vector[len_data] log_rpt_loss;
  
  // array of length `n_w` with the log of the cumulative paid loss for each accident period
  // this is done as a convenience -- it is easier to manipulate data before putting it in
  // this modeling language
  vector[n_w] log_paid_loss_ay;
  
  // array of length `n_w` with the log of the cumulative paid loss for each accident period
  // this is done as a convenience -- it is easier to manipulate data before putting it in
  // this modeling language
  vector[n_w] log_rpt_loss_ay;
  
  // array of length `len_data` with the accident period index for each row in the table
  // these values range from 1 to `n_w`, with min accident period represented by 1
  // this is done so data manipulations inside this modelling language are simpler
  int<lower=1,upper=n_w> w[len_data];
  
  // array of length `len_data` with the development period index for each row in the table
  // these values range from 1 to `n_d`, with min development period represented by 1
  // this is done so data manipulations inside this modelling language are simpler
  int<lower=1,upper=n_d> d[len_data];
  
  // array of length `n_w` with the most recent development period index for each accident period in the table
  // these values range from 1 to `n_d`, with min development period represented by 1
  // this is done so data manipulations inside this modelling language are simpler
  int<lower=1,upper=n_d> cur_d[n_w];

}
transformed data{
  // cumulative paid and reported loss for each data point
  vector[len_data] cum_paid_loss = exp(log_paid_loss);
  vector[len_data] cum_rpt_loss = exp(log_rpt_loss);
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
