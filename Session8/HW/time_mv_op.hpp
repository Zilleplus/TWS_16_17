#ifndef tws_time_mv_op_hpp
#define tws_time_mv_op_hpp
#include "vector.hpp"
#include <time.h>
/*
Basic functionality to time the the given operation MV_OP

@param N is the size of the matrix in the matrix-vector multiplication

the given operation is called by op(x,y) with x and y vectors.

*/

namespace tws{
template<typename MV_OP>
int time_mv(MV_OP const & op, int N, int number_exp=100, int discard=5) {
  struct timespec l_start, l_end;
  double elapsed_time=0.;
  double average_time=0.;
  double squared_time=0.;
  double time_diff=0.;

  tws::vector<double> y(N,1.0);
  tws::vector<double> x(N,1.0);

  for(int exp=0;exp<number_exp+discard;exp++){
    clock_gettime(CLOCK_MONOTONIC, &l_start);
    op(x,y);
    clock_gettime(CLOCK_MONOTONIC, &l_end);
    if(exp>=discard){
       elapsed_time=(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0; 
       time_diff=elapsed_time-average_time;
       average_time+=time_diff/(exp-discard+1);
       squared_time+=time_diff*(elapsed_time-average_time);
    }
    y[0]+=y[0];
  }
  std::cout<<N<<" "<<average_time<<" "<<std::sqrt(squared_time/(number_exp-1))<<std::endl;
  return 0 ;
}
 
}
#endif
