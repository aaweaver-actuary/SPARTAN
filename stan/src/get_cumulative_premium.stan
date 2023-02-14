/**
    * @brief A function that takes a matrix representing a premium time series and returns a matrix
    * with rows equal to the number of accident periods, and 3 columns: accident period, development
    * period, and cumulative premium.
    * For all prior accident periods, the cumulative premium is the premium amount at development
    * period 4.
    * For the current accident period, the cumulative premium is the premium amount at the largest 
    * development period in that accident period.
    * The number of rows in the output matrix is equal to the number of unique accident periods in the
    * input matrix.
    *
    * @param premium_time_series A matrix of size `n_rows` by 3 representing a premium time series.
    * The first column is the integer for accident period.
    * The second column is the integer development period.
    * The third column is the positive real number for the cumulative premium value.
    *
    * @return An array of size at most `n_rows` by 3 representing a premium time series.
    * The first column is the integer for accident period.
    * The second column is the integer development period.
    * The third column is the positive real number for the cumulative premium value.
    * The number of rows in the output matrix is equal to the number of
    * unique accident periods in the input matrix, so the output matrix may have fewer rows than the
    * input matrix.
    */
    matrix get_cumulative_premium(matrix premium_time_series){
      // calculate the number of rows in the input matrix
      int n_rows = rows(premium_time_series);

      // calculate the number of unique accident periods in the input matrix
      int n_w = max(premium_time_series[, 1]);

      // calculate the output matrix
      matrix[n_w, 3] out = rep_matrix(0, n_w, 3);

      // calculate the accident period column
      out[, 1] = 1:n_w;

      // calculate the development period column
      out[, 2] = 4;

      // when out[, 1] == n_w, the cumulative premium comes from the row with
      // the maximum value in the second column of the input matrix filtered by the first column
      // when out[, 1] < n_w, the cumulative premium comes from the row with
      // the value 4 in the second column of the input matrix filtered by the first column
      for (i in 1:n_w){
        if (i == n_w){
          // for the current year, the cumulative premium is the premium amount at the largest
          // development period in that accident period
          out[i, 3] = max(premium_time_series[premium_time_series[, 1] == i, 3]);
        } 
        else {
          // for all prior years, the cumulative premium is the premium amount at development period 4
          out[i, 3] = premium_time_series[premium_time_series[, 1] == i && premium_time_series[, 2] == 4, 3];
        }
      }

      // calculate the cumulative premium column
      for (i in 1:n_w){
        out[i, 3] = max(premium_time_series[premium_time_series[, 1] == i, 3]);
      }

      // return the output matrix
      return out;
    }
