#include "vector.hpp"
#include "cg.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>
#include <math.h>

template<typename T>
class Matvec{
    private:
        double h;
    public:
    Matvec(double h){
        this->h=h;
    }
    /* the matrix A is allready compensating for the minus side from the f */
    void operator() ( T const& x, T& y) const{
        for(int i=1;i<x.size()-1;i++){
            y[i] = (x[i-1] - 2*x[i] + x[i-1]) \
                   /h;
        }
        y[0] = -2*x[0] + x[1];
        int lastElementIndex=y.size()-1; 
        y[lastElementIndex] = x[lastElementIndex-1] -2*x[lastElementIndex];
    }
};
template<typename T>
auto max_norm(T& x,T& y){
    auto maxnorm = std::abs(x[0] - y[0]);
    for(int i=1;i<x.size();i++){
        if(maxnorm < std::abs(x[i] - y[i])){
            maxnorm = std::abs(x[i] - y[i]);  
        } 
    }
    return maxnorm;

}

int main(int argc,char** args) {
    int n=100;
    /* if an argument is present it must be n */
    args++;
    if(argc > 1)n = atoi(*args);
    
    tws::vector<double> b(n) ;
    tws::vector<double> sol(n) ;
    tws::vector<double> x(n) ;
    tws::vector<double> b_ex(n) ;
    
    double h = 1/(double(n)+1);
    for (int i=0; i<x.size(); ++i){
        x[i] = i*h;
        b[i] = (3*x[i]+pow(x[i],2))*exp(x[i]);
    }
    
    Matvec <tws::vector<double> > matvec(h);
    
    /* calculate the solution of the 1D poisson */
    tws::cg( matvec, x, b, 1.e-10, n ) ;
    
    /* find the exact solution */
    for(int i=0;i<x.size();i++){
        b_ex[i]= (x[i]-pow(x[i],2))*exp(x[i]);
    }
    
    double max_error = max_norm<tws::vector<double>>(b_ex,x);
    std::cout<<max_error<<"\n";
    std::cout<<b_ex<<"\n";
    std::cout<<b<<"\n";
    //std::cout<<"relative error: "<<tws::norm_2(sol-b_ex)/tws::norm_2(b_ex)<<std::endl;
    //std::cout<<"x"<<x<<std::endl;
    //std::cout<<"sol"<<sol<<std::endl;
    return 0 ;
} 
