/**
    * @title current_dev_period_by_acc_prd
    * @description This function returns the current development period by accident period
    * @param len_data (integer) The length of the data
    * @param w (vector) The accident period
    * @param d (vector) The development period
    * @return result (vector) The current development period by accident period
    * @example
    * current_dev_period_by_acc_prd(6, c(1, 1, 1, 2, 2, 3), c(1, 2, 3, 1, 2, 1))
    * [1] 3 2 1
    */

vector current_dev_period_by_acc_prd(int len_data, vector w, vector d){
    // initialize the vector as a vector of zeros to store the result
    vector[len_data] result = rep_vector(0, len_data);

    // loop through the data
    for(i = 1:len_data){
        
        // if the stored value for the result corresponding to the current value of w is
        // less than the current value of d, then replace the stored value with the current
        // value of d
        if(result[w[i]] < d[i]){
            result[w[i]] = d[i];
        }
        
    }

    // return the result
    return result;
}
