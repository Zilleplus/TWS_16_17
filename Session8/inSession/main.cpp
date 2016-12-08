#include "vector.hpp"
#include "matrix.hpp"
//#include "vector_expressions.hpp"
//#include "vector_expression_operations.hpp"
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"
#include <iostream>


void testVectors(){
//    std::cout << "-- creating vector -- \n";
//
//    tws::vector<double>example_vector1(2);
//    example_vector1[0] =1;
//    example_vector1[1] =1;
//    std::cout << example_vector1 << "\n";
//
//    tws::vector<double>example_vector2(2);
//    example_vector2[0] =3;
//    example_vector2[1] =4;
//    std::cout << example_vector2 << "\n";
//
//    int scalar=2;
//
//    std::cout << "-- vector sum -- \n";
//    std::cout << example_vector1+example_vector2 <<"\n";
//    std::cout << "-- vector diff -- \n";
//    std::cout << example_vector1-example_vector2 <<"\n";
//    std::cout << "-- vector mul -- \n";
//    std::cout << scalar*example_vector1<<"\n";
}
void testMatrix(){

    tws::matrix<double> exampleMatrix3(3,2,2.);
    std::cout << "-- creating matrix -- \n";
    tws::matrix<double> exampleMatrix1(3,2,2.);
    exampleMatrix1(0,0)=1;
    std::cout << exampleMatrix1;

    tws::matrix<double> exampleMatrix2(3,2,3.);
    exampleMatrix2(0,0)=1;
    std::cout << exampleMatrix2;

    std::cout << exampleMatrix1+exampleMatrix2;
    std::cout << exampleMatrix1;
}

int main(){
    testVectors();
    testMatrix();
}
