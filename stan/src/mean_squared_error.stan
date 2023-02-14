/**
  * @title Mean Squared Error
  * @description Calculate the mean squared error (MSE) between the predicted losses and the actual losses.
  * 
  * The MSE is a common metric for evaluating the accuracy of a prediction. It is calculated by taking the average of the squared differences between the predicted values and the actual values. A lower MSE indicates a better fit between the predicted and actual values.
  * 
  * @param len_data An integer representing the number of data points.
  * @param y_pred An array of length `len_data` of predicted losses.
  * @param y_true An array of length `len_data` of observed losses.
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
  real mean_squared_error(const int len_data, const real y_true[len_data], const real y_pred[len_data]) {
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

    // Calculate the squared difference between the two input vectors.
    real sum_squared_errors = 0;
    for(i in 1:len_data){
      sum_squared_errors += (y_true[i] - y_pred[i]) ^ 2;  
    }
    
    // Return the mean of the squared differences.
    return sum_squared_errors / len_data;
}
