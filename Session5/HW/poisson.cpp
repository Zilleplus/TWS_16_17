#include "vector.hpp"
#include "cg.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>
#include <math.h>
#include<iomanip>
#include"element_apply.h"

#define MAX_INTERATIONS_CG 100000
#define DEFAULT_N 100

/* define the type used in the program */
typedef long double floatingPointType;

/* functor class of matvec */
template<typename T,typename T_h>
class Matvec{
    private:
        T_h h;
    public:
    Matvec(T_h h){
        this->h=h;
    }
    /* the matrix A is compensating for the minus side from the f */
    void operator() ( T const& x, T& y) const{
        for(int i=1;i<x.size()-1;i++){
            y[i] = (-x[i-1] + 2.0*x[i] - x[i+1])
                   /pow(h,2.0);
        }
        /* 2 exceptions on the borders */
        y[0] = (2*x[0] - x[1])/pow(h,2.0);
        int lastElementIndex=y.size()-1;
        y[lastElementIndex] = (-x[lastElementIndex-1] + 2.0*x[lastElementIndex])/pow(h,2.0);
    }
};
template<typename Tx,typename Ty>
long double max_norm(Tx& x,Ty& y){
    long double maxnorm = std::abs(x[0] - y[0]);
    int locationMax=0;
    for(int i=1;i<x.size();i++){
        long double new_maxnorm = std::abs(x[i] - y[i]);
        if(maxnorm < new_maxnorm){
            maxnorm = new_maxnorm;
            locationMax=i;
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
    Example_functor<long double>  example_functor(2);
    transform_with_function(example_functor,testVector);

    /*
     * Solve the 1D poisson equation, part 2,3,4 of the homework assignment
     */
    int n=DEFAULT_N;
    /* if an argument is present it must be n */
    if(argc > 1)n = atoi(*++args);

    tws::vector<floatingPointType> b(n) ;
    tws::vector<floatingPointType> x(n) ;

    floatingPointType h = 1.0/(floatingPointType(n)+1.0);
    for (int i=0; i<x.size(); ++i){
        x[i] = (i+1)*h;
        b[i] = (3*x[i]+pow(x[i],2.0))*exp(x[i]);
        //x[i] = 0;
    }

    /* define the functor */
    Matvec <tws::vector<floatingPointType>, floatingPointType> matvec(h);

    /* calculate the solution of the 1D poisson, use the epsilon of the chosen type as tolerance */
    tws::cg( matvec, x, b, std::numeric_limits<floatingPointType>::epsilon() , MAX_INTERATIONS_CG);

    /* find the exact solution */
    tws::vector<long double> s(n) ;
    for(int i=0;i<x.size();i++){
        s[i]= ((i+1)*h-pow((i+1)*h,2.0))*exp((i+1)*h);
    }

    long double max_norm_err = max_norm<tws::vector<long double>,tws::vector<floatingPointType> >(s,x);

    std::cout
            << std::setprecision(std::numeric_limits<long double>::digits10+1)
            << std::scientific;
    std::cout<< n << " " << max_norm_err<< "\t"<< std::endl;

//    std::cout<<x-s ;
//    std::cout<<"x"<<x<<std::endl;
//    std::cout<<"sol"<<sol<<std::endl;
    return 0 ;
}
