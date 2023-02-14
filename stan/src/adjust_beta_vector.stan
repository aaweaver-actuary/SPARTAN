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
      // test that N is a positive integer
      if (N <= 0) {
        print("`N`: ", N);
        reject("This must be a positive integer.");
      }

      // test that the input vector is not empty
      if (len(beta) == 0) {
        print("The length of beta is ", len(beta), "." );
        reject("The input vector cannot be empty.");
      }

      // test that `beta` is a vector of length N
      if (len(beta) != N) {
        print("The length of beta is ", len(beta), " and `N` is ", N, "." );
        reject("The input vector must be of length `N`.");
      }

      // Declare a vector of size N to store the adjusted values of beta
      vector[N] out;
    
      // Assign the values in beta to the out vector
      out = beta;
    
      // Add a value of 0 to the end of the out vector
      out[N]=0;
    
      // Return the adjusted values of beta
      return out;
    }