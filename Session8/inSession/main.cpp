#include "vector.hpp"
#include "vector_expressions.hpp"
#include "vector_expression_operations.hpp"
#include <iostream>

int main(){
    std::cout << "-- creating vector -- \n";

    tws::vector<double>example_vector1(2);
    example_vector1[0] =1;
    example_vector1[1] =1;
    std::cout << example_vector1 << "\n";

    tws::vector<double>example_vector2(2);
    example_vector2[0] =3;
    example_vector2[1] =4;
    std::cout << example_vector2 << "\n";

    int scalar=2;
    
    std::cout << "-- vector sum -- \n";
    std::cout << example_vector1+example_vector2 <<"\n";
    std::cout << "-- vector diff -- \n";
    std::cout << example_vector1-example_vector2 <<"\n";
    std::cout << "-- vector mul -- \n";
    std::cout << scalar*example_vector1<<"\n";

}

