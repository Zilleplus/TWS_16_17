#ifndef tws_matrix_hpp
#define tws_matrix_hpp

#include <cassert>
#include <type_traits>

namespace tws {

//TODO; minimal requirement for the given io-functionality
//      will require more functionality for the expression templates

  template <typename T>
  class matrix {
    public:
      typedef T  value_type ;
      typedef int     size_type ;

    public:

      //TODO implementation: matrix constructor that construct an m by n matrix filled with the given value
      inline matrix( size_type m, size_type n, T val ){
      } 

      inline value_type operator()(size_type i,size_type j) const { 
        //TODO implementation: return matrix element with i the row and j the column
      }

      inline value_type& operator()(size_type i,size_type j) {
        //TODO implementation: return matrix element with i the row and j the column
      }
  } ;


}

#endif
