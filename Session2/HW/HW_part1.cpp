/*
 * Willem Melis
 * gecompileerd met g++ (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609
 * compiler-commando: alle compileer commando's staan in de Makefile, aangezien het ernogal veel zijn 
 * Gecompileerd en getest op computer herent
 *
 * De bestanden hun namen zijn opgesteld volgens de volgende legende:
 * HW_part*
 * Alle bestanden van vb deel1 beginnen dus met HW_part1
 *
 *
 * DEEL1:
 * -HW_part1.cpp : implementatie van alles voor deel 1
 *
 *  SERIEEL
 *  zonder optimalisatie: serial sort_O0 
 *  met 03: serial sort_O3 
 *  met volgende flags: -Ofast -ffast-math -fprefetch-loop-arrays :HW_part1_sec_max_opt.out
 *  
 *  PDF: HW_part1_sort_sequential.pdf
 *  Het optimalisatie niveau 0 is duidelijk beter dan niveau. De fprefetch kan het 
 *  resultaat van niveau 3 voor een kleine vector iets verbeteren. Maar naargelang de lengte 
 *  van de vector groter wordt is dit verschil niet meer meetbaar.
 *
 *  PARALLEL
 *  met volgende flags: -D_GLIBCXX_PARALLEL -fopenmp -pthread -DUSEOMP -O0 : sort parallel_O0
 *  met volgende flags: -D_GLIBCXX_PARALLEL -fopenmp -pthread -DUSEOMP -O0 : sort parallel_O0 with 2 threads
 *  met volgende flags: -D_GLIBCXX_PARALLEL -fopenmp -pthread -DUSEOMP -O0 : sort parallel_O0 with 3 threads 
 *  met volgende flags: -D_GLIBCXX_PARALLEL -fopenmp -pthread -DUSEOMP -O3 : HW_part1_par_l3.out
 *
 *  PDF: HW_part1_sort_parallel.pdf
 *  Zoals al te verwachten valt is de 00 optimalisatie merkwaardig slechter dan 
 *  de 03 optimalisatie voor alle groottes van vectors. Daarnaast zal het toenemen van het aantal threads
 *  pas maar vannaf een zekere grote een verschil geven.
 *
 * DEEL2:
 * -HW_part2_lib.cpp/hpp bevatten de inline en klassieke versie van de functie foo
 * -HW_part2_lib.cpp bevat de testen 
 *   
 *  VECTORSIZE=1000
 *
 *              O0                          03
 *  4.367451e-06+-6.319403e-14  1.419998e-06+-3.353266e-14
 *  4.372778e-06+-6.982147e-14  1.747808e-07+-2.812315e-17 
 *  
 *  DEEL3
 *  -HW_part3_main.cpp: alles van opdracht 3 zit in dit source bestand
 *
 *  parallel:
 *  met volgende flags: -Wall -std=c++14 -lstdc++  -D_GLIBCXX_PARALLEL -fopenmp -pthread -DUSEOMP : inner product parallel_O0
 *  met volgende flags: -Wall -std=c++14 -lstdc++  -D_GLIBCXX_PARALLEL -fopenmp -pthread -DUSEOMP : inner product parallel_O3
 *
 *  serie:
 *  met volgende flags: -Wall -std=c++11 : inner product serial_O0
 *  met volgende flags: -Wall -std=c++11 -O3 -ffast-math : inner product serial_O3
 *
 *  PDF: HW_part3.pdf
 *  De serieele geoptimaliseerde versie blijkt uiteindelijk de snelste te zijn. 
 *  Het quicksort algoritme is super snel in serie, maar hard te paralleliseren.
 *
 *
 */
#include<iostream>
#include<cassert>
#include<vector>
#include "stdio.h"

#include <algorithm>
#include <random>
#include "math.h"
#include <parallel/algorithm>

#include "mean_dev.hpp"

int main(int argc, char** argv){
    int sizeVector = atoi(*(++argv));
    int numberOfSimulations= atoi(*(++argv));
    int numberOfDiscarted= atoi(*(++argv));

    std::vector<double> time(numberOfSimulations-numberOfDiscarted);
    std::vector<int> v(sizeVector);

    /* fill the vector with 1,2,3... */
    std::iota(v.begin(),v.end(),1);
    
    for(int i_time=0;i_time<numberOfSimulations-1;i_time++)
    {
        /* shuffle the entire vector */
        std::shuffle(v.begin(), v.end(), std::mt19937{std::random_device{}()});
        struct timespec l_start, l_end;

        clock_gettime(CLOCK_MONOTONIC, &l_start);
        #ifdef GNU_PAR
        /* extra routine, do these make any difference? they dont really here*/
            __gnu_parallel::sort(v.begin(), v.end());
        #else
            std::sort (v.begin(), v.end()); 
        #endif
        clock_gettime(CLOCK_MONOTONIC, &l_end);

        /* if its not a discarted simulation, save the time adjust the index accordingly */
        if(i_time>=numberOfDiscarted)
            time[i_time-numberOfDiscarted] =(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0;
    }

    /* calculate and print out the standard deviation and the mean */
    double mean;
    double stdev;

    mean_and_dev(time,mean,stdev);

    printf("%d %e %e \n",sizeVector,mean,stdev);

}

