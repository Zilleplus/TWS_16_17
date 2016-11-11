#include "vector.hpp"
#include "cg.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>
#include <math.h>
#include<iomanip>
#include"element_apply.hpp"

/* functor class of matvec */
template<typename T,typename T_h>
class Matvec{
    private:
        T_h h;
    public:
    Matvec(T_h h){
        this->h=h;
    }
    /* the matrix A is already compensating for the minus side from the f */
    void operator() ( T const& x, T& y) const{
        for(int i=1;i<x.size()-1;i++){
            y[i] = (x[i-1] - 2*x[i] + x[i+1]) \
                   /pow(h,2);
        }
        /* 2 exceptions on the borders */
        y[0] = (-2*x[0] + x[1])/pow(h,2);
        int lastElementIndex=y.size()-1;
        y[lastElementIndex] = (x[lastElementIndex-1] -2*x[lastElementIndex])/pow(h,2);
    }
};
template<typename T>
auto max_norm(T& x,T& y){
    auto maxnorm = std::abs(x[0] - y[0]);
    for(int i=1;i<x.size();i++){
        auto new_maxnorm = std::abs(x[i] - y[i]);
        if(maxnorm < new_maxnorm){
            maxnorm = new_maxnorm;
        }
    }
    return maxnorm;
}
/* functor class of matvec */
template<typename T>
class Example_functor{
private:
    T sigma;
public:
    Example_functor(T sigma){
        this->sigma=sigma;
    }
    /* the matrix A is already compensating for the minus side from the f */
    T operator() ( T x) {
        return exp((pow(x,2))/sigma);
    }
};

int main(int argc,char** args) {
    /*
     * use the element_apply.hpp from the first part of the homework
     */
    tws::vector<long double> testVector(5) ;
    for (int i=0; i<testVector.size(); ++i) {
        testVector[i] = i+1;
    }
    Example_functor<double>  example_functor(2);
    transform_with_function(example_functor,testVector);

    /*
     * Solve the 1D poisson equation, par 2,3,4 of the homework assignment
     */
    int n;
    /* if an argument is present it must be n */
    args++;
    if(argc > 1)n = atoi(*args);

    tws::vector<long double> b(n) ;
    tws::vector<long double> s(n) ;
    tws::vector<long double> x(n) ;

    long double h = 1/(double(n)+1);
    for (int i=0; i<x.size(); ++i){
        x[i] = (i+1)*h;
        b[i] = (3*x[i]+pow(x[i],2.0))*exp(x[i]);
    }

    /* define the functor */
    Matvec <tws::vector<long double>, long double > matvec(h);
    /* calculate the solution of the 1D poisson */
    tws::cg( matvec, x, b, 1.e-10, n );

    /* find the exact solution */
    for(int i=0;i<x.size();i++){
        s[i]= (x[i]-pow(x[i],2))*exp(x[i]);
    }

    double max_norm_err = max_norm<tws::vector<long double>>(s,x);

    std::cout
            << std::setprecision(std::numeric_limits<long double>::digits10+1)
            << std::scientific;
    std::cout<< n << " " << max_norm_err<< "\t"<< std::endl;

//    std::cout<<"x"<<x<<std::endl;
//    std::cout<<"sol"<<sol<<std::endl;
    return 0 ;

}
