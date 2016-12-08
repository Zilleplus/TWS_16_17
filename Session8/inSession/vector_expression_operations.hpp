#include"vector_expressions.hpp"
#ifndef vector_expressions_operations_hpp
#define vector_expressions_operations_hpp
namespace tws{
    template<typename V1,typename V2>
    inline tws::vector_sum<V1,V2> operator+(V1 const& v1, V2 const& v2){
        return tws::vector_sum<V1,V2>(v1,v2);
    }
    template<typename V1,typename V2>
    inline tws::vector_diff<V1,V2> operator-(V1 const& v1, V2 const& v2){
        return tws::vector_diff<V1,V2>(v1,v2);
    }
    template<typename V1,typename V2>
    inline tws::vector_mul<V1,V2> operator*(V2 v2,V1 const& v1){
        return tws::vector_mul<V1,V2>(v1,v2);
    }
}
#endif
