/*
 * WIT Willem Melis
 * 6-7 uur, veel problemen gehad om die poisson te debuggen.
 * Uiteindelijk wel veel van geleerd, spijtig van de fout in de opgave, gelukkig was het discussieforum er.
 *
 * Gecompileerd en getest op server voeren
 *
 * compiler commando: g++ poisson.cpp -O3 -std=c++14
 * ./a.out geeft als uitput: 100 2.1234166244357412191e-05
 * Als eerste argument kan optioneel een andere n dan 100 worden meegegeven.
 * compiler versie: gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4)
 * 
 * Het compiler commando bevat de optie -O3 om de testen iets sneller te kunnen uitvoeren.
 * Dit lijkt de stabiliteit van het programma niet te beinvloeden maar is dus niet strikt noodzakelijk.
 *
 * De startwaarde van x lijkt weinig invloed te hebben op de oplossing.
 * Het zou kunnen dat het iets meer tijd vergt, er zijn uiteindelijk geen testen op tijd gedaan.
 * Daarnaast zijn er maar enkele andere startwaarde gekozen ,alle elementen van x 0 of 1.
 * De startwaarde die nu in de code staat is (i+1)*h een rechte.
 *
 * Op de grafiek uit poisson.dpf is af te leiden dat naarmate n groter wordt de error zal dalen.
 * Dit was natuurlijk te verwachten, maar als de matrix A groter wordt verslecht zijn conditie.
 * Als n=10 is de conditie ongeveer 50 terwijl bij een n=100 de conditie al over de 4000 is.
 * In het begin zal de nauwkeurigheid van het algoritme een grote rol spelen in de fout.
 * Terwijl bij een grote n de conditie de dominerende factor zal zijn van de fout.
 * Er is dus een soort "sweet spot" waar de totale fout het kleinst zal zijn.
 * Een grotere n zorgt dus niet noodzakelijk voor een beter oplossing.
 *
 * Het spreekt voor zich dat dit effect het eerst zal voorkomen bij the type float.
 * Doordat dit algoritme minder nauwkeurig is zal de conditie al sneller slechter 
 * worden dat het algoritme nauwkeuriger kan worden.
 */


#include "vector.hpp"
#include "cg.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>
#include <math.h>
#include<iomanip>
#include"element_apply.hpp"

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
    for(int i=1;i<x.size();i++){
        long double new_maxnorm = std::abs(x[i] - y[i]);
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

    return 0 ;
}
