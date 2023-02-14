/**
    functions written as part of the reinsurance model
    */

    // function that takes a matrix representing an incremental loss development triangle
    // and a matrix of 1's and 0's representing whether or not a cell is part of the upper half of the triangle
    // and returns a matrix representing a cumulative loss development triangle
    // starts with the first column of the incremental loss development triangle as
    // the first column of the cumulative loss development triangle
    // then loops through each column of the incremental loss development triangle
    // if the cell is part of the upper half of the triangle, add the incremental cell to the previous column's cumulative cell
    // if the cell is not part of the upper half of the triangle, set that cell to 0
    // rechecks the cumulative loss development triangle to ensure that there are no negative values in the upper half of the triangle
    // if there are negative values in the upper half of the triangle, it adjusts the cumulative loss development triangle, setting
    // the cell to 0 and subtracting 1 from the cell to the right of it, unless that would make the cell to the right of it negative
    // in that case just set the cell to 0
    /**
      * @title Incremental-to-Cumulative loss development triangle
      * @description Creates a cumulative loss development triangle from an incremental loss development triangle.
      * @param incremental_loss matrix representing an incremental loss development triangle
      * @param upper_half matrix of 1's and 0's representing whether or not a cell is part of the upper half of the triangle
      * @param n_rows int number of rows in matrix
      * @param n_cols int number of columns in matrix
      *
      * @return matrix representing a cumulative loss development triangle
      * @raise error if number of rows is not equal to number of rows in incremental_loss matrix
      * @raise error if number of columns is not equal to number of columns in incremental_loss matrix
      * @raise error if number of rows is not equal to number of rows in upper_half matrix
      * @raise error if number of columns is not equal to number of columns in upper_half matrix
      * @raise error if number of rows is not equal to number of rows in cumulative_loss matrix
      * @raise error if number of columns is not equal to number of columns in cumulative_loss matrix
      * @raise error if there are negative values in the upper half of the cumulative_loss matrix
      *
      * @example
      * incremental_loss = [[1, 2, 3], [0, 5, 0], [7, 0, 0]]
      * upper_half = [[1, 1, 1], [1, 1, 0], [1, 0, 0]]
      * n_rows = 3
      * n_cols = 3
      * // cumulative_loss(incremental_loss, upper_half, n_rows, n_cols)
      * // should return [[1, 3, 6], [0, 5, 0], [7, 0, 0]]  
      * // the first policy does not have any missing values or any values equal to 0 
      * // and all of the cells are (1) in the upper half of the triangle and (2) are positive
      * // so the cumulative loss development triangle is taken normally, adding the incremental cell
      * // to the previous column's cumulative cell
      *
      * // the second policy has a 0 value in the first development period and
      * // it has a 0 value in the third development period
      * // the third development period is not in the upper half of the triangle
      * // so the cumulative loss in that cell is 0
      * // the first two cells in the second policy are in the upper half of the triangle
      * // so the cumulative loss in the first cell is the incremental loss in the first cell and
      * // the cumulative loss in the second cell is the incremental loss in the second cell
      * // plus the cumulative loss in the first cell
      *
      * // the third policy has a 0 value in the second and third development periods
      * // the second development period is not in the upper half of the triangle
      * // so the cumulative loss in that cell is 0
      * // the third development period is not in the upper half of the triangle either
      * // so the cumulative loss in that cell is 0
      * // the first cell in the third policy is in the upper half of the triangle and
      * // it is the only cell in the first column for that policy
      * // so the cumulative loss in that cell is the incremental loss in that cell
      *
      * cumulative_loss(incremental_loss, upper_half, n_rows, n_cols)
      * # returns [[1, 3, 6], [0, 5, 0], [7, 0, 0]]

      * incremental_loss = [[1, 2, 1, 2], [1, 0, 5, 0], [7, -2, 0, 0]]
      * upper_half = [[1, 1, 1, 1], [1, 1, 1, 0], [1, 1, 0, 0]]
      * n_rows = 3
      * n_cols = 4
      * // cumulative_loss(incremental_loss, upper_half, n_rows, n_cols)
      * // should return [[1, 3, 4, 6], [1, 1, 6, 0], [7, 5, 0, 0]]
      * // the first policy is all in the upper half of the triangle and
      * // the cumulative loss development triangle is taken normally, adding the incremental cell
      * // to the previous column's cumulative cell
      *
      * // the second policy has a 0 value in the first development period and
      * // it has a 0 value in the fourth development period
      * // the fourth development period is not in the upper half of the triangle
      * // so the cumulative loss in that cell is 0
      * // the first three cells in the second policy are in the upper half of the triangle 
      * // based on the 2nd row of the upper_half matrix: [1, 1, 1, 0]
      * // so the cumulative loss in the first cell is the incremental loss in the first cell and
      * // the cumulative loss in the second cell is the incremental loss in the second cell
      * // plus the cumulative loss in the first cell
      * // the cumulative loss in the third cell is the incremental loss in the third cell
      * // plus the cumulative loss in the second cell
      *
      * // the third policy has a negative value in the second development period and
      * // it has a 0 value in the third and fourth development periods
      * // the third development period is not in the upper half of the triangle
      * // so the cumulative loss in that cell is 0
      * // the fourth development period is not in the upper half of the triangle either
      * // so the cumulative loss in that cell is 0
      * // the first cell in the third policy is in the upper half of the triangle
      * // so the cumulative loss in that cell is the incremental loss in that cell
      * // the second cell in the third policy is in the upper half of the triangle
      * // so the cumulative loss in that cell is the incremental loss in that cell
      * // plus the cumulative loss in the first cell
      *
      * cumulative_loss(incremental_loss, upper_half, n_rows, n_cols)
      * # returns [[1, 3, 4, 6], [1, 1, 6, 0], [7, 5, 0, 0]]
      */
    matrix cumulative_loss(matrix incremental_loss, int[,] upper_half, int n_rows, int n_cols) {
      // test that the number of rows in incremental_loss is equal to n_rows
      if (rows(incremental_loss) != n_rows) {
        print("Number of rows in incremental_loss: ", rows(incremental_loss));
        print("n_rows: ", n_rows);
        reject("The number of rows in incremental_loss is not equal to `n_rows`");
      }

      // test that the number of columns in incremental_loss is equal to n_cols
      if (cols(incremental_loss) != n_cols) {
        print("Number of columns in incremental_loss: ", cols(incremental_loss));
        print("n_cols: ", n_cols);
        reject("The number of columns in incremental_loss is not equal to `n_cols`");
      }
      
      // test that the number of rows in upper_half is equal to n_rows
      if (rows(upper_half) != n_rows) {
        print("Number of rows in upper_half: ", rows(upper_half));
        print("n_rows: ", n_rows);
        reject("The number of rows in upper_half is not equal to `n_rows`");
      }

      // test that the number of columns in upper_half is equal to n_cols
      if (cols(upper_half) != n_cols) {
        print("Number of columns in upper_half: ", cols(upper_half));
        print("n_cols: ", n_cols);
        reject("The number of columns in upper_half is not equal to `n_cols`");
      }

      // test that the values in upper_half are either 0 or 1
      for (i in 1:n_rows) {
        for (j in 1:n_cols) {
          if (upper_half[i, j] != 0 && upper_half[i, j] != 1) {
            print("upper_half[", i, ", ", j, "]: ", upper_half[i, j]);
            reject("The values in upper_half must be either 0 or 1");
          }
        }
      }

      // create a matrix to hold the cumulative loss
      matrix[n_rows, n_cols] cum;

      // loop through the rows and columns of the matrix
      for (i in 1:n_rows) {
        for (j in 1:n_cols) {
          
          // if the cell is in the upper half of the triangle, calculate the cumulative loss
          if (upper_half[i, j] == 1){
            
            // if the cell is in the first column, the cumulative loss is just the incremental loss
            if (j == 1) {
              cum[i, j] = incremental_loss[i, j];
            } 

            // if the cell is not in the first column, the cumulative loss is the incremental loss
            // plus the cumulative loss in the previous column
            else {
              cum[i, j] = incremental_loss[i, j] + cum[i, j - 1];
            }
          } 
          
          // if the cell is not in the upper half of the triangle, the cumulative loss is 0
          else {
            cum[i, j] = 0;
          }
        }
      }

      return cum;
    }
