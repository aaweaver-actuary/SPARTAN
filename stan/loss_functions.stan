functions{
/**
  * Calculate the mean absolute error (MAE) for a set of observed and predicted losses. 
  * The MAE is defined as the average absolute difference between the predicted losses and the corresponding observed losses. 
  * It is used as a measure of how closely the model fits the data.
  * 
  * @param len_data An integer representing the number of data points.
  * @param y_true A vector of observed losses.
  * @param y_pred A vector of predicted losses.
  * 
  * @return The MAE value for the set of observed and predicted losses.
  * 
  * @examples
  * mean_absolute_error(5, {100, 200, 300, 400, 500}, {90, 180, 270, 360, 450})
  * # returns 30
  */
  real mean_absolute_error(int len_data, vector y_true, vector y_pred) {
    // Calculate the absolute difference between the two input vectors.
    vector[len_data] abs_errors = fabs(y_true - y_pred);

    // Return the mean of the absolute differences.
    return sum(abs_errors) / len_data;
  }

 /**
  * @title Mean Squared Error
  * @description Calculate the mean squared error (MSE) between the predicted losses and the actual losses.
  * 
  * The MSE is a common metric for evaluating the accuracy of a prediction. It is calculated by taking the average of the squared differences between the predicted values and the actual values. A lower MSE indicates a better fit between the predicted and actual values.
  * 
  * @param len_data An integer representing the number of data points.
  * @param y_pred A vector of predicted losses.
  * @param y_true A vector of actual losses.
  * @return The MSE between the predicted and actual losses.
  * 
  * @examples
  * mean_squared_error(3, [1, 2, 3], [1, 2, 3])
  * # returns 0
  * mean_squared_error(3, [1, 2, 3], [1, 2, 4])
  * # returns 0.33
  * mean_squared_error(3, [1, 2, 3], [0, 2, 3])
  * # returns 0.33
  */
  real mean_squared_error(int len_data, vector y_true, vector y_pred) {
    // Calculate the squared difference between the two input vectors.
    vector[len_data] squared_errors;
    for(i in 1:len_data){
      squared_errors[i] = (y_true[i] - y_pred[i]) ^ 2;  
    }
    // Return the mean of the squared differences.
    return sum(squared_errors) / len_data;
  }

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
}
