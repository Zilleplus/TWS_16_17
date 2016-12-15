#include "vector.hpp"
#include "matrix.hpp"
#include "cg.hpp"
#include "tws_read.hpp"
#include "auc_roc.hpp"
/*
The vector expressions are needed for CG. 

You will not need the addition, substraction and scalar operators for the matrices. 

Adjust the file names or uncomment these matrix operations to avoid ambiguity (if there is any)

*/
//#ifdef EXPR
#include "vector_expressions.hpp"
#include "vector_expression_operations.hpp"
#include "matrix_expressions.hpp"
#include "matrix_expression_operations.hpp"
//#else
//#include "vector_operations.hpp"
//#include "matrix_operations.hpp"
//#endif
		

int main(int argc, char *argv[]) {

 /* std::string s1("madelon/madelon_train.data");
  auto X=tws::matrix_read<tws::matrix<double>>(s1);
  std::string s2("madelon/madelon_train.labels");
  auto labels=tws::vector_read<tws::vector<double>>(s2);
  std::string s3("madelon/madelon_valid.data");
  auto Xtest=tws::matrix_read<tws::matrix<double>>(s3);
  std::string s4("madelon/madelon_valid.labels");
  auto test_labels=tws::vector_read<tws::vector<int>>(s4);
*/
  std::string s1("gaussian/gaussian_train.data");
  auto X=tws::matrix_read<tws::matrix<double>>(s1);
  std::string s2("gaussian/gaussian_train.labels");
  auto labels=tws::vector_read<tws::vector<double>>(s2);
  std::string s3("gaussian/gaussian_valid.data");
  auto Xtest=tws::matrix_read<tws::matrix<double>>(s3);
  std::string s4("gaussian/gaussian_valid.labels");
  auto test_labels=tws::vector_read<tws::vector<int>>(s4); 



  tws::vector<double> x(X.num_columns(),0.) ; 
  tws::vector<double> b(2,0.) ; 
  //tws::vector<double> b(X.num_columns(),0.) ; 
  tws::vector<double> b_ex(X.num_columns(),0.) ; 
  tws::vector<double> y(X.num_columns(),0.) ; 

  //std::cout << labels << "\n";
  std::cout<<transpose(X).num_columns()<<"\n";
  std::cout<<transpose(X).num_rows()<<"\n";
  std::cout<<labels.size()<<"\n";
  std::cout<<b.size()<<"\n";
  b=multiply(transpose(X),labels);
  //b_ex=b;

  double beta=1e1;
  //std::cout <<X<<"\n";
  //std::cout <<x<<"\n";

  //TODO Define: xtx_op using X
   //y=multiply(transpose(X),multiply(X,x));//+beta*x;
   //y=(transpose(X),multiply(X,x));//+beta*x;
   //y=multiply(X,x);//+beta*x;
   //std::cout << x;
   //y=tws::vector_mul<tws::vector<double>,double>(x,beta);
   //y=beta*x;
 
  
  //tws::cg( xtx_op, x, b, 1.e-10, X.num_columns()*X.num_rows() ) ;

  //xtx_op ( x, b) ;
  //std::cout<<"relative error: "<<tws::norm_2(b-b_ex)/tws::norm_2(b_ex)<<std::endl;


  //tws::vector<double> train_rating(X.num_rows(),1) ; 
  //train_rating=multiply(X,x);
  //std::transform(labels.begin(),labels.end(),labels.begin(),[](auto v){return (v+1)/2;}); 
  //std::cout<<"train auc roc: "<<tws::auc_roc(train_rating,labels)<<std::endl;    

  //tws::vector<double> test_rating(Xtest.num_rows(),1) ; 
  //test_rating=multiply(Xtest,x);
  //std::transform(test_labels.begin(),test_labels.end(),test_labels.begin(),[](auto v){return (v+1)/2;}); 
  //std::cout<<"test auc roc: "<<tws::auc_roc(test_rating,test_labels)<<std::endl;
  return 0 ;
} 
