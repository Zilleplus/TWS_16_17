#include <vector>
#include "math.h"

void mean_and_dev(std::vector<double> const& time,double& mean, double& stdev){
    mean=0;
    for(std::size_t i=0;i<time.size();i++)
        {
            mean+=time[i];
        }
    mean = mean/time.size();
    
    stdev=0;
    for(std::size_t i=0;i<time.size();i++)
        {
            stdev+=pow((time[i]-mean),2);
        }
    stdev = stdev/time.size();
}

