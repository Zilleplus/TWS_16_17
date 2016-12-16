#include <iostream>
#include "vector.hpp"
#include "matrix.hpp"
#include "vector_expressions.hpp"
#include "vector_expression_operations.hpp"
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"

#include "matvec.hpp"

void testMatrix(){
    tws::matrix<double> X(2,3,2.);
    tws::vector<double> x(3,2.0);
    tws::vector<double> y(3,0);
    double beta=2.0;
    Matvec <tws::vector<double>, double, tws::matrix<double>> xtx_op(beta,X);

    x(0)=1;x(1)=2;x(2)=3;
    X(0,0)=7;X(0,1)=3;X(0,2)=9;
    X(1,0)=23;X(1,1)=12;X(1,2)=62;
    xtx_op(x,y); 

    //y= multiply(X,x);

    std::cout<< X << "\n";
    std::cout<< x << "\n";
    std::cout<< y << "\n"; 
    //y = multiply(transpose(X),multiply(X,x))+beta*x;
}

int main(){
    testMatrix();
}
