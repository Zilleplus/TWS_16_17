#include "HW_part2_lib.hpp" 

#include "stdio.h"

#include <vector>
#include "math.h"
#include <algorithm>
#include <random>

#include "HW_part2_lib.hpp"
#include "mean_dev.hpp"

void foo(int&);
int main(int argc, char** argv){
    //char functionType = **(++argv);
    int sizeVector = atoi(*(++argv));
    int numberOfSimulations= atoi(*(++argv));
    int numberOfDiscarted= atoi(*(++argv));
    struct timespec l_start, l_end;

    std::vector<double> time(numberOfSimulations-numberOfDiscarted);
    std::vector<int> v(sizeVector);

    std::iota(v.begin(),v.end(),1);

    for(int i_time=0;i_time<numberOfSimulations-1;i_time++)
    {
        std::shuffle(v.begin(), v.end(), std::mt19937{std::random_device{}()});
        clock_gettime(CLOCK_MONOTONIC, &l_start);
        for(int i_increment=0;i_increment<sizeVector;i_increment++){
        #ifndef opti
            foo(v[i_increment]);
        #else
            inlineFunctions::foo(v[i_increment]);
        #endif
        }
        clock_gettime(CLOCK_MONOTONIC, &l_end);

        if(i_time>=numberOfDiscarted)
            time[i_time-numberOfDiscarted] =(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0;
    }

    double mean;
    double stdev;

    mean_and_dev(time,mean,stdev);

    printf("%d %e %e \n",sizeVector,mean,stdev);
}

void foo(int& numberToIncrement){
    numberToIncrement++;
}
