functions{
  // function to lookup a premium amount based on calendar year & quarter
  real inc_prem_lookup(int calendar_year, int calendar_quarter) {
    for (t in 1:n_time_periods) {
      if (calendar_year == calendar_year[t] && 
          calendar_quarter == calendar_quarter[t]) {
        return inc_prem[t];
      }
    }
    return -1.23456789;
  }

  // function to lookup an exogenous row vector based on calendar year & quarter
    vector data_lookup(int calendar_year, int calendar_quarter) {
        for (t in 1:n_time_periods) {
        if (calendar_year == calendar_year[t] && 
            calendar_quarter == calendar_quarter[t]) {
            return X[t];
        }
        }
        return -1.23456789;
    }

    // function to sum up the premium amounts for a given calendar year less than an input quarter
    
}


data {
  // number of time periods
  int<lower=1> n_time_periods;
  
  // quarterly premium amounts
  vector inc_prem[n_time_periods];

  // calendar year & quarter
  int<lower=1900, upper=2100> calendar_year[n_time_periods];
  int<lower=1, upper=4> calendar_quarter[n_time_periods];

  // current year & quarter
  int<lower=1900, upper=2100> current_year;
  int<lower=1, upper=4> current_quarter;
  
  // number of exogenous elements
  int<lower=0> n_exogenous_elements;

  // exogenous elements
  vector[n_exogenous_elements] X[n_time_periods];
  
  // number of business segments
  int<lower=1> num_segments;
  
  // business segment for each time period
  int segment[n_time_periods];
}

parameters {
  real alpha;                  // overall intercept term
  vector[M] beta[T];           // coefficients for exogenous elements
  real<lower=0> sigma;         // error standard deviation
  real<lower=0> phi;           // autoregressive coefficient
  real<lower=0> theta;         // moving average coefficient
  vector[4] gamma;             // quarterly seasonality coefficients
  vector[num_segments] alpha_segment;  // segment-specific intercept terms
  real<lower=0> sigma_segment;  // segment-specific error standard deviation
}

model {
  for (t in 5:T) {
    y[t] ~ normal(
      alpha + alpha_segment[segment[t]] + 
      dot_product(beta[t], x[t]) + 
      phi * (y[t-1] - gamma[(t-1) % 4 + 1]) + 
      theta * (y[t-1] - y[t-2]) - 
      theta * (y[t-3] - y[t-4]), 
      sigma_segment
