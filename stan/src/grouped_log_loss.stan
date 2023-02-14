/**
    * @description A function that takes a matrix with log loss data with `n_l` columns and a vector of
    * length `n_l` representing the group that column `i` of the input matrix belongs to.
    * Takes the log loss matrix, exponetiates it, and returns a matrix with
    * 1. the same number of rows as the input matrix
    * 2. one column for each unique group in the input vector, and
    * 3. the sum of the exponential of the log loss data in each column
    * of the input matrix that belongs to the same group
    * 4. after summing up the rows, the function takes the log each cell in the output matrix.
    *
    * @param log_loss A matrix of size `n_rows` by `n_l` representing log loss data.
    * @param group A vector of length `n_l` representing the group that column `i` of the input matrix
    * belongs to.
    *
    * @raises `std::invalid_argument` if the number of rows in the input matrix is not equal to the
    * length of the input vector.
    *
    * @return A matrix of size `n_rows` by `n_groups` representing the log loss data grouped by group.
    * @example
    * // log loss data
    * matrix log_loss = [[-0.1, -0.2, -0.3], [-0.4, -0.5, -0.6]];
    *
    * // group vector
    * vector group = [1, 1, 2];
    *
    * // grouped log loss data
    * matrix grouped_log_loss = [[-0.1, -0.2], [-0.4, -0.5]];
    */
    matrix grouped_log_loss(matrix log_loss, vector group){
      // calculate the number of rows in the input matrix
      int n_rows = rows(log_loss);

      // calculate the number of unique groups in the input vector
      // by counting the number of unique elements in the group vector
      int n_groups = size(unique(group));

      // calculate the output matrix
      // uses `rep_matrix`, which is a Stan function that takes a scalar,
      // a number of rows, and a number of columns, and returns a matrix
      // with the scalar repeated in each cell
      matrix[n_rows, n_groups] out = rep_matrix(0, n_rows, n_groups);

      // calculate the log loss column
      for (i in 1:n_groups){
        // calculate the sum of the exponential of the log loss data in each column
        // of the input matrix that belongs to the same group
        // uses `log_sum_exp`, which is a Stan function that takes a vector
        // and returns the log of the sum of the exponential of
        // the elements in the vector
        out[, i] = log_sum_exp(log_loss[, group == i]);
      }

      // return the output matrix
      return out;
    }
