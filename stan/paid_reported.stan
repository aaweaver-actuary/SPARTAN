data{
  // length of the arrays of loss data passed
  int<lower=1> len_data;
  
  // number of accident periods, development periods
  int<lower=1> n_w;
  int<lower=1> n_d;
  
  // array of length `len_data` with the log of the premium, paid loss, and
  // reported loss for each row in the table
  vector[len_data] log_prem;

  // paid and reported loss are given as cumulative amounts:
  vector[len_data] paid_loss;
  vector[len_data] rpt_loss;
  
  // array of length `len_data` with the accident period index for each row in the table
  // these values range from 1 to `n_w`, with min accident period represented by 1
  int<lower=1,upper=n_w> w[len_data];
  
  // array of length `len_data` with the development period index for each row in the table
  // these values range from 1 to `n_d`, with min development period represented by 1
  int<lower=1,upper=n_d> d[len_data];

  // integer representing the number of development periods for each accident period
  int<lower=1, upper=12> num_dev_per_acc;
}
transformed data{
  // log cumulative paid and reported loss for each data point
  vector[len_data] log_paid_loss = log(paid_loss);
  vector[len_data] log_rpt_loss = log(rpt_loss);

  // calculate the incremental paid and reported losses
  vector[len_data] inc_paid_loss = cum_to_inc(len_data, n_w, n_d, paid_loss, w, d);
  vector[len_data] inc_rpt_loss = cum_to_inc(len_data, n_w, n_d, rpt_loss, w, d);

  // calculate the calendar period index
  vector[len_data] calendar_period_index = w .* num_dev_per_acc + d;

  // calculate the max calendar period index (eg the current calendar period)
  int current_calendar_period_index = max(calendar_period_index);

  // calculate the cumulative paid and reported losses by accident period
  vector[n_w] paid_loss_acc_prd = cumulative_loss_by_acc_prd(len_data, n_w, n_d, paid_loss, w, d);
  vector[n_w] rpt_loss_acc_prd = cumulative_loss_by_acc_prd(len_data, n_w, n_d, rpt_loss, w, d); 

  // current development period for each accident period
  int<lower=1,upper=n_d> cur_d[n_w] = current_dev_period_by_acc_prd(len_data, w, d);

  // log of the cumulative paid and reported losses by accident period
  vector[n_w] log_cum_paid_loss_ay = log(paid_loss_acc_prd);
  vector[n_w] log_cum_rpt_loss_ay = log(rpt_loss_acc_prd);

  // use the `premium_time_series` and `build_premium_table` functions
  // and `get_cumulative_premium` function to calculate vector[n_w] log_prem_ay
  // array of length `n_w` with the log of the premium for each accident period
  vector[n_w] log_prem_ay = get_cumulative_premium(build_premium_table(premium_time_series(log_prem, w, d, len_data, n_w, n_d), n_w, n_d), n_w, n_d)[, 3];

  // get the matrix of future data (for the generation of the predictive distribution)
  matrix[n_w * n_d - len_data, 3] future_data =  future_data(len_data, n_w, n_d, exposure, w, d);
  
}
parameters{
  // array of length `n_w` for the sample of normal draws used for the last `n_w - 1` alpha variables
  // the first alpha is set to 0
  vector[n_w] alpha_loss;
  
  // array of length `n_d` for the sample of normal draws used for the `n_d` paid beta variables
  vector[n_d] beta_paid_loss;
  
  // beta parameters for the reported loss pattern for each of the `n_d` development periods
  vector[n_d] beta_rpt_loss;

  // beta parameters for the paid / reported development pattern for each of the `n_d` development periods
  vector[n_d] beta_paid_rpt_dev;
  
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
  vector[len_data] mu_paid_rpt_ratio;

  // loss functions
  real mean_abs_error;
  real mean_square_error;
  
  
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

  // calculate the paid / reported ratio for each row in the data
  mu_paid_rpt_ratio = beta_adj(n_d, beta_paid_rpt_dev);

  // calculate both absolute and squared errors, as negatives for use in the objective function
  mean_abs_error = -mean_absolute_error(len_data * 2, log_rpt_loss + log_paid_loss, mu_rpt_loss + mu_paid_loss);
  mean_square_error = -mean_absolute_error(len_data * 2, log_rpt_loss + log_paid_loss, mu_rpt_loss + mu_paid_loss);
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
  beta_paid_rpt_dev[1:n_d] ~ normal(beta_paid_loss[1:n_d] / beta_rpt_loss[1:n_d], 3.162);
  
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
    log_paid_rpt_ratio[i] ~ normal(mu_paid_rpt_ratio[i], sqrt(power(sig_paid_loss[d[i]] / sig_rpt_loss[d[i]], 2)));
  }
}
generated quantities{
  // Initialize the vector that will store the estimated cumulative paid losses, and the estimated cumulative reported losses:
  vector[n_w * n_d] est_cum_paid_loss;
  vector[n_w * n_d] est_cum_rpt_loss;
  vector[n_w * n_d] d;
  vector[n_w * n_d] w;
  
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
  // mean_abs_error = mean_absolute_error(len_data, cum_rpt_loss, est_cum_rpt_loss);
  
  // generate mean squared error
  // mean_squ_error = mean_squared_error(len_data, cum_rpt_loss, est_cum_rpt_loss);
  
  // generate mean asymmetric error
  // mean_asym_error = mean_asymmetric_error(len_data, cum_rpt_loss, est_cum_rpt_loss);
}
