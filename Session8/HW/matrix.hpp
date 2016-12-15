#ifndef tws_matrix_hpp
#define tws_matrix_hpp

#include <cassert>
#include <type_traits>
#include <iostream>
#include <vector>
#include "vector.hpp"
namespace tws {

//TODO; minimal requirement for the given io-functionality
//      will require more functionality for the expression templates

    template<typename T>
    class matrix {
    public:
        typedef T value_type;
        typedef int size_type;

    public:
        inline matrix(size_type m, size_type n, value_type val) 
            : data_(m * n, val), num_row(m), num_col(n) {}


        inline size_type num_columns() const { return num_col; }
        inline size_type num_rows() const { return num_row; }

        /*
         * return the element on the i'th row and the j'th column
         */
        inline value_type operator()(const size_type i, const size_type j) const {
            assert(i<this->num_rows());
            assert(j<this->num_columns());
            return data_[i + num_row * j];
        }
        inline value_type &operator()(size_type i, size_type j) {
            assert(i<this->num_rows());
            assert(j<this->num_columns());
            return data_[i + num_row * j];
        }

        friend std::ostream &operator<<(std::ostream &ostr, matrix<T> const &m) {
            ostr << "(" << m.num_rows() << "," << m.num_columns()<< ")" << "\n";
            for (size_type i = 0; i < m.num_rows(); ++i) {
                ostr << "[ ";
                for (size_type j = 0; j < m.num_columns(); ++j) {
                    ostr << m(i, j) << " ";
                }
                ostr << "]" << "\n";
            }
            return ostr;
        }

        template<typename Matrix>
        inline void operator=(Matrix const &v) {
            for (size_type i = 0; i < num_rows(); ++i) {
                for (int j = 0; j < num_columns(); ++j) {
                    data_[i+j*num_row] = v(i,j);
                }
            }
        }

    private:
        std::vector<value_type> data_;
        size_type num_row;
        size_type num_col;
    };
}

#endif
