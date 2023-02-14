// add an extremely detailed docstring right here:

/**
    @title Cumulative to Incremental Loss
    @description This function converts cumulative loss to incremental loss. Incremental loss is
    calculated as the difference between the cumulative loss in the current development period and the
    cumulative loss in the previous development period. If the development period is 1, the cumulative
    loss is the incremental loss.
    Note that before running this function, the cumulative loss vector must be sorted by accident year
    and development period. This can be done using the sort function.
    @param len_data (integer) The length of the data.
    @param n_ay (integer) The number of accident years.
    @param n_dev (integer) The number of development periods.
    @param cumulative_loss (vector) The cumulative loss vector.
    @param w (vector) The accident period vector.
    @param d (vector) The development period vector.
    @return incremental_loss (vector) The incremental loss vector.
    @example
    >> cumulative_loss = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180];
    >> w = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  2, 2, 2, 2, 2, 2, 3, 3];
    >> d = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 1, 2];
    >> len_data = 18;
    >> n_ay = 3;
    >> n_dev = 10;
    >> // the first value should be 10, since the dev period is 1, and the cumulative loss is the incremental loss
    >> // the second value should be 10, since the dev period is 2, and the incremental loss is the difference
    >> // between the cumulative loss in the current dev period and the cumulative loss in the previous dev period 
    >> // (these values are 20 and 10, respectively, and 20 - 10 = 10)
    >> // the eleventh value should be equal to the cumulative loss in the current dev period (110)
    >> // the seventeenth value should be equal to the cumulative loss in the current dev period (170)
    >> // both of these are because the dev period is 1, and the cumulative loss is the incremental loss
    >> // the twelfth value should be equal to the cumulative loss in the current dev period (120) minus the cumulative loss
    >> // in the previous dev period (110), which is 10
    >> // the eighteenth value should be equal to the cumulative loss in the current dev period (180) minus the cumulative loss
    >> // in the previous dev period (170), which is 10

    >> incremental_loss = cum_to_inc(len_data, n_ay, n_dev, cumulative_loss, w, d);
    >> incremental_loss
    [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 110, 10, 10, 10, 10, 10, 170, 10]

    */
vector cum_to_inc(int len_data, int n_ay, int n_dev, vector cumulative_loss, vector w, vector d) {
    // initialize the incremental loss vector
    vector[len_data] incremental_loss;


    // loop over the data
    for (n = 1:len_data) {
        
        // calculate incremental loss
        // if dev period is 1, cum = incremental loss
        if (d[n] == 1) {
            incremental_loss[n] = cumulative_loss[n];
        }

        // otherwise, incremental loss = cumulative loss - cumulative loss in previous dev period
        else {
            incremental_loss[n] = cumulative_loss[n] - cumulative_loss[n - 1];
        }
    }

    return incremental_loss;
}      