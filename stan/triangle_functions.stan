functions{

/**
    * @title Calendar Period
    * @description This function takes the number of accident periods and the number of development periods
    * and returns a matrix of size N_w x N_d, where the ijth element
    * is i + j - 1
    * @param N_w number of accident periods
    * @param N_d number of development periods
    * @return matrix of size N_w x N_d, where the ijth element
    * is i + j - 1
    * @examples
    * N_w <- 3
    * N_d <- 2
    * calendar_period(N_w, N_d)
    * @export
    */
  matrix calendar_period(int N_w, int N_d) {
      // declare output matrix
      matrix[N_w, N_d] out;
      // fill in output matrix
      for (i in 1:N_w) {
          for (j in 1:N_d) {
              out[i, j] = i + j - 1;
          }
      }
      return out;
  }

  // function that takes the number of accident periods and the number of development periods and 
  // the current quarter and returns a matrix of size N_w x N_d, where the ijth element
  // is 1 if i + j <= N_w + current quarter and 0 otherwise

  // starts with extremely detailed documentation using roxygen2 syntax, including a title, description, and parametersn
  // as well as examples and return values
  /**
    * @title Calendar Period Indicator
    * @description This function takes the number of accident periods and the number of development periods and 
    * the current quarter and returns a matrix of size N_w x N_d, where the ijth element
    * is 1 if i + j <= N_w + current quarter and 0 otherwise
    * @param N_w number of accident periods
    * @param N_d number of development periods
    * @param current_quarter current quarter
    * @return matrix of size N_w x N_d, where the ijth element
    * is 1 if i + j <= N_w + current quarter and 0 otherwise
    * @examples
    * N_w <- 3
    * N_d <- 2
    * current_quarter <- 1
    * calendar_period_indicator(N_w, N_d, current_quarter)
    * @export
    */
  matrix calendar_period_indicator(int N_w, int N_d, int current_quarter) {
      // declare output matrix
      matrix[N_w, N_d] out;
      // fill in output matrix
      for (i in 1:N_w) {
          for (j in 1:N_d) {
            // if i + j <= N_w + current quarter, fill in 1
            // otherwise fill in 0
              if (i + j <= N_w + current_quarter) {
                  out[i, j] = 1;
              } else {
                  out[i, j] = 0;
              }
          }
      }
      return out;
  }

  /**
    * @title Loss Matrix
    * @description This function takes the number of accident periods and the number of development periods and
    * the number of data points, and a vector with loss values, and vectors with accident periods
    * and development periods, and returns a matrix of size N_w x N_d, where the ijth element
    * is the loss value in the loss vector associated with the ith accident period and jth development period
    * but only if the calendar period indicator is 1, and returns 0 otherwise
    * @param N_w number of accident periods
    * @param N_d number of development periods
    * @param N number of data points
    * @param loss vector of loss values
    * @param accident_period vector of accident periods
    * @param development_period vector of development periods
    * @param current_quarter current quarter
    * @return matrix of size N_w x N_d, where the ijth element
    * is the loss value in the loss vector associated with the ith accident period and jth development period
    * but only if the calendar period indicator is 1, and returns 0 otherwise
    * @examples
    * N_w <- 3
    * N_d <- 2
    * N <- 5
    * loss <- c(1, 2, 3, 4, 5)
    * accident_period <- c(1, 2, 3)
    * development_period <- c(1, 2)
    * current_quarter <- 1
    * calendar_period_loss(N_w, N_d, N, loss, accident_period, development_period, current_quarter)
    * @export
    */

  matrix calendar_period_loss(
      int N_w
      , int N_d
      , int N
      , vector loss
      , vector accident_period
      , vector development_period
      , int current_quarter) {
      // declare output matrix
      matrix[N_w, N_d] out;
      // fill in output matrix
      for (i in 1:N_w) {
          for (j in 1:N_d) {
              // if the calendar period indicator is 1 fill in the loss value
              if (calendar_period_indicator[N_w, N_d, current_quarter][i, j] == 1) {
                  out[i, j] = loss[accident_period[i] + development_period[j] - 1];
              } 
              // otherwise fill in 0
              else {
                  out[i, j] = 0;
              }
          }
      }
      return out;
  }
}
