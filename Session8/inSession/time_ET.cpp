#include "vector.hpp"
#include <time.h>
/*
Use the option -DEXPR during compilation to use expression templates
*/
#ifdef EXPR
#include "vector_expressions.hpp"
#include "vector_expression_operations.hpp"
#else
#include "vector_operations.hpp"
#endif
		

int main() {
  int n=50000;
  int number_exp=200;
  int discard=5;

  struct timespec l_start, l_end;
  tws::vector<double> b_0(n,0.) ;
  tws::vector<double> b_1(n,0.) ;
  tws::vector<double> b_2(n,0.) ;
  tws::vector<double> b_3(n,0.) ;
  b_1.randomize();
  b_2.randomize();
  b_3.randomize();
  double elapsed_time=0.;
  double average_time=0.;
  double squared_time=0.;
  double time_diff=0.;

  for(int exp=0;exp<number_exp+discard;exp++){
    clock_gettime(CLOCK_MONOTONIC, &l_start);
    b_0=b_3+b_1+b_2+2.0*b_1-b_3+b_2+3.0*b_1-b_2+b_3+3.0*b_1;
    clock_gettime(CLOCK_MONOTONIC, &l_end);
    if(exp>=discard){
       elapsed_time=(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1000000000.0; 
       time_diff=elapsed_time-average_time;
       average_time+=time_diff/(exp-discard+1);
       squared_time+=time_diff*(elapsed_time-average_time);
    }
    b_0[0]+=b_0[0];
  }
  std::cout<<"Time(s): "<<average_time<<" "<<std::sqrt(squared_time/(number_exp-1))<<std::endl;
  return 0 ;
} 
