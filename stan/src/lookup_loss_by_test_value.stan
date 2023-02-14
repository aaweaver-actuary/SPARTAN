/**
    * @brief A function that takes a loss vector, a lookup vector, and a test value and
    * returns the loss value that corresponds to where the lookup vector equals
    * the test value.
    *
    * @details The function calculates all the other parameters needed in this function:
    * `lookup_table_by_test_value(matrix lookup_table, matrix test_table, vector test_value, int n_rows, int n_cols)`
    * so that the user does not have to calculate them. `lookup_table_by_test_value` is called
    * as a helper function.
    *
    * @param loss_vector A vector of length `n_rows` representing the loss values.
    * @param lookup_vector A vector of length `n_rows` representing the lookup values.
    * @param test_value A scalar representing the test value.
    *
    * @return A vector of length `n_row_match` representing the loss values that
    * correspond to the test value.
    */  
    vector lookup_loss_by_test_value(vector loss_vector, vector lookup_vector, real test_value){
      // test that the number of elements in the input vectors is the same
      if (size(loss_vector) != size(lookup_vector)){
        print("There are ", size(loss_vector), " elements in the input vector `loss_vector`.");
        print("There are ", size(lookup_vector), " elements in the input vector `lookup_vector`.");
        reject("The number of elements in the input vectors `loss_vector` and `lookup_vector` must be the same.");
      }

      // test that `test_value` is a scalar and is not missing and is in the lookup vector
      if (size(test_value) != 1){
        print("The input scalar `test_value` is a vector of length ", size(test_value), ".");
        reject("The input scalar `test_value` must be a scalar.");
      }
      if (is_missing(test_value)){
        reject("The input scalar `test_value` must not be missing.");
      }
      if (!test_value in lookup_vector){
        print("The input scalar `test_value` is ", test_value, ".");
        print("The unique values in the input vector `lookup_vector` are ", unique(lookup_vector), ".");
        reject("The input scalar `test_value` must be in the input vector `lookup_vector`.");
      }

      // calculate the number of elements in the lookup_vector
      int n_rows = size(lookup_vector);

      // calculate the number of columns in the lookup table
      // this can be specified because the inputs are vectors
      int n_cols = 1;

      // calculate the test table
      matrix[n_rows, n_cols] test_table = rep_matrix(test_value, n_rows, n_cols);

      // calculate the lookup table
      matrix[n_rows, n_cols] lookup_table = rep_matrix(lookup_vector, n_rows, n_cols);

      // call the helper function
      matrix[n_rows, n_cols] out = lookup_table_by_test_value(lookup_table, test_table, test_value, n_rows, n_cols);

      // return only the loss column, not a matrix with all the columns
      return out[, 1];
    }
