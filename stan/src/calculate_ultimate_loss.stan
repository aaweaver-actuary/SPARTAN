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
