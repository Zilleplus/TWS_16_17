#ifndef TWS_CPP_VECTORS_MATRIX_EXPRESSION_OPERATIONS_HPP_HPP
#define TWS_CPP_VECTORS_MATRIX_EXPRESSION_OPERATIONS_HPP_HPP

#include "vector.hpp"

namespace tws {
    template<typename V>
    inline tws::matrixTranspose<V> transpose(V m){
        return tws::matrixTranspose<V>(m);
    }
    template<typename V1, typename V2>
    inline  tws::matVecProd<V1,V2> multiply(V1 A, V2 x){
        return tws::matVecProd<V1,V2>(A,x); 
    }
}
#endif //TWS_CPP_VECTORS_MATRIX_EXPRESSION_OPERATIONS_HPP_HPP
