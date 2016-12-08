#include "matrix.hpp"
#include "matrix_expressions.hpp"

#ifndef TWS_CPP_VECTORS_MATRIX_EXPRESSION_OPERATIONS_HPP_HPP
#define TWS_CPP_VECTORS_MATRIX_EXPRESSION_OPERATIONS_HPP_HPP

namespace tws {
    template<typename V1, typename V2>
    inline tws::matrixSum<V1, V2> operator+(V1 const &v1, V2 const &v2) {
        return tws::matrixSum<V1, V2>(v1, v2);
    }
}
#endif //TWS_CPP_VECTORS_MATRIX_EXPRESSION_OPERATIONS_HPP_HPP
