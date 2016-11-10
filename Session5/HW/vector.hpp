#ifndef tws_vector_hpp
#define tws_vector_hpp
//(C) Copyright Karl Meerbergen, Gowri Suryanarayana, Yuya Suzuki & Joris Tavernier, 2016.


#include <vector>
#include <cassert>
#include <cmath>
#include <iostream>
#include <type_traits>
#include <algorithm>
#include <random>
#include <chrono>

namespace tws {
  template <typename T>
  class vector {
    private:
      typedef std::vector<T> data_type ;
     
    public:
      typedef T  value_type ;
      typedef int     size_type ;
      //typedef data_type::size_type size_type ;

    public:
      inline vector( size_type n )
      : data_( n )
      {}

      inline vector( size_type n, T val )
      : data_( n,val )
      {}

      vector( vector<T> const& v )
      : data_( v.data_ )
      { }


      template <typename Vector>
      vector( Vector const& v )
      : data_( v.size() )
      {
        for (size_type i=0; i<size(); ++i) { data_[i] = v[i] ; }
      }

      inline size_type size() const { return data_.size() ; }

      inline value_type operator[](size_type i) const { return data_[i] ; }

      inline value_type& operator[](size_type i) { return data_[i] ; }

      template <typename Vector>
      inline void operator-=(Vector const& v ) {
         assert(this->size()==v.size());
         for (size_type i=0; i<size(); ++i) { data_[i] = data_[i]-v[i] ; }
      }

      template <typename Vector>
      inline void operator+=(Vector const& v ) { 
         assert(this->size()==v.size());
         for (size_type i=0; i<size(); ++i) { data_[i] = data_[i]+v[i] ; }
      }

      decltype(auto) begin(){return data_.begin();} 
     
      decltype(auto) end(){return data_.end();}    

      size_type size(){return (size_type) data_.size();}        

      void randomize(){
         int seed = 1;
         #ifdef NDEBUG
            seed = std::chrono::system_clock::now().time_since_epoch().count();
         #endif
         auto engine = std::default_random_engine(seed);
         std::uniform_real_distribution<value_type> distribution(0.0,1.0);
         for (size_type i=0; i<size(); ++i) { data_[i] =distribution(engine) ; }
      }      

    public:
      friend std::ostream& operator<<( std::ostream& ostr, vector<T> const& v ) {
        ostr << "(" << v.size() << ")[" ;
        for (int i=0; i<v.size(); ++i) {
          ostr << v[i] << "," ;
        }
          ostr << "]" ;
        return ostr ;
      }

    private:
      data_type data_ ;

  } ;



//inefficient implementation of operators, use expression templates (see session 3 of C++)
  template <typename S,typename V>
  inline  decltype(auto) operator*( S const& s, V const& v ) {
      V res(v.size(),0.);
      for (typename V::size_type i=0;i<v.size();i++) res[i]=s*v[i];
      return res;
  }
  template <typename V1,typename V2,typename std::enable_if<std::is_same< typename std::common_type<typename V1::value_type, typename V2::value_type>::type, typename V1::value_type >::value || (std::is_same<typename V1::value_type, typename V2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator+( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V1 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res[i]=v1[i]+v2[i];
      return res;
  }

  template <typename V1,typename V2, typename std::enable_if<std::is_same< typename std::common_type<typename V1::value_type, typename V2::value_type>::type, typename V2::value_type >::value && !(std::is_same<typename V1::value_type, typename V2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator+( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V2 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res[i]=v1[i]+v2[i];
      return res;
  }

  template <typename V1,typename V2,typename std::enable_if<std::is_same< typename std::common_type<typename V1::value_type, typename V2::value_type>::type, typename V1::value_type >::value || (std::is_same<typename V1::value_type, typename V2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator-( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V1 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res[i]=v1[i]-v2[i];
      return res;
  }

  template <typename V1,typename V2, typename std::enable_if<std::is_same< typename std::common_type<typename V1::value_type, typename V2::value_type>::type, typename V2::value_type >::value && !(std::is_same<typename V1::value_type, typename V2::value_type>::value),bool >::type=true>
  inline  decltype(auto) operator-( V1 const& v1, V2 const& v2 ) {
      assert(v1.size()==v2.size());
      V2 res(v1.size(),0.);
      for (typename V1::size_type i=0;i<v1.size();i++) res[i]=v1[i]-v2[i];
      return res;
  }

  template<typename V1, typename V2>
  inline decltype(auto) inner_product(V1 const& v1, V2 const& v2){
      assert(v1.size()==v2.size());
      decltype(v1[0]*v2[0]) sum=0; 
      for (typename V1::size_type i=0;i<v1.size();i++) sum+=v1[i]*v2[i];
      return sum;
  }
  template<typename V1>
  inline decltype(auto) norm_2(V1 const& v1){
      return std::sqrt(inner_product(v1,v1));
  }

}

#endif
