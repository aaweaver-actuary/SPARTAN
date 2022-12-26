//' Divide Columns
//'
//' Divides each column of a matrix by a vector.
//'
//' @param x A matrix.
//' @param y A vector.
//'
//' @return A matrix.
//'
//' @examples
//' x = matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3)
//' y = c(1, 2, 3)
//' divide_columns(x, y)
//' >      [,1] [,2] [,3]
//' > [1,]  1.0  1.0  1.0
//' > [2,]  2.0  2.5  2.0
//'
//' @author Andy Weaver
//'
//' @date 2022-12-26
//'
//' @importFrom Rcpp sourceCpp

// [[Rcpp::depends(Rcpp)]]
#include <Rcpp.h>

// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

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
// [[Rcpp::export]]
arma::mat divide_columns(arma::mat x, arma::vec y)
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

// then sets the end of the file
// [[Rcpp::export]]
void divide_columns_test()
{
  arma::mat x = {{1, 2, 3}, {4, 5, 6}};
  arma::vec y = {1, 2, 3};
  arma::mat out = divide_columns(x, y);
  out.print("out = ");
}