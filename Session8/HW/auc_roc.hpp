#ifndef tws_auc_roc_hpp
#define tws_auc_roc_hpp
//(C) Copyright Karl Meerbergen Yuya Suzuki & Joris Tavernier, 2016.


#include <type_traits>
namespace tws {
    
    template<typename V,typename T,typename S=double>
    decltype(auto) auc_roc(V const& prediction, T const& exact, S stepsize=1e-4){
        typedef typename V::value_type value_type;
        typedef typename V::size_type size_type;
        assert(prediction.size()==exact.size()); 

        
        
        size_type N=prediction.size();
        size_type N1=std::accumulate(exact.cbegin(),exact.cend(),0);
        size_type N0=N-N1;
        value_type xiyi=0.;
        value_type xi=0.; 
        value_type yi=0;       
        for(size_type i=0;i<prediction.size();i++){
            xiyi+=prediction[i]*exact[i];
            xi+=prediction[i];
            yi+=exact[i];
        }
        
        auto corr=N*xiyi-yi*xi;
        value_type min=*std::min_element(prediction.cbegin(), prediction.cend());
        value_type max=*std::max_element(prediction.cbegin(), prediction.cend());


        V scaled_pred(prediction);
            
        if(corr>=0){
            std::transform(prediction.cbegin(), prediction.cend(),scaled_pred.begin(),[min,max](auto v){return (v-min)/(max-min);});
        } else{
            std::transform(prediction.cbegin(), prediction.cend(),scaled_pred.begin(),[min,max](auto v){return -(v-min)/(max-min)+1.0;});
        }    
       
       value_type auc_roc=0.0; 
       value_type fprate=0.0;    
       value_type rocval=0.0;  
       size_type true_positive=0;
       size_type false_positive=0;  
       for (S roc = 1.0; roc> 0.0-stepsize; roc-=stepsize){
            true_positive=0,false_positive=0;
            for(size_type i=0;i<prediction.size();i++){
               if(scaled_pred[i] > roc ){
                  if(exact[i]==1){
                     true_positive++;
                  }
                  else{
                     false_positive++;
                  }
               }
            }
            auc_roc+=(true_positive/((value_type) N1)+rocval)/2.0*(false_positive/((value_type) N0) -fprate);
            rocval=true_positive/((value_type) N1);
            fprate=false_positive/((value_type) N0);
       }//roc curve
       return auc_roc;
   }



}
#endif
