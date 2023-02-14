/**
    * @brief A function that takes three arrays representing a premium time series and returns a matrix
    * of the same size, but with the premium amounts converted from cumulative to incremental.
    * Columns 1, 2, and 3 of the output come from w, d, p of the input, respectively.
    *
    * @param w An array of integers representing the accident period.
    * @param d An array of integers representing the development period.
    * @param p An array of positive numbers representing the cumulative premium value.
    *
    * @return An array of size `n_rows` by 3 representing a premium time series.
    * The first column is the integer for accident period.
    * The second column is the integer development period.
    * The third column is the positive real number for the cumulativepremium value.
    */
    matrix build_premium_table(int[] w, int[] d, vector p){
      // test that the length of the arrays w, d, and p are the same
      if (size(w) != size(d) || size(w) != size(p)){
        print("The lengths of the arrays `w`, `d`, and `p` are not the same.");
        print("w: ", size(w), ", d: ", size(d), ", p: ", size(p));
        reject("The lengths of the arrays `w`, `d`, and `p` must be the same.");
      }

      // test that the second column of the input matrix is a vector of integers
      if (!is_integer(d)){
        print("The second column of the input matrix `premium_time_series` is not a vector of integers.");
        reject("The second column of the input matrix `premium_time_series` must be a vector of integers.");
      }

      // test that the third column of the input matrix is a vector of positive numbers
      if (!is_positive(p)){
        print("The third column of the input matrix `premium_time_series` is not a vector of positive numbers.");
        print("The minimum value in the third column is: ", min(p), ".");
        reject("The third column of the input matrix `premium_time_series` must be a vector of positive numbers.");
      }

      // calculate the number of rows in the input matrix
      int n_rows = size(w);

      // calculate the output matrix
      matrix[n_rows, 3] out = rep_matrix(0, n_rows, 3);

      // calculate the accident period column
      out[, 1] = w;

      // calculate the development period column
      out[, 2] = d;

      // calculate the incremental premium column
      out[, 3] = p;

      // return the output matrix
      return out;

    }
