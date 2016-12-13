#include "matrix.hpp"
#include <iostream>
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"

void testMatrix(){

    std::cout << "-- creating matrix -- \n";
    tws::matrix<double> exampleMatrix1T(3,2,2.);
    tws::matrix<double> exampleMatrix1(3,2,2.);
    exampleMatrix1(0,0)=1;
    std::cout << exampleMatrix1;

    tws::matrix<double> exampleMatrix2(3,2,3.);
    exampleMatrix2(0,0)=1;
    std::cout << exampleMatrix2;

    exampleMatrix1T = transpose(exampleMatrix1);
    std::cout << exampleMatrix1T;

}

int main(){
    testMatrix();
}
