#include "stdio.h"

#include <vector>
#include "math.h"
#include <algorithm>
#include <random>

#include "HW_part2_lib.hpp"
#include "mean_dev.hpp"

#ifdef USEOMP
#include <omp.h>
#endif

int inner_prod_par(std::vector<int>,std::vector<int>);

int main(int argc, char** argv){
    int sizeVector = atoi(*(++argv));
    int numberOfSimulations= atoi(*(++argv));
    int numberOfDiscarted= atoi(*(++argv));

    struct timespec l_start, l_end;

    std::vector<double> time(numberOfSimulations-numberOfDiscarted);
    std::vector<int> v1(sizeVector),v2(sizeVector) ;

    std::iota(v1.begin(),v1.end(),1);
    std::iota(v2.begin(),v2.end(),1);

    int innerProduct=0;

    for(int i_time=0;i_time<numberOfSimulations-1;i_time++)
    {
        /* shuffle each vector to make sure the result is not predictable on the second loop */
        std::shuffle(v1.begin(), v1.end(), std::mt19937{std::random_device{}()});
        std::shuffle(v2.begin(), v2.end(), std::mt19937{std::random_device{}()});

        clock_gettime(CLOCK_MONOTONIC, &l_start);
        #ifdef USEOMP
            innerProduct = inner_prod_par(v1,v2);
        #else
            innerProduct = inner_product( v1.begin(), v1.end(), v2.begin(), 0 );
        #endif

        clock_gettime(CLOCK_MONOTONIC, &l_end);

        if(i_time>=numberOfDiscarted)
            time[i_time-numberOfDiscarted] =(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0;
    }

    double mean;
    double stdev;

    mean_and_dev(time,mean,stdev);

    /* print the inner product to the outputstream to avoid certain optimilisations */
    fprintf(stderr, "%d" , innerProduct);
    printf("%d %e %e \n",numberOfSimulations,mean,stdev);
}

int  inner_prod_par(std::vector<int> leftVector,std::vector<int> rightVector){
    int sum=0;
    #ifdef USEOMP
        #pragma omp parallel for reduction(+:sum)
    #endif
    for(std::size_t i=0;i<leftVector.size();i++){
        sum = leftVector[i] * rightVector[i];
    }
    return sum;
}
