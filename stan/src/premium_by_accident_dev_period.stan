/**
    * @brief A function that takes a premium vector, an accident period vector, and a development period vector
    * and returns a matrix of the premium values that correspond to the accident period and development period
    * combinations in sequential order. The accident period and development period vectors must be the same length.
    * Development periods 5 and above get filtered out. 
    *
    * @param premium A vector of length `n_rows` representing the premium values.
    * @param accident_period A vector of length `n_rows` representing the accident period values.
    * @param dev_period A vector of length `n_rows` representing the development period values.
    *
    * @return A matrix of size no larger than `n_rows` by 3 representing the premium values that
    * correspond to the accident period and development period combinations in sequential order.
    * The first column is the accident period, the second column is the development period,
    * and the third column is the premium value.
    * If there are development periods 5 and above, they are filtered out, and the matrix is returned with
    * fewer rows than `n_rows`.
    */
    matrix premium_by_accident_dev_period(vector premium, vector accident_period, vector dev_period){
      // test that the number of elements in the input vectors is the same
      if (size(premium) != size(accident_period)){
        print("There are ", size(premium), " elements in the input vector `premium`.");
        print("There are ", size(accident_period), " elements in the input vector `accident_period`.");
        reject("The number of elements in the input vectors `premium` and `accident_period` must be the same.");
      }
      if (size(premium) != size(dev_period)){
        print("There are ", size(premium), " elements in the input vector `premium`.");
        print("There are ", size(dev_period), " elements in the input vector `dev_period`.");
        reject("The number of elements in the input vectors `premium` and `dev_period` must be the same.");
      }

      // calculate the number of elements in the premium vector
      int n_rows = size(premium);

      // calculate the number of columns in the output matrix
      // this can be specified because the inputs are vectors and there are 3 of them
      int n_cols = 3;

      // calculate the output matrix
      matrix[n_rows, n_cols] out = rep_matrix(0, n_rows, n_cols);

      // calculate the accident period column
      out[, 1] = accident_period;

      // calculate the development period column
      out[, 2] = dev_period;

      // calculate the premium column
      out[, 3] = premium;

      // filter out the development periods 5 and above
      out = out[out[, 2] < 5];

      // sort the output matrix by accident period and development period
      out = sort_rows(out, 1);

      // return the output matrix
      return out;
    }
