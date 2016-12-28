#ifndef vector_expressions_hpp
#define vector_expressions_hpp

#include <vector>
#include <cassert>
#include <cmath>
#include <iostream>
#include <type_traits>
#include <algorithm>
#include <random>
#include <chrono>
#include "vector.hpp"

namespace tws{
    template<typename V1, typename V2>
    class vector_sum {
        public:
            typedef int size_type ;
            vector_sum( V1 const& v1, V2 const& v2)
                : v1_(v1),v2_(v2)
            {}
            auto operator[](int i) const
            {return v1_(i)+v2_(i);}
            auto operator()(int i) const
            {return v1_(i)+v2_(i);}
        size_t size() const { return v1_.size() ; }
        private:
            V1 const& v1_ ;
            V2 const& v2_ ;
    };
    template<typename V1, typename V2>
    class vector_diff {
        public:
            typedef int size_type ;
            vector_diff( V1 const& v1, V2 const& v2)
                : v1_(v1),v2_(v2)
            {}
            auto operator[](int i) const
            {return v1_(i)-v2_(i);}
        size_t size() const { return v1_.size() ; }

        //inline decltype(auto) cbegin() const {return v1_.cbegin()-v2_.cbegin();}
        //inline decltype(auto) cend() const {return v1_.cend()-v2_.cend() ;}
        private:
            V1 const& v1_ ;
            V2 const& v2_ ;
    };

    /* 
     * the first parameter should be an array,
     * the second should be just a number
     */
    template<typename V1, typename V2>
    class vector_mul {
        public:
            typedef int size_type ;
            vector_mul( V1 const& v1, V2 const v2)
                : v1_(v1),v2_(v2)
            {}
            auto operator[](int i) const
            {return v2_*v1_[i];}
            auto operator()(int i) const
            {
                assert(i<v1_.size());
                return v2_*v1_(i);
            }
        size_t size() const { return v1_.size() ; }
        private:
            V1 const& v1_ ;
            V2 const v2_ ;
    };
}
#endif

