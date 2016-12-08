#ifndef tws_read_hpp
#define tws_read_hpp
//(C) Copyright Karl Meerbergen Yuya Suzuki & Joris Tavernier, 2016.

#include <fstream>
#include <type_traits>
namespace tws {


  template<class M, typename S>
  M matrix_read(const S & filename){
     std::ifstream ifs(filename);

     if (!ifs) {
        std::cerr << "Can not open file: "<<filename<<std::endl;
        throw new std::runtime_error("Can not open given filename");
     }
     typename M::size_type rows=0;
     typename M::size_type columns=0;

     ifs>>rows;
     ifs>> columns;
     M m(rows,columns,0);
     while(!ifs.eof()) {
        for(typename M::size_type i = 0;i<rows;i++){
           for(typename M::size_type j = 0;j<columns;j++){
             ifs>>m(i,j);
           }
        }
     }
     ifs.close();
     return m;
  }

  template<class V, typename S>
  V vector_read(const S & filename){
     std::ifstream ifs(filename);

     if (!ifs) {
        std::cerr << "Can not open file: "<<filename<<std::endl;
        throw new std::runtime_error("Can not open given filename");
     }
     typename V::size_type nb_elements=0;

     ifs>>nb_elements;

     V v(nb_elements,0);
     while(!ifs.eof()) {
        for(typename V::size_type i = 0;i<nb_elements;i++){
             ifs>>v[i];
        }
     }
     ifs.close();
     return v;
  }
}

#endif
