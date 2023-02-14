functions{

  
    /**
          ===========================================================================================
          THIS DOES NOT WORK ========================================================================
          ===========================================================================================

    */
    /**
      * @title Calendar Period Indicator
      * @description This function takes the number of accident periods and the number of development periods and 
      * the current quarter and returns a matrix of size N_w x N_d, where the [w, d]-th element
      * is 1 if w + d <= N_w + current quarter and 0 otherwise
      * @param N_w number of accident periods
      * @param N_d number of development periods
      * @param current_quarter current quarter
      * @return matrix of size N_w x N_d, where the [w, d]-th element
      * is 1 if 12*w + 3*d <= (12*N_w) + (3*current_quarter) and 0 otherwise
      * @examples
      * calendar_period_indicator(5, 4, 1)
      * #>      [,1] [,2] [,3] [,4]
      * #> [1,]    1    1    1    1
      * #> [2,]    1    1    1    1
      * #> [3,]    1    1    1    1
      * #> [4,]    1    1    1    1
      * #> [5,]    1    1    1    1

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


    
  

    

    
    // ------------------------------------------------------------------------------------------------------------ IS THIS A DUPLICATE

    // // function that takes a matrix with rows as policies and columns as development periods
    // // and a vector of group assignments and returns a matrix with rows as groups and columns as development periods
    // // where each element is the sum of the corresponding development period across all policies in the group
    // /**
    //   * @title Sum development periods by group
    //   * @description Sums development periods by group
    //   * @param loss matrix with rows as policies and columns as development periods
    //   * @param groups vector vector of group assignments
    //   * @param n_groups int number of groups.
    //   * This should be the same as the number of unique values in groups vector.
    //   * @param n_development_periods int number of development periods.
    //   * This should be the same as the number of columns in loss matrix.
    //   *
    //   * @return matrix with rows as groups and columns as development periods
    //   * where each element is the sum of the corresponding development period
    //   * across all policies in the group
    //   * @raise error if number of groups is not equal to number of rows in loss
    //   * @raise error if number of development periods is not equal to number of columns in loss
    //   *
    //   * @example
    //   * loss = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    //   * groups = [1, 2, 1]
    //   * n_groups = 2
    //   * n_development_periods = 3
    //   * sum_development_periods_by_group(loss, groups, n_groups, n_development_periods)
    //   * # returns [[8, 10, 12], [4, 5, 6]]
    //   */
    // matrix sum_development_periods_by_group(matrix loss, vector groups, int n_groups, int n_development_periods){
    //   // test that number of groups is equal to number of unique values in groups vector, not the max value
    //   vector unique_groups = unique(groups);
    //   if (n_groups != size(unique_groups)){
    //     print("Number of groups passed: ", n_groups);
    //     print("Unique groups in the `groups` vector: ", unique_groups);
    //     print("Number of unique groups in the `groups` vector: ", size(unique_groups));
    //     error("Number of groups is not equal to number of unique values in `groups` vector.");
    //   }

    //   // test that number of development periods is equal to number of columns in loss matrix
    //   if (n_development_periods != cols(loss)){
    //     print("Number of development periods: ", n_development_periods);
    //     print("Number of columns in loss matrix: ", cols(loss));
    //     error("Number of development periods is not equal to number of columns in `loss` matrix.");
    //   }
      
    //   // number of groups
    //   int n_groups = max(groups);

    //   // number of development periods is the number of columns in loss
    //   int n_development_periods = cols(loss);

    //   // initialize matrix to hold sum of development periods by group
    //   matrix[n_groups, n_development_periods] sum_development_periods_by_group;

    //   // loop over groups
    //   for (g in 1:n_groups){

    //     // loop over development periods
    //     for (d in 1:n_development_periods){

    //       // initialize sum of development periods by group
    //       sum_development_periods_by_group[g, d] = 0;

    //       // loop over policies
    //       for (p in 1:rows(loss)){

    //         // if policy is in group
    //         if (groups[p] == g){

    //           // handle missing values:
    //           if (is_nan(loss[p, d])){
    //             // add a value of 0 to sum of development periods by group
    //             sum_development_periods_by_group[g, d] += 0;
    //           } 
    //           else {
    //             // add development period to sum of development periods by group
    //             // this is the same as summing the development period across all policies in the group
    //             sum_development_periods_by_group[g, d] += loss[p, d];
    //           }
    //         }
    //       }
    //     }
    //   }

    //   return sum_development_periods_by_group;
    // }

}
