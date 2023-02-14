// function that runs the `max_log_loss_by_group` function but takes a matrix
    // of log loss values and returns a matrix of the maximum log loss values for each group
    // by running the `max_log_loss_by_group` function for each column of the input matrix
    // should be of dimensions `n_groups` by (`n_cols` + 2) for the group_by and maximize values

    /**
    * Return a matrix of the maximum log loss values for each group
    * by running the `max_log_loss_by_group` function for each column of the input matrix
    * @param maximize A vector of size `len_data`. This vector is common across
      all columns of the input matrix `log_loss`.
    * @param group_by A vector of size `len_data`. This vector is common across
      all columns of the input matrix `log_loss`.
    * @param log_loss A matrix with `len_data` rows and `n_cols` columns.
    * @param len_data An integer representing the number of rows in the input matrix `log_loss`.
    * @param n_cols An integer representing the number of columns in the input matrix `log_loss`.
    * @param n_groups An integer representing the number of unique values in the input vector `group_by`.
    *
    * @raise An error if the input integer `n_groups` is not the same as
      the number of unique values in the input vector `group_by`.
    * @return A matrix with `n_groups` rows and `n_cols` columns representing the maximum log loss values for each group.
    * @example
    *   maximize = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    *   group_by = [1, 1, 1, 2, 2, 2, 3, 3, 3, 3];
    *   log_loss = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    *               [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]];
    *   len_data = 10;
    *   n_cols = 2;
    *   n_groups = 3;
    *   max_log_loss_by_group_matrix(maximize, group_by, log_loss, len_data, n_cols, n_groups);
    *   // returns [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    *   //          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]]
    */
    matrix max_log_loss_by_group_matrix(vector maximize,
                                        vector group_by,
                                        matrix log_loss,
                                        int len_data,
                                        int n_cols,
                                        int n_groups){
      // initialize the output matrix
      matrix[n_groups, n_cols] out;

      // check that the input integer `n_groups` is the same as
      // the number of unique values in the input vector `group_by`
      if (n_groups != num_unique(group_by)){
        error("The input integer `n_groups` is not the same as the number of unique values in the input vector `group_by`.");
      }

      // loop through the columns of the input matrix
      int i;
      for (i in 1:n_cols){
        // run the `max_log_loss_by_group` function for each column
        matrix[n_groups, 3] out_col = max_log_loss_by_group(maximize,
                                                            group_by,
                                                            log_loss[, i],
                                                            len_data,
                                                            n_groups);

        // update the output matrix
        out[, i] = out_col[, 3];
      }
      return out;
    }