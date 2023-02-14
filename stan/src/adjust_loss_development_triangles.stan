// function that takes a matrix with rows as policies and columns as development periods
    // starts at the right-hand side of the matrix and checks for the first value that is both non-missing and non-zero
    // from that point, it scans cell-by-cell to the left and checks for the first value that is 0
    // when it finds a 0 in a cell, it changes that cell to 1 and subtracts 1 from the cell to the right of it
    // this function is used to ensure that the loss development triangles can be taken on a log scale
    /**
      * @title Adjust loss development triangles
      * @description Adjusts loss development triangles to ensure that they can be taken
      * on a log scale. Basically looks for the first 0 in the upper half of the triangle
      * and adjusts the triangle so that the 0 is replaced by 1 and the cell to the right
      * of the 0 is reduced by 1. This way every cell in the upper half of the triangle
      * is non-zero and the triangle can be taken on a log scale.
      * @param loss matrix with rows as policies and columns as development periods
      * @param n_policies int number of policies
      * @param n_development_periods int number of development periods
      *
      * @return matrix with rows as policies and columns as development periods
      * where each element is adjusted to ensure that the loss development triangles can be taken on a log scale
      * @raise error if number of policies is not equal to number of rows in loss
      * @raise error if number of development periods is not equal to number of columns in loss
      *
      * @example
      * loss = [[1, 2, 3], [0, 5, 0], [7, 0, 0]]
      * n_policies = 3
      * n_development_periods = 3
      * // adjust_loss_development_triangles(loss, n_policies, n_development_periods)
      * // should return [[1, 2, 3], [1, 4, 0], [7, 0, 0]]
      * // the first policy is NOT ADJUSTED because it does not have any missing values
      * // the second policy is adjusted IN THE FIRST CELL ONLY because
      * // it has a missing value in the first development period and
      * // the first non-zero value is in the second development period
      * // the third policy is NOT ADJUSTED because it has missing values in
      * // the 2nd and 3rd development periods and
      * // the first non-zero value is in the 1st development period
      * 

      * adjust_loss_development_triangles(loss, n_policies, n_development_periods)
      * # returns [[1, 2, 3], [1, 4, 0], [7, 0, 0]]
      */

    matrix adjust_loss_development_triangles(matrix loss, int n_policies, int n_development_periods){
      // test that number of policies is equal to number of rows in loss matrix
      if (n_policies != rows(loss)){
        print("Number of policies passed: ", n_policies);
        print("Number of rows in loss matrix: ", rows(loss));
        error("Number of policies is not equal to number of rows in `loss` matrix.");
      }

      // test that number of development periods is equal to number of columns in loss matrix
      if (n_development_periods != cols(loss)){
        print("Number of development periods passed: ", n_development_periods);
        print("Number of columns in loss matrix: ", cols(loss));
        error("Number of development periods is not equal to number of columns in `loss` matrix.");
      }

      // initialize matrix to hold adjusted loss development triangles
      matrix[n_policies, n_development_periods] adjusted_loss_development_triangles;

      // loop over policies
      for (p in 1:n_policies){

        // initialize boolean to indicate whether policy has been adjusted
        int policy_adjusted = 0;

        // loop backwards over development periods
        for (d in n_development_periods:-1:1){

          // if policy has not been adjusted
          if (policy_adjusted == 0){

            // if policy has a missing value or a zero in the current development period
            // and the current development period is not the FIRST development period
            // don't adjust the cell for the current development period
            if ((is_missing(loss[p, d]) || loss[p, d] == 0) && d != 1){

              // set adjusted loss development triangle to the same value as the original loss development triangle
              adjusted_loss_development_triangles[p, d] = loss[p, d];
            }
            // otherwise, if policy has a non-missing and non-zero value in the current development period
            // and the current development period is not the FIRST development period
            // check to see that the cell immediately to the left of the current development period is non-zero
            // if it is non-zero, don't adjust the cell for the current development period
            // if it is zero, adjust the cell for the current development period
            else if (!is_missing(loss[p, d]) && loss[p, d] != 0 && d != 1){

              // if cell immediately to the left of the current development period is non-zero
              if (loss[p, d - 1] != 0){

                // set adjusted loss development triangle to the same value as the original loss development triangle
                adjusted_loss_development_triangles[p, d] = loss[p, d];
              }
              // otherwise, if cell immediately to the left of the current development period is zero
              else{

                // set adjusted loss development triangle to the same value as the original loss development triangle minus 1
                adjusted_loss_development_triangles[p, d] = loss[p, d] - 1;

                // set cell to the left to be 1
                adjusted_loss_development_triangles[p, d - 1] = 1;

                // set policy adjusted to 1
                policy_adjusted = 1;
              }
            }
            // otherwise, if policy has a non-missing and non-zero value in the FIRST development period
            // don't adjust the cell for the current development period
            else if (d == 1){

              // if policy has a missing value or a zero in the FIRST development period and the SECOND development period is non-zero
              // set first development period to 1 and second to be the same as the original second development period minus 1
              if ((is_missing(loss[p, d]) || loss[p, d] == 0) && loss[p, d + 1] != 0){

                // set adjusted loss development triangle to 1
                adjusted_loss_development_triangles[p, d] = 1;

                // set adjusted loss development triangle to the same value as the original loss development triangle minus 1
                adjusted_loss_development_triangles[p, d + 1] = loss[p, d + 1] - 1;

                // set policy adjusted to 1
                policy_adjusted = 1;
              }
              // otherwise, if policy has a non-missing and non-zero value in the FIRST development period
              // set adjusted loss development triangle to the same value as the original loss development triangle
              else{

                // set adjusted loss development triangle to the same value as the original loss development triangle
                adjusted_loss_development_triangles[p, d] = loss[p, d];
              }
            }
          }
          // otherwise, if policy has been adjusted
          else{

            // check to see that the cell immediately to the right of the current development period in the adjusted loss development triangle is 1
            // if it is 1, check to see that the cell in the original loss development triangle is non-zero
            // if so, set the cell in the adjusted loss development triangle to be the same as the cell in the original loss development triangle
            // if not, set the cell in the adjusted loss development triangle to be 1 as well
            if (adjusted_loss_development_triangles[p, d + 1] == 1){

              // if cell in original loss development triangle is non-zero
              if (loss[p, d + 1] != 0){
                // check if the current cell in the original triangle is zero
                if (loss[p, d] == 0){
                  // set adjusted loss development triangle to 1
                  adjusted_loss_development_triangles[p, d] = 1;

                  // set the cell to the right to be 1 less than the original cell
                  adjusted_loss_development_triangles[p, d + 1] = loss[p, d + 1] - 1;
                }
                else{
                  // set adjusted loss development triangle to the same value as the original loss development triangle
                  adjusted_loss_development_triangles[p, d] = loss[p, d];
                }
              }
              // otherwise, if cell to the right in original loss development triangle is zero
              else{
                // check whether the current cell in the original triangle is zero
                // if so, set the current cell in the adjusted triangle to 1 as well
                // if not, set the current cell in the adjusted triangle to be the same as the original cell
                if (loss[p, d] == 0){
                  // set adjusted loss development triangle to 1
                  adjusted_loss_development_triangles[p, d] = 1;
                }
                else{
                  // set adjusted loss development triangle to the same value as the original loss development triangle
                  adjusted_loss_development_triangles[p, d] = loss[p, d];
                }
              }
            }
          } 
        }
      }
    }
