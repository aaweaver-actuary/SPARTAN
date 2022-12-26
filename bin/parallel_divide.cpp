// recreates the `parallel_divide` function from the "mcmc_funcs.R" file to be used with `Rcpp`

// first sets headers

// [[Rcpp::depends(Rcpp)]]
#include <Rcpp.h>

// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::depends(RcppParallel)]]
#include <RcppParallel.h>

// then sets namespaces
// the namespace Rcpp is used for the Rcpp::export function
// the namespace arma is used for the Armadillo functions
// Rcpp is a package that allows C++ to be used in R
// Armadillo is a C++ library for linear algebra and scientific computing
// RcppArmadillo is a package that allows Rcpp to use Armadillo

using namespace Rcpp;
using namespace arma;


// then sets the function
// this function divides each column of a matrix by a vector
// this function is parallelized, so it can be used with the `parallel` package

// [[Rcpp::export]]
arma::mat parallel_divide(arma::mat x, arma::vec y)
{
  // gets the number of rows and columns of the matrix
  int n = x.n_rows;
  int p = x.n_cols;

  // creates a matrix to store the output
  arma::mat out(n, p);

  // divides each column of the matrix by the corresponding element of the vector
  // x.col(i) is the i-th column of the matrix
  // y(i) is the i-th element of the vector
  // out.col(i) is the i-th column of the output matrix
  
  for (int i = 0; i < p; i++)
  {
    out.col(i) = x.col(i) / y(i);
  }
  return out;
}

