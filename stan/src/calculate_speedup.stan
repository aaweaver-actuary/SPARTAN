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
