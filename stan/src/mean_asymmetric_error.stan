/**
    * Calculate the mean error between true values `y_true` and predicted values `y_pred`.
    * The error is calculated differently depending on whether the actual value is greater than or less than the predicted value.
    * Specifically, for each element in the input vectors:
    * - If the actual value is greater than the predicted value, the error is the squared difference between the actual and predicted values.
    * - If the actual value is less than the predicted value, the error is the absolute difference between the actual and predicted values.
    * The mean of the errors vector is then returned.
    * 
    * @param len_data An integer representing the length of the input data.
    * @param y_true A vector of true values.
    * @param y_pred A vector of predicted values.
    * 
    * @return A real value representing the mean error between `y_true` and `y_pred`.
    */
    real mean_asymmetric_error1(int len_data, vector y_true, vector y_pred) {
      // test that the input vectors are the same length
      if (len(y_true) != len(y_pred)) {
        print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
        reject("The input vectors must be the same length.");
      }

      // test that `len_data` is the same as the length of the input vectors
      if (len_data != len(y_true)) {
        print("The length of y_true is ", len(y_true), " and the input length from `len_data` is ", len_data, "." );
        reject("These must be the same length.");
      }

      // test to see if `len_data` is a positive integer
      if (len_data <= 0) {
        print("`len_data`: ", len_data);
        reject("This must be a positive integer.");
      }

      // test to ensure that the input vectors are not empty and are not equal to each other
      if (len(y_true) == 0 || len(y_pred) == 0) {
        print("The length of y_true is ", len(y_true), " and the length of y_pred is ", len(y_pred), "." );
        reject("The input vectors cannot be empty.");
      }
      if (y_true == y_pred) {
          print("y_true: ", y_true);
          print("y_pred: ", y_pred);
        reject("The input vectors cannot be equal.");
      }


      // Initialize a vector of asymmetric errors with the same length as the input vectors.
      vector[len_data] asymmetric_errors;

      // Loop over each element in the input vectors and calculate the error.
      for (i in 1:len_data) {
        // If the actual value is greater than the predicted value, use the squared error.
        if (y_true[i] > y_pred[i]) {
          asymmetric_errors[i] = (y_true[i] - y_pred[i])^2;
        }
        // Otherwise, use the absolute error.
        else {
          asymmetric_errors[i] = fabs(y_true[i] - y_pred[i]);
        }
      }
      // Return the mean of the errors vector.
      return mean(asymmetric_errors);
    }

  /**
    * Calculate the mean error between true values `y_true` and predicted values `y_pred`.
    * Takes upside and downside inputs to calculate the error differently depending on whether the actual value is greater than or less than the predicted value.
    * The error is calculated differently depending on whether the actual value is greater than or less than the predicted value.
    * Specifically, for each element in the input vectors:
    * - If the actual value is greater than the predicted value, the error is calculated by the lambda function `upside`.
    * - If the actual value is less than the predicted value, the error is calculated by the lambda function `downside`.
    * The mean of the errors vector is then returned.
      * @param len_data An integer representing the length of the input data.
      * @param y_true A vector of true values.
      * @param y_pred A vector of predicted values.
      * @param upside A lambda function representing calculated error when the actual value is greater than the predicted value.
      * @param downside A lambda function representing calculated error when the actual value is greater than the predicted value.
      *
      * @return A real value representing the mean asymmetric error between `y_true` and `y_pred`.
      */
      real mean_asymmetric_error(int len_data, vector y_true, vector y_pred, real(^upside)(real, real), real(^downside)(real, real)) {
        // Initialize a vector of asymmetric errors with the same length as the input vectors.
        vector[len_data] asymmetric_errors;

        // Loop over each element in the input vectors and calculate the error.
        for (i in 1:len_data) {
          // If the actual value is greater than the predicted value, use the upside function.
          if (y_true[i] > y_pred[i]) {
            asymmetric_errors[i] = upside(y_true[i], y_pred[i]);
          }
          // Otherwise, use the downside function.
          else {
            asymmetric_errors[i] = downside(y_true[i], y_pred[i]);
          }
        }
        // Return the mean of the errors vector.
        return mean(asymmetric_errors);
      }