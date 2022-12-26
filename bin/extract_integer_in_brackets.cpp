//' Extracts the integer in brackets from a string
//'
//' @param x A string.
//'
//' @return An integer.
//'
//' @examples
//' extract_integer_in_brackets("a[1]")
//' > [1] 1
//' extract_integer_in_brackets("b[2]")
//' > [1] 2
//' extract_integer_in_brackets("c[3]")
//' > [1] 3
//' extract_integer_in_brackets("ultimate_loss[2025]")
//' > [1] 2025
//'
//' @author Andy Weaver
//'
//' @date 2022-12-26

// first sets headers
// [[Rcpp::depends(Rcpp)]]
#include <Rcpp.h>

// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::depends(RcppParallel)]]
#include <RcppParallel.h>

// then sets namespaces
using namespace Rcpp;
using namespace arma;

// then sets the function
// this function extracts the integer in brackets from a string
// [[Rcpp::export]]
int extract_integer_in_brackets(std::string x)
{
  // gets the position of the first bracket
  int pos1 = x.find("[");
  // gets the position of the second bracket
  int pos2 = x.find("]");
  // extracts the integer in brackets
  int out = std::stoi(x.substr(pos1 + 1, pos2 - pos1 - 1));
  return out;
}