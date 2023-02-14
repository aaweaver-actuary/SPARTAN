// function that takes a vector with exposures by accident period, a vector of accident periods, and a vector of development periods
// and returns a matrix of the accident period, development period combos and the corresponding exposure (for each accident period)
// for the future. This is used to calculate the future exposure for each accident period and development period combo, and for 
// estimating the unpaid claims for each accident period as of a particular development period.

// This function is used in the function "future_exposure" below.

matrix future_data(int len_data, int n_w, int n_d, vector exposure, vector w, vector d) {
    // total number of cells in the matrix (accident period x development period) (incl. both future and past)
    int total_cells = n_w * n_d;

    // number of cells in the future matrix (`total_cells` - `len_data`)
    int future_cells = total_cells - len_data;

    // initialize matrix of zeros:
    matrix[future_cells, 3] future_data = rep_matrix(0, future_cells, 3);

    // initialize matrix of zeros for the total matrix:
    matrix[total_cells, 3] total_data = rep_matrix(0, total_cells, 3);

    // initialize an empty vector to hold the exposure for each accident period
    vector[n_w] exposure_by_w = rep_vector(0, n_w);

    // loop through the data, and fill in the exposure_by_w vector with the largest exposure the accident period you
    // find in the data
    for (n in 1:len_data) {
        if (exposure[n] > exposure_by_w[w[n]]) {
            exposure_by_w[w[n]] = exposure[n];
        }
    }

    // loop through the accident periods and development periods and fill in the matrix with the corresponding exposure
    // and accident period and development period
    for (i in 1:n_w) {
        for (j in 1:n_d) {
            // check to see if this is a past or future cell, eg if the (i, j) pair is in the (w, d) vector, 
            // or a matrix defined as len_data rows by 2 columns, one for w and one for d
            for(n in 1:len_data){

                // if it is a past cell, fill in the total matrix with tge corresponding exposure
                if (i == w[n] && j == d[n]) {
                    total_data[(i - 1) * n_d + j, 1] = exposure[n];
                    total_data[(i - 1) * n_d + j, 2] = i;
                    total_data[(i - 1) * n_d + j, 3] = j;
                }

            }

            // if it is a future cell, we can tell because the exposure will be 0 in the total matrix
            // and we should fill in the future matrix with the corresponding exposure from the exposure_by_w vector
            // and accident period and development period (i, j)
            if (total_data[(i - 1) * n_d + j, 1] == 0) {
                future_data[(i - 1) * n_d + j - len_data, 1] = exposure_by_w[i];
                future_data[(i - 1) * n_d + j - len_data, 2] = i;
                future_data[(i - 1) * n_d + j - len_data, 3] = j;
            }
        }
    }

    // return the future matrix
    return future_data;
}
