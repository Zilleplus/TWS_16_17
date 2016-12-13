#ifndef TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP
#define TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP

namespace tws{
    //template<typename V>
    //inline tws::matrixTranspose<V> tranpose(tws::matrix<V>);
    /*
    template<typename V1, typename V2>
    class matrixSum{
    public:
        typedef int     size_type ;

        matrixSum( V1 const& v1, V2 const& v2)
        : v1_(v1),v2_(v2)
        {}
        auto operator()(int i, int j) const
        {return (v1_(i,j)+v2_(i,j));}
    private:
        V1 const& v1_ ;
        V2 const& v2_ ;
    };
    */
    template<typename T>
    class matrixTranspose{
        public:
            typedef int     size_type ;
            typedef T       value_type;
            typedef tws::matrix<T> matrix_type;

            matrixTranspose( matrix_type const& data)
            : data_(data) 
            {}
            auto operator()(int i, int j) const
            {return data_(j,i);}
        private:
            matrix_type const& data_ ;
    };

}

#endif //TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP
