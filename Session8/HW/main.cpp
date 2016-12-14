#include "matrix.hpp"
#include <iostream>
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"
#include "vector.hpp"
#include "vector_expressions.hpp"

void testMatrix(){

    std::cout << "-- creating matrix -- \n";
    tws::matrix<double> exampleMatrix1T(2,3,2.);
    tws::matrix<double> exampleMatrix1(2,3,2.);
    exampleMatrix1(1,0)=1;
    std::cout << exampleMatrix1;

    tws::matrix<double> exampleMatrix2(2,3,3.);
    exampleMatrix2(0,1)=1;
    std::cout << exampleMatrix2;

    exampleMatrix1T = transpose(exampleMatrix1);
    std::cout << exampleMatrix1.num_columns();
    std::cout << exampleMatrix1T.num_columns();


    //std::cout<<"example vector: \n";
    //tws::vector<double> exampleVector(3,2.0);
    //tws::vector<double> exampleVector2(3,2.0);

    //std::cout << exampleVector << "\n";
    //exampleVector2 = multiply(exampleMatrix1,exampleVector);
    //std::cout << exampleVector2 << "\n"; 



}

int main(){
    testMatrix();
}
