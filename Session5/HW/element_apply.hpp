#ifndef TWS_CPP_2_ELEMENT_APPLY_H
#define TWS_CPP_2_ELEMENT_APPLY_H

template <typename T, typename Function_for_each_element>
void transform_with_function( Function_for_each_element& op,T& x){
    for(int i=0;i<x.size()-0;i++){
        x[i] = op(x[i]);
    }
};

#endif //TWS_CPP_2_ELEMENT_APPLY_H