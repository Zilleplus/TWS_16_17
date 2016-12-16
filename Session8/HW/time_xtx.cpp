#include "vector.hpp"
#include "matrix.hpp"
#include "time_mv_op.hpp"
/*
The vector expressions are needed for CG. 

You will not need the addition, substraction and scalar operators for the matrices. 

Adjust the file names or uncomment these matrix operation to avoid ambiguity (if there is any)

*/
#include "vector_expressions.hpp"
#include "vector_expression_operations.hpp"
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"
#include "matvec.hpp"
		

int main(int argc, char *argv[]) {
  assert(argc==4);
  int N = std::atoi(argv[1]);
  int number_exp=std::atoi(argv[2]);
  int discard=std::atoi(argv[3]);
  assert(N>0 && number_exp>0 && discard>=0 && number_exp>discard);
 
  double beta=1.0;
  tws::matrix<double> X(N,N,1.0);

  //TODO: Create xtx_op, use your knowledge from C++2
  Matvec <tws::vector<double>, double, tws::matrix<double>> xtx_op(beta,X);
  tws::time_mv(xtx_op,N,number_exp,discard);

  return 0 ;
} 
