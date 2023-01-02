functions {
  // Include the functions from the "triangle_functions.stan" file
  #include triangle_functions.stan

 // Include the meyers_model_functions.stan file
  #include meyers_model_functions.stan

 // Include the loss_functions.stan file
  #include loss_functions.stan

 
  
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
