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
