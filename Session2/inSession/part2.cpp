#include<iostream>
#include<cassert>
#include<vector>


#include <algorithm>
#include <random>
#include "math.h"

//#define stl_opti 0

void mean_and_dev(std::vector<double> const& time,double& mean, double& stdev){
    /* calc the mean */
    mean=0;
    for(std::size_t i=0;i<time.size();i++)
        {
            mean+=time[i];
        }
    mean = mean/time.size();
    for(std::size_t i=0;i<time.size();i++)
        {
            stdev+=pow((time[i]-mean),2);
        }
    stdev = stdev/time.size();
}

int main(){
    int n;
    int m;
    std::cout<<"Enter a positive number"<<std::endl;
    std::cin>>n;
    std::cout<<"Output n= "<<n<<std::endl;
    std::cerr<<"Error n= "<<n<<std::endl;
    std::cout<<"enter the number of discarted";
    std::cin>>m;


    //#ifndef NDEBUG
    assert(n>=0);
    //#endif
    std::vector<int> v(n);

    /* part 1.2 */
    std::iota(v.begin(),v.end(),1);
    std::shuffle(v.begin(), v.end(), std::mt19937{std::random_device{}()});
    
    std::vector<double> time(20);
    for(std::size_t j=m;j<time.size();j++)
    {
        struct timespec l_start, l_end;
        clock_gettime(CLOCK_MONOTONIC, &l_start);
        int buffer=0;
        #ifndef stl_opti
        for(std::size_t i=0;i<v.size();i++)
        {
            buffer+=v[i];
        }
        #else
            buffer = std::accumulate(v.begin(), v.end(), 0);
        #endif

        std::cout<<"the answer is: " <<buffer << "\n";
        clock_gettime(CLOCK_MONOTONIC, &l_end);
        // auto elapsed_time=(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0;
        time[j] =(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0;
    }
    for(std::size_t j=m;j<m+10;j++)
    {
        std::cout << time[j] << "\n";
    }


    double mean;
    double stdev;

    mean_and_dev(time,mean,stdev);

    std::cout << "the mean: " << mean;
    std::cout << " the stdev: " << stdev << "\n";
}



