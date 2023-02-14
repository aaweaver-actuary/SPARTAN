/**
    * Return the matrix (possibly with one row and/or one column)
    * that corresponds to the row from the matrix `lookup_table`
    * by matching the vector (possibly of length 1) from the `test_value` input
    * to a full row in the matrix `test_table`
    * @param lookup_table A matrix with `n_rows` rows and `n_cols` columns.
    * @param test_table A matrix with `n_rows` rows and `n_cols` columns.
    * @param test_value A vector of length `n_cols`.
    * @param n_rows An integer representing the number of rows in the input matrices.
    * @param n_cols An integer representing the number of columns in the input matrices.
    *
    * @return A matrix with `n_cols` rows and `n_row_match` columns representing all rows
    * from `lookup_table` that correspond to any
    * row from `test_table` that matches the `test_value` input.
    */
    matrix lookup_table_by_test_value(matrix lookup_table, matrix test_table, vector test_value, int n_rows, int n_cols){
      // test that the number of rows in the input matrices is the same
      if (rows(lookup_table) != rows(test_table)){
        print("There are ", rows(lookup_table), " rows in the input matrix `lookup_table`.");
        print("There are ", rows(test_table), " rows in the input matrix `test_table`.");
        reject("The number of rows in the input matrices `lookup_table` and `test_table` must be the same.");
      }

      // test that the number of columns in the input matrices is the same
      if (cols(lookup_table) != cols(test_table)){
        print("There are ", cols(lookup_table), " columns in the input matrix `lookup_table`.");
        print("There are ", cols(test_table), " columns in the input matrix `test_table`.");
        reject("The number of columns in the input matrices `lookup_table` and `test_table` must be the same.");
      }

      // test that `n_rows` and `n_cols` are the same as the number of rows and columns in the input matrices
      if (n_rows != rows(lookup_table)){
        print("There are ", rows(lookup_table), " rows in the input matrix `lookup_table`.");
        print("The input integer `n_rows` is ", n_rows, ".");
        reject("The input integer `n_rows` must be the same as the number of rows in the input matrices.");
      }
      if (n_cols != cols(lookup_table)){
        // print "There are ", cols(lookup_table), " columns in the input matrix `lookup_table`.
        // print "The input integer `n_cols` is ", n_cols, ".
        // then reject("The input integer `n_cols` must be the same as the number of columns in the input matrices.");

        print("There are ", cols(lookup_table), " columns in the input matrix `lookup_table`.");
        print("The input integer `n_cols` is ", n_cols, ".");
        reject("The input integer `n_cols` must be the same as the number of columns in the input matrices.");
      }

      // test that `test_value` is a vector of length `n_cols`
      if (size(test_value) != n_cols){
        print("The input vector `test_value` is a vector of length ", size(test_value), ".");
        print("The input integer `n_cols` is ", n_cols, ".");
        reject("The input vector `test_value` must be a vector of length `n_cols`.");
      }
      // initialize the output matrix without any rows
      // will need to update the number of rows after looping through the data
      matrix[n_rows, n_cols] out;

      // initialize the number of rows in the output matrix
      int n_row_match = 0;

      // initialize the current row
      int i;

      // loop through the rows
      for (i in 1:n_rows){
        // if the row from `test_table` matches the `test_value` input,
        // update the output matrix
        if (test_table[i] == test_value){
          n_row_match = n_row_match + 1;
          out[n_row_match] = lookup_table[i];
        }
      }

      // fill the output matrix with 0s in every column if the row index is 
      // greater than the n_row_match
      for (i in (n_row_match + 1):n_rows){
        out[i] = 0;
      }

      // return the output matrix
      return out[1:n_row_match];
    }
