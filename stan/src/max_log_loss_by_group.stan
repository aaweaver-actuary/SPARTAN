/**
    * Calculate the maximum value of a vector `maximize` for each group in a vector `group_by`.
    * For each group in `group_by`, find the maximum value of `maximize` in that group.
    * Then, for each group, find the value of `log_loss` that corresponds to
    * the maximum value of `maximize` in that group.
    * Return a matrix with `n_groups` rows with 3 columns:
    * the first column is the group_by value, the second column is the maximum value
    * of `maximize` in that group, and the third value is the exponentiated value of `log_loss`
    * that corresponds to the location of the group_by and maximize values for that group.
      * @param log_loss A vector of length `len_data` representing the log loss values.
      * @param len_data An integer representing the length of the input data.
      * @param group_by A vector of length `len_data` representing the group_by values.
      * @param n_groups An integer representing the number of groups.
      * @param maximize A vector of length `len_data` representing the maximize values.
      *
      * @return A matrix with `n_groups` rows with 3 columns:
      * the first column is the group_by value, the second column is the maximum value
      * of `maximize` in that group, and the third value is the exponentiated value of `log_loss`
      * that corresponds to the location of the group_by and maximize values for that group.
      */
    matrix max_log_loss_by_group(vector log_loss, int len_data, vector group_by, int n_groups, vector maximize){
      // test that the length of the input data is the same
      if (length(group_by) != length(log_loss)){
        print("There are ", length(group_by), " rows in the input vector `group_by`.");
        print("There are ", length(log_loss), " rows in the input vector `log_loss`.");
        reject("The length of the input vectors `group_by` and `log_loss` must be the same.");
      }

      // test that the length of log_loss and maximize are the same
      if (length(log_loss) != length(maximize)){
        print("There are ", length(log_loss), " rows in the input vector `log_loss`.");
        print("There are ", length(maximize), " rows in the input vector `maximize`.");
        reject("The length of the input vectors `log_loss` and `maximize` must be the same.");
      }

      // test that the length of log_loss equals len_data
      if (length(log_loss) != len_data){
        print("There are ", length(log_loss), " rows in the input vector `log_loss`.");
        print("The input integer `len_data` is ", len_data, ".");
        reject("The length of the input vector `log_loss` must be the same as the input integer `len_data`.");
      }

      // test that n_groups is greater than 0
      if (n_groups <= 0){
        print("The input integer `n_groups` is ", n_groups, ".");
        reject("The input integer `n_groups` must be greater than 0.");
      }

      // test that n_groups equals the number of unique values in group_by
      if (n_groups != length(unique(group_by))){
        print("The input integer `n_groups` is ", n_groups, ".");
        print("The number of unique values in the input vector `group_by` is ", length(unique(group_by)), ".");
        print("The unique values in the input vector `group_by` are ", unique(group_by), ".");
        reject("The input integer `n_groups` must be the same as the number of unique values in the input vector `group_by`.");
      }

      // test that there is at least one value in maximize for each unique group in group_by
      // consider group_by as a vector of categories rather than of numbers
      // for each category, filter maximize to only include values that correspond to that category
      // do not consider group_by as a vector of numbers but rather as a vector of the unique categories
      // then, check if the length of the filtered vector is greater than 0
      // if it is not, explain which category is the problem and reject
      // if it is, continue
      // initialize the current group
      int i;
      int cur_group;
      vector cur_maximize;
      for (i in 1:n_groups){
        // initialize the current group
        cur_group = i;

        // filter maximize to only include values that correspond to the current group
        cur_maximize = maximize[group_by == cur_group];

        // if the length of the filtered vector is 0, explain which category is the problem and reject
        if (length(cur_maximize) == 0){
          print("The number of unique values in the input vector `group_by` is ", length(unique(group_by)), ".");
          print("The unique values in the input vector `group_by` are ", unique(group_by), ".");
          print("The input integer `n_groups` is ", n_groups, ".");
          print("The input integer `n_groups` must be the same as the number of unique values in the input vector `group_by`.");
          print("The input vector `group_by` has a value of ", cur_group, " that does not correspond to any value in the input vector `maximize`.");
          reject("The input vector `group_by` must have at least one value in the input vector `maximize` for each unique value in the input vector `group_by`.");
        }
      }

      // initialize the output matrix
      matrix[n_groups, 3] out;

      // loop through the groups
      // initialize the current group, the current maximum value, and the current maximum value index
      int i;
      int j;
      int k;
      int cur_group;
      int cur_max;
      real cur_max_val;
      real cur_log_loss;

      // loop through the groups
      for (i in 1:n_groups){
        // initialize the current group, the current maximum value, and the current maximum value index
        cur_group = i;
        cur_max = 0;
        cur_max_val = -1e10;

        // loop through the data
        for (j in 1:len_data){

          // if the group_by value is the current group,
          // check if the maximize value is greater than the current maximum value
          if (group_by[j] == cur_group){

            // if it is, update the current maximum value and index
            if (maximize[j] > cur_max_val){
              cur_max = j;
              cur_max_val = maximize[j];
            }
          }
        }

        // after looping through the data, update the output matrix
        cur_log_loss = log_loss[cur_max];

        // first column is the group_by value
        out[i, 1] = cur_group;

        // second column is the maximum value of `maximize` in that group
        out[i, 2] = cur_max_val;

        // third column is the log value of `log_loss` that
        // corresponds to the location of the group_by and
        // maximize values for that group
        out[i, 3] = cur_log_loss;
      }

      // ensure out is sorted by the first column
      out = sort_asc(out);

      // return the output matrix
      return out;
    }