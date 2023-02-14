/**
    * Calculates the cumulative loss by accident period (w) vector
    * @param len_data the length of the data
    * @param n_w the number of unique values of w
    * @param n_d the number of unique values of d
    * @param cumulative_loss the cumulative loss vector
    * @param w the w vector
    * @param d the d vector
    * @return the cumulative loss by accident period vector
    */
vector cumulative_loss_by_acc_prd(int len_data, int n_w, int n_d, vector cumulative_loss, vector w, vector d){
    // initialize incremental loss vector
    vector[len_data] incremental_loss;

    // initialize ay value
    int ay;

    // initialize cumulative loss output vector with zeros
    vector[n_w] cumulative_loss_by_ay = rep_vector(0, n_w);

    // calculate incremental loss using the cum_to_inc function
    incremental_loss = cum_to_inc(len_data, n_w, n_d, cumulative_loss, w, d);

    // loop over the incremental loss vector and calculate the cumulative loss by ay
    for (i in 1:len_data){
        // get the ay value for the current incremental loss
        ay = w[i];

        // add the incremental loss to the cumulative loss by ay in the row corresponding to the ay value
        cumulative_loss_by_ay[ay] = cumulative_loss_by_ay[ay] + incremental_loss[i];
    }

    // return the cumulative loss by ay vector
    return cumulative_loss_by_ay;
}
