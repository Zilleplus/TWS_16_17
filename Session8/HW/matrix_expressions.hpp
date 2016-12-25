#ifndef TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP
#define TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP
#include "matrix.hpp"
#include "vector.hpp"
#include <cassert>
namespace tws{
    template<typename T>
    class matrixTranspose{
        public:
            typedef int     size_type ;
            typedef T       matrix_type;
            typedef typename T::value_type value_type;

            matrixTranspose( matrix_type const& data)
            : data_(data) 
            {}
            inline auto operator()(int i, int j) const
            {return data_(j,i);}
            inline auto &operator()(int i, int j) 
            {return data_(j,i);}
            size_type num_columns()const {return data_.num_rows();}
            size_type num_rows()const {return data_.num_columns();}

        private:
            matrix_type const& data_ ;
    };
    template<typename V1, typename V2>
    class matVecProd{
    public:
        typedef int     size_type ;
        typedef V1 matrix_type;
        typedef V2 vector_type;
        typedef typename V1::value_type value_type;

        matVecProd( matrix_type const& mat, vector_type const& vec)
        : matrix_(mat),
          vector_(vec)
        {
            assert(vec.size()==mat.num_columns());
        }
        inline auto operator()(int i) const
        {
            assert(i<size());
            value_type buffer=0;
            for(int index_row_matrix=0;
                    index_row_matrix<vector_.size();
                    index_row_matrix++)
            {
                buffer += vector_(index_row_matrix)*matrix_(i,index_row_matrix);
            }
            return buffer;
        }
        size_type size() const{
            return matrix_.num_rows();
        }
    private:
        matrix_type const& matrix_ ;
        vector_type const& vector_ ;
    };

}
#endif //TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP
