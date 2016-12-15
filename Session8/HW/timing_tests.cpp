#include "vector.hpp"
#include "matrix.hpp"

#include "vector_expressions.hpp"
#include "vector_expression_operations.hpp"
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"

#define withTemp 0
#define withoutTemp 1

double doTimings(int,int,int);
int main(int argc,char** args){
    int m=100; /* use vectors of length 100 */
    for(int n=10;n<5000;n+=10) 
        std::cout << 
            doTimings(withoutTemp,n,m)<<
            " "<<
            doTimings(withTemp,n,m) << 
            "\n";
} 
double doTimings(int mode,int n,int m){
    /*
     * define variables used in time experiment
     * The vectors have a length of m
     * The matrix has a dim of n*m
     *
     * m is also used to fill up the matrices
     */
    tws::vector<double> x(m,m);
    tws::vector<double> y(m,0);
    tws::vector<double> temp(n,0);
    tws::matrix<double> X(n,m,m);
    double beta=2.0;
    /*
     * variables needed for timing
     */
    struct timespec l_start, l_end;

    clock_gettime(CLOCK_MONOTONIC, &l_start);
    if(mode==withTemp){
        temp=multiply(X,x);
        y= multiply(transpose(X),temp)+beta*x;
    }else{
        y= multiply(transpose(X),multiply(X,x))+beta*x;
    }
    clock_gettime(CLOCK_MONOTONIC, &l_end);
    return (l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0;
} 
