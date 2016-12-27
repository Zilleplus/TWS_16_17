/*
 * Willem Melis (r0348639)
 * WIT
 * tijd: 12 uur (lang zoeken op 3 fouten)
 *
 * complexiteit van y
 *
 * De term beta*x is van orde N, en wordt verwaarloost.
 * Een matric vector product is van orde N^2
 * 
 * ---------------------------------------------------------------
 * Met temp:
 * temp=matrix vector product=N^2
 * X^T*temp = (matrix vector voor temp) + matrix vector dit blijft in de orde N^2
 * ---------------------------------------------------------------
 * Zonder temp:
 * Zonder de temp variabele moet het vector product X*x N maal 
 * berekend worden. Dit zorgt ervoor dat complexiteit met N omhoog gaat.
 * X^T*(X*x) = N*(matrix vector) = N^3
 * ---------------------------------------------------------------
 *
 * Op graph.pdf is duidelijk te zien dat de complexiteit van de 
 * withTemp lager is dan de complexitiet van without temp.
 *
 * Als N gaat van 512 naar 1024:
 *
 * met temp: (verwachten N^3=8)
 * 0.0067589/0.000741615 = 9.11 = 2^3.2
 *
 * zonder temp: (verwachten N^4=16)
 * 4.1807/0.193188 = 21.64 = 2^4
 *
 * ---------------------------------------------------------------
 *
 * TODO: hoe de grafieken hermaken? testen uitvoeren?
 *
 */


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
