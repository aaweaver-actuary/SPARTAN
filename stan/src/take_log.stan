// function that takes a matrix and returns an adjusted matrix where each element is the log of the original element
    // if the original element is > 0, the log is taken
    // if the original element is <= 0, don't take the log, but just return 0 in that cell
    // if the original element is missing, don't take the log, but just return 0 in that cell
    /**
      * @title Take log of matrix
      * @description Takes the log of each element in a matrix.
      * If the element is > 0, the log is taken.
      * If the element is <= 0, don't take the log, but just return 0 in that cell.
      * If the element is missing, don't take the log, but just return 0 in that cell.
      * @param loss matrix to take log of
      * @param n_rows int number of rows in matrix
      * @param n_cols int number of columns in matrix
      *
      * @return matrix with each element taken on a log scale
      * @raise error if number of rows is not equal to number of rows in matrix
      * @raise error if number of columns is not equal to number of columns in matrix
      * @raise error before the function tries to take the log of a value <= 0
      *
      * @example
      * loss = [[1, 2, 3], [0, 5, 0], [7, 0, 0]]
      * n_rows = 3
      * n_cols = 3
      * // take_log(loss, n_rows, n_cols)
      * // should return [[0, 0.6931471805599453, 1.0986122886681098], [0, 1.6094379124341003, 0], [1.9459101490553132, 0, 0]]
      * // the first policy is NOT ADJUSTED because it does not have any missing values or any values equal to 0
      * // the second policy is adjusted IN THE FIRST AND THIRD CELLS because
      * // it has a 0 value in the first development period and
      * // it has a 0 value in the third development period
      * // the third policy is ADJUSTED in the 2nd and 3rd cells because those values are 0
      * 
      * take_log(loss, n_rows, n_cols)
      * # returns [[0, 0.6931471805599453, 1.0986122886681098], [0, 1.6094379124341003, 0], [1.9459101490553132, 0, 0]]
      */
      matrix take_log(matrix loss, int n_rows, int n_cols){
        // test that number of rows is equal to number of rows in loss matrix
        if (n_rows != rows(loss)){
          print("Number of rows passed: ", n_rows);
          print("Number of rows in loss matrix: ", rows(loss));
          reject("Number of rows is not equal to number of rows in `loss` matrix.");
        }

        // test that number of columns is equal to number of columns in loss matrix
        if (n_cols != cols(loss)){
          print("Number of columns passed: ", n_cols);
          print("Number of columns in loss matrix: ", cols(loss));
          reject("Number of columns is not equal to number of columns in `loss` matrix.");
        }

        // create a matrix to hold the log of the loss matrix
        matrix[n_rows, n_cols] log_loss;

        // loop through each cell in the loss matrix
        for (i in 1:n_rows){
          for (j in 1:n_cols){
            // if the cell is missing, set the corresponding cell in the log_loss matrix to 0
            if (is_nan(loss[i, j])){
              log_loss[i, j] = 0;
            }
            // if the cell is 0, set the corresponding cell in the log_loss matrix to 0
            else if (loss[i, j] == 0){
              log_loss[i, j] = 0;
            }
            // if the cell is > 0, take the log of the cell and set the corresponding cell in the log_loss matrix to the log
            else if (loss[i, j] > 0){
              log_loss[i, j] = log(loss[i, j]);
            }
          }
        }

        return log_loss;
    }
