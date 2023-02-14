/**
    * @description Calculate the aggregated loss from a matrix of lower-level data
    * and a vector of the same number of rows as the matrix that represents the
    * group that each row belongs to.
    
    * Takes the loss matrix, sums each column according to the group vector,
    * and returns a matrix with the same number of columns as the input matrix
    * and one row for each unique group in the input vector.
    *
    * @param loss A matrix of size `n_rows` by `n_cols` representing loss data.
    * @param group A vector of length `n_rows` representing the group that each
    * row from the input matrix belongs to.
    * @param n_rows integer representing the number of rows in the input matrix.
    * @param n_cols integer representing the number of columns in the input matrix.
    * @param n_groups integer representing the number of unique groups in the input vector.
    *
    * @raises error if the number of rows in the input matrix is not equal to the
    * length of the input vector.
    *
    * @return A matrix of size `n_groups` by `n_cols` representing the loss data grouped by group.
    * @example
    * // loss data
    * matrix loss = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]];
    *
    * // group vector
    * vector group = [1, 1, 2, 2];
    *
    * // other parameters
    * int n_rows = 4;
    * int n_cols = 3;
    * int n_groups = 2;
    *
    * // grouped loss data
    * matrix grouped_loss = aggregated_loss(loss, group, n_rows, n_cols, n_groups);
    * # grouped_loss = [[5, 7, 9], [17, 19, 21]];
    */
    matrix aggregated_loss(matrix loss, vector group, int n_rows, int n_cols, int n_groups){
      // test that the number of rows in the input matrix is equal to the length of the input vector
      if (n_rows != size(group)){
        print("n_rows: ", n_rows);
        print("size(group): ", size(group));
        reject("The number of rows in the input matrix is not equal to the length of the input vector.");
      }

      // test that the number of unique elements in the group vector is equal to n_groups
      if (n_groups != size(unique(group))){
        print("n_groups: ", n_groups);
        print("size(unique(group)): ", size(unique(group)));
        reject("The number of unique elements in the group vector is not equal to n_groups.");
      }

      // test that the number of rows in the input matrix is equal to n_rows
      if (n_rows != rows(loss)){
        print("n_rows: ", n_rows);
        print("rows(loss): ", rows(loss));
        reject("The number of rows in the input matrix is not equal to n_rows.");
      }

      // test that the number of columns in the input matrix is equal to n_cols
      if (n_cols != cols(loss)){
        print("n_cols: ", n_cols);
        print("cols(loss): ", cols(loss));
        reject("The number of columns in the input matrix is not equal to n_cols.");
      }
      
      // calculate the output matrix
      // uses `rep_matrix`, which is a Stan function that takes a scalar,
      // a number of rows, and a number of columns, and returns a matrix
      // with the scalar repeated in each cell
      matrix[n_groups, n_cols] out = rep_matrix(0, n_groups, n_cols);

      // calculate the loss column
      for (i in 1:n_groups){
        // calculate the sum of the loss data in each column
        // of the input matrix that belongs to the same group
        out[i, ] = sum(loss[group == i, ]);
      }

      // return the output matrix
      return out;
    }
