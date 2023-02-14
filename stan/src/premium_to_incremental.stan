/**
    * @brief A function that takes an array representing a premium time series and returns a new
    * array of the same size, but with the premium amounts converted from cumulative to incremental.
    * The first and second columns of the output array is the same as
    * the first and second columns of the input array.
    * The third column of the output array equals the third column of the input array if the 
    * development period is 1, and equals the difference between the third column of the input array
    * and the third column of the input array that has the same accident period but a development period
    * that is one less than the development period in the input array if the development period is 2 or greater.
    *
    * @param premium_time_series A array of size `n_rows` by 3 representing a premium time series.
    * The first column is the accident period, the second column is the development period,
    * and the third column is the cumulative premium value.
    *
    * @return A array of size `n_rows` by 3 representing a premium time series.
    * The first column is the accident period, the second column is the development period,
    * and the third column is the incremental premium value.
    */
    array premium_to_incremental(array premium_time_series){
      // test that the accident period column of the input matrix is a vector of integers
      if (!is_integer(premium_time_series[, 1])){
        print("The accident period column of the input matrix `premium_time_series` is not a vector of integers.");
        print("The first 5 non-integer values are: ");
        int n_non_integer = 0;
        for (i in 1:size(premium_time_series[, 1])){
          if (!is_integer(premium_time_series[i, 1])){
            if (n_non_integer < 5){
              print("i: ", i, ", value: ", premium_time_series[i, 1], ", ", sep="");
            }
            n_non_integer = n_non_integer + 1;
          }
        }
        reject("The accident period column of the input matrix `premium_time_series` must be a vector of integers.");
      }

      // test that the development period column of the input matrix is a vector of integers
      if (!is_integer(premium_time_series[, 2])){
        print("The development period column of the input matrix `premium_time_series` is not a vector of integers.");
        print("The first 5 non-integer values are: ");
        int n_non_integer = 0;
        for (i in 1:size(premium_time_series[, 2])){
          if (!is_integer(premium_time_series[i, 2])){
            if (n_non_integer < 5){
              print("i: ", i, ", value: ", premium_time_series[i, 2], ", ", sep="");
            }
            n_non_integer = n_non_integer + 1;
          }
        }
        reject("The development period column of the input matrix `premium_time_series` must be a vector of integers.");
      }

      // test that the premium column of the input matrix is a vector of positive numbers
      if (!is_positive(premium_time_series[, 3])){
        print("The premium column of the input matrix `premium_time_series` is not a vector of positive numbers.");
        print("The minimum value in the premium column of the input matrix `premium_time_series` is ", min(premium_time_series[, 3]), ".");
        print("There are ", count(premium_time_series[, 3] < 0), " total negatives in the premium column of the input matrix `premium_time_series`. ");
        reject("The premium column of the input matrix `premium_time_series` must be a vector of positive numbers.");
      }

      // test that the number of columns in the input matrix is 3
      if (cols(premium_time_series) != 3){
        print("There are ", cols(premium_time_series), " columns in the input matrix `premium_time_series`.");
        reject("The input matrix `premium_time_series` must have 3 columns.");
      }

      // test that the second column of the input matrix is a vector of integers
      if (!is_integer(premium_time_series[, 2])){
        print("The second column of the input matrix `premium_time_series` is not a vector of integers.");
        reject("The second column of the input matrix `premium_time_series` must be a vector of integers.");
      }

      // test that the third column of the input matrix is a vector of positive numbers
      if (!is_positive(premium_time_series[, 3])){
        print("The third column of the input matrix `premium_time_series` is not a vector of positive numbers.");
        reject("The third column of the input matrix `premium_time_series` must be a vector of positive numbers.");
      }

      // calculate the number of rows in the input matrix
      int n_rows = rows(premium_time_series);

      // calculate the number of columns in the input matrix
      int n_cols = cols(premium_time_series);

      // calculate the output matrix
      matrix[n_rows, n_cols] out = rep_matrix(0, n_rows, n_cols);

      // calculate the accident period column
      out[, 1] = premium_time_series[, 1];

      // calculate the development period column
      out[, 2] = premium_time_series[, 2];

      // calculate the incremental premium column
      for (i in 1:n_rows){
        if (out[i, 2] == 1){
          out[i, 3] = premium_time_series[i, 3];
        } else {
          out[i, 3] = premium_time_series[i, 3] - premium_time_series[i - 1, 3];
        }
      }

      // raise an error if the incremental premium column contains any negative numbers,
      // and suggest that the user check the input matrix, as the premium may already 
      // be incremental
      if (!is_positive(out[, 3])){
        print("The third column of the output matrix `out` is not a vector of positive numbers");
        print("for the following rows of the input matrix `premium_time_series`:");
        for (i in 1:n_rows){
          if (out[i, 3] <= 0){
            print("w: ", premium_time_series[i, 1], ", d: ", premium_time_series[i, 2], ", p: ", out[i, 3]);
          }
        }
        reject("The third column of the output matrix `out` must be a vector of positive numbers.");
      }

      // otherwise, return the output matrix
      return out;
    }
