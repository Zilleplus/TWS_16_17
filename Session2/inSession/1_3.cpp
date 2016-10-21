#include "stdio.h"
#include<iostream>
#include<vector>

std::vector<int> add_one_v( std::vector<int>&  v ){
    v[0]+=1;
    return v;
}
void add_one_r( std::vector<int>& v ){
    v[0]+=1;
}

int main(int argc, char* argv[]){

    std::vector<int> v(10);
    std::iota(v.begin(),v.end(),1);
    add_one_v(v);
    add_one_r(v);

}
