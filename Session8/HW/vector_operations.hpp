#ifndef tws_vector_operations_hpp
#define tws_vector_operations_hpp
#include <cassert>
#include <cmath>

namespace tws {

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

}
#endif
