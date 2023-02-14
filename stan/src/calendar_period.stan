/**
      * @title Calendar Period
      * @description This function takes the number of accident periods
      * and the number of development periods
      * and returns a matrix of size N_w x N_d, where the ijth element
      * is i + j - 1
      * @param N_w number of accident periods
      * @param N_d number of development periods
      * @return matrix of size N_w x N_d, where the ijth element
      * is i + j - 1
      * @examples
      * N_w <- 4
      * N_d <- 4
      * calendar_period(N_w, N_d)
      * #>      [,1] [,2] [,3] [,4]
      * #> [1,]    1    2    3    4
      * #> [2,]    2    3    4    5
      * #> [3,]    3    4    5    6
      * #> [4,]    4    5    6    7
      */
    matrix calendar_period(int N_w, int N_d) {
        // test if `N_w` is a positive integer
          if (is_positive_integer(N_w) == 0) {
              print("`N_w`: ", N_w);
              reject("This must be a positive integer.");
          }

          // test if `N_d` is a positive integer
          if (is_positive_integer(N_d) == 0) {
              print("`N_d`: ", N_d);
              reject("This must be a positive integer.");
          }


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
