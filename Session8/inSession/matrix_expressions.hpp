#ifndef TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP
#define TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP
namespace tws{
    template<typename V1, typename V2>
    class matrixSum{
    public:
        typedef int     size_type ;

        matrixSum( V1 const& v1, V2 const& v2)
        : v1_(v1),v2_(v2)
        {}
        auto operator()(int i, int j) const
        {return (v1_(i,j)+v2_(i,j));}
//        size_type size() const { return v1_.size() ; }
    private:
        V1 const& v1_ ;
        V2 const& v2_ ;
    };

}

#endif //TWS_CPP_VECTORS_MATRIX_EXPRESSIONS_HPP
