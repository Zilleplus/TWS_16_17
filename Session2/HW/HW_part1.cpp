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

    std::iota(v.begin(),v.end(),1);
    
    for(int i_time=0;i_time<numberOfSimulations-1;i_time++)
    {
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

        if(i_time>=numberOfDiscarted)
            time[i_time-numberOfDiscarted] =(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0;
    }

    double mean;
    double stdev;

    mean_and_dev(time,mean,stdev);

    /*
    std::cout << "the mean: " << mean <<"\n";
    std::cout << " the stdev: " << stdev << "\n";
    */
    printf("%d %e %e \n",sizeVector,mean,stdev);

}

