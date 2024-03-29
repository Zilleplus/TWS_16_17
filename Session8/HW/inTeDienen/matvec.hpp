#ifndef MATVEC_HPP
#define MATVEC_HPP
#include "vector.hpp"
#include "matrix.hpp"
#include "vector_expressions.hpp"
#include "vector_expression_operations.hpp"
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"

template<typename T,typename T_beta,typename T_matrix>
class Matvec{
    private:
        T_beta beta_;
        T_matrix& X_;
    public:
    Matvec(T_beta beta,T_matrix & X):X_(X),beta_(beta){}
    void operator() ( T const& x, T& y) const{
        y=multiply(transpose(X_),multiply(X_,x))+beta_*x; 
    }
};

template<typename T,typename T_beta,typename T_matrix>
class MatvecTemp{
    private:
        T_beta beta_;
        T_matrix& X_;
    public:
    MatvecTemp(T_beta beta,T_matrix & X):X_(X),beta_(beta){}
    void operator() ( T const& x, T& y) const{
        tws::vector<double> temp = tws::vector<double>(X_.num_rows()) ;
        temp=multiply(X_,x);
        y=multiply(transpose(X_),temp)+beta_*x; 
    }
};
#endif
