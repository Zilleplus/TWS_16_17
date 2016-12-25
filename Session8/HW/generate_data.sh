#!/bin/bash
g++ -std=c++14 -DNDEBUG -O3 time_xtx.cpp -o noTemp.out
g++ -std=c++14 -DNDEBUG -DwithTemp -O3 time_xtx.cpp -o withTemp.out

rm *.data
i_max=$1

numberOfSimulations=100
numberOfDiscarted=10

for i in `seq 1 $i_max`; do ./withTemp.out $((2**$i)) $numberOfSimulations $numberOfDiscarted  ; done | tee withTemp.data
for i in `seq 1 $i_max`; do ./noTemp.out $((2**$i)) $numberOfSimulations $numberOfDiscarted  ; done | tee noTemp.data
