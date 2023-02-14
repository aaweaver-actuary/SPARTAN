// function that combines the two above functions to return an adjusted loss development triangle
    // on a log scale
    /**
      * @title Adjust loss development triangle
      * @description Adjusts loss development triangle on a log scale
      * @param loss matrix with rows as policies and columns as development periods
      * @param n_policies int number of policies.
      * This should be the same as the number of rows in loss matrix.
      * @param n_development_periods int number of development periods.
      * This should be the same as the number of columns in loss matrix.
      *
      * @return matrix with rows as policies and columns as development periods
      * where each element is adjusted for 0's in the original loss development triangle
      * and then converted to a log scale, adjusting for remaining 0's
      * @raise error if number of policies is not equal to number of columns in
      * loss development triangle
      * @raise error if number of development periods is not equal to number of columns in
      * adjusted loss development triangle
      * @raise error before the function tries to take the log of a value <= 0
      */
    matrix log_adjusted_triangle(matrix loss, int n_policies, int n_development_periods){
        
      // create matrix to hold adjusted loss development triangle
      matrix[n_policies, n_development_periods] adjusted_loss_development_triangles;
    
      // adjust loss development triangle
      adjusted_loss_development_triangles = adjust_loss_development_triangle(loss, n_policies, n_development_periods);
    
      // convert adjusted loss development triangle to log scale
      adjusted_loss_development_triangles = log_loss_development_triangle(adjusted_loss_development_triangles, n_policies, n_development_periods);
    
      // return adjusted loss development triangle on a log scale
      return adjusted_loss_development_triangles;
    }
