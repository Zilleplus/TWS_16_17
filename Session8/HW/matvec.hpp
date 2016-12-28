/*
 * Willem Melis (r0348639)
 * WIT
 * tijd: 12 uur (lang zoeken op 3 fouten)
 * De tijdsmeting is gedaan op server tienen al de pc's zijn
 * continue belast door iemand anders dus de test resultaten kunnen wat afwijken.
 *
 * compiler commando:  g++ -std=c++14 ./srda.cpp
 * generate_data.sh bevat de compiler commando's voor de tijdsmetingen.
 *
 * Zoals al aangehaald in de vorige oefening zijn de pc's op CW 
 * zeer irritant om op te werken doordat ze allemaal continue zwaar belast zijn.
 * ---------------------------------------------------------------
 * Overzicht bestanden:
 *
 * -> Shell scripts voor grafiek:
 * generate_data.sh
 * makeGraphs.sh
 *
 * -> header files matrix en vector:
 * matrix_expression_operations.hpp
 * matrix_expressions.hpp
 * matrix.hpp
 * vector_expression_operations.hpp
 * vector_expressions.hpp
 * vector.hpp
 *
 * -> header file met 2 matvec klasses, met en zonder tmep variabele
 * matvec.hpp
 *
 * LDA: srda.cpp
 * timings: time_xtx.cpp
 *
 * -> tex bestanden
 *  graph.tex
 *
 * -> manuele data
 *  noTempTheo.txt
 *  withTempTheo.txt
 *
 * ---------------------------------------------------------------
 *  Aanpassingen in srda.cpp, definieer xtx_op:
 *      Matvec <tws::vector<double>, double, tws::matrix<double>> xtx_op(beta,X);
 *
 *  Aanpassing in  time_xtx.cpp
 * 		#ifndef withTemp
 * 		    Matvec <tws::vector<double>, double, tws::matrix<double>> xtx_op(beta,X);
 * 		#else
 * 		    MatvecTemp <tws::vector<double>, double, tws::matrix<double>> xtx_op(beta,X);
 * 		#endif*
 * ---------------------------------------------------------------
 * complexiteit van y
 *
 * De term beta*x is van orde N, en wordt verwaarloost.
 * Een matric vector product is van orde N^2
 * 
 * Met temp:
 * temp=matrix vector product=N^2
 * X^T*temp = (matrix vector voor temp) + matrix vector dit blijft in de orde N^2
 *
 * Zonder temp:
 * Zonder de temp variabele moet het vector product X*x N maal 
 * berekend worden. Dit zorgt ervoor dat complexiteit met N omhoog gaat.
 * X^T*(X*x) = N*(matrix vector) = N^3
 * ---------------------------------------------------------------
 * Bespreking graph.pdf:
 *
 * Op graph.pdf is duidelijk te zien dat de complexiteit van de 
 * with Temp lager is dan de complexitiet van no temp.
 *
 * Als N gaat van 64 naar 128: N maal 2...
 *
 * met temp: 
 * 3.28068e-05/7.44783e-06 = 4.4 (we verwachten 2^2)
 *
 * zonder temp: 
 * 0.00164838/0.000203123 =  8.1 (we verwachten 8) 
 *
 * Het verschil in complexiteit is duidelijk te zien op de grafiek, waarbij
 * de 'slope' van twee lijnen duidelijk anders is.
 * De lijnen van N^3 en N^2 vetrekken vanuit N=16 en gaan tot 256 en keren terug tot 8. 
 * Het is duidelijk dat als N te klein is dat de complexiteit niet vantoepassing is.
 * De accestijden van het cache enz zullen de dominerende factoren zijn voor de complexiteit.
 *
 * Hoe de grafiek reproduceren?
 * 
 * generate_data.sh compileert time_xtx.cpp 
 * Hierbij word noTemp.out aangemaakt die de matvec gebruikt zonder de temp variabele en 
 * withTemp.out die de matvect gebruikt met de temp variablele.
 * Vervolgens zal makeGraphs.sh de grafiek aanmaken.
 *
 * noTempTheo.txt en withTempTheo.txt bevatten de tekenputenn van N^2 en N63
 * 
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
