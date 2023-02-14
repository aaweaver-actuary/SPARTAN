/**
    * @title Calculate the rho parameter for the given accident period.
    * @description Calculate the rho parameter for the given accident period.
    *
    * @param r_rho A real value representing the rho parameter for the previous accident period.
    *
    * @return A real value representing the rho parameter for the given accident period.
    * @examples
      * calculate_rho(0.5)
      * # returns 0.5
    */
    real calculate_rho(real r_rho){
      // test if `r_rho` is a real value
      if (is_real(r_rho) == 0) {
        print("`r_rho`: ", r_rho);
        reject("This must be a real value.");
      }

      return -2*r_rho+1;
}
