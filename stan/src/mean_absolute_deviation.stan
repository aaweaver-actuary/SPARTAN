/**
    * Calculate the mean absolute error (MAE) for a set of observed and predicted losses. 
    * The MAE is defined as the average absolute difference between
    * the predicted losses and the corresponding observed losses. 
    * It is used as a measure of how closely the model fits the data.
    * 
    * @param len_data An integer representing the number of data points.
    * @param y_true An array of length `len_data` of observed losses.
    * @param y_pred An array of length `len_data` of predicted losses.
    * 
    * @return The MAE value for the set of observed and predicted losses.
    * 
    * @examples
    * mean_absolute_error(2, {100, 200}, {90, 180})
    * # returns 20
    */
    real mean_absolute_error(int len_data, vector y_true, vector y_pred) {
      // test that the input vectors are the same length as each other and as `len_data`
      if (len(y_true) != len(y_pred) || len_data != len(y_true || y_true == null || y_pred == null)) {
        print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
        print("The input length from `len_data` is ", len_data, "." );
        print("The input vectors and `len_data` must be the same length and not null.");
        return -1;
      }

      // test to see if `len_data` is a positive integer
      if (len_data <= 0) {
        print("`len_data`: ", len_data);
        print("This must be a positive integer.");
        return -1;
      }

      // test to ensure that the input vectors are not empty and are not equal to each other
      if (len(y_true) == 0 || len(y_pred) == 0 || y_true == y_pred) {
        print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
        print("y_true: ", y_true);
        print("y_pred: ", y_pred);
        print("The input vectors cannot be empty or equal.");
        return -1;
      }

      // Calculate the absolute difference between the two input vectors.
      // Use the Wellford algorithm to calculate the mean of the absolute differences, or `mu`.
      real abs_error = 0;
      real delta;
      real mu;
      for(i in 1:len_data){
        delta = abs(y_true[i] - y_pred[i]) - mu;
        mu = mu + delta / i;
        abs_error = abs_error + delta * (abs(y_true[i] - y_pred[i]) - mu);
      }

      // Return the mean of the absolute differences.
      return mu;
}
