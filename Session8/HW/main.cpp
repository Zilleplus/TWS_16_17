#include "matrix.hpp"
#include <iostream>
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"
#include "vector.hpp"
#include "vector_expressions.hpp"
#include "vector_expression_operations.hpp"

void testMatrix(){
    std::cout << "-- creating matrix -- \n";
    tws::matrix<double> exampleMatrix1(3,2,2.);
    tws::matrix<double> exampleMatrix1T(2,3,2.);
    exampleMatrix1(1,0)=1;
    std::cout << exampleMatrix1;

    tws::matrix<double> exampleMatrix2(2,3,3.);
    exampleMatrix2(0,1)=1;

    std::cout << transpose(exampleMatrix1).num_columns() << "\n";


    std::cout<<"example vector: \n";
    tws::vector<double> exampleVector(3,2.0);
    tws::vector<double> exampleVector2(2,2.0);
    tws::vector<double> exampleVector4(2,2.0);
    tws::vector<double> exampleVector3(2,2.0);

    std::cout << exampleVector << "\n";
    exampleMatrix1T=  transpose(exampleMatrix1);
    std::cout << exampleMatrix1T << "\n";
    std::cout << exampleVector2 << "\n";
    // tot hier ok
    //exampleVector2=multiply(exampleMatrix1T,exampleVector);
    exampleVector2=multiply(transpose(exampleMatrix1),exampleVector);

    std::cout << exampleVector2 << "\n";


    double beta=2.0;
    exampleVector4 = beta*exampleVector2 +exampleVector3;
    exampleVector2 = beta*multiply(transpose(exampleMatrix1),exampleVector)+exampleVector3;
    std::cout << exampleVector4<< "\n";
    std::cout << exampleVector2<< "\n";

    //std::cout << multiply(transpose(exampleMatrix1),exampleVector2).size() << "\n";
    //std::cout << exampleVector2 << "\n";


    //std::cout << transpose(exampleMatrix1).num_columns()<<"\n";
    //std::cout << transpose(exampleMatrix1).num_rows()<<"\n";
    //exampleMatrix1T= transpose(exampleMatrix1);
    //std::cout << exampleVector2 << "\n"; 
    //exampleVector2 = multiply(transpose(exampleMatrix1),exampleVector);
}

int main(){
    testMatrix();
}
