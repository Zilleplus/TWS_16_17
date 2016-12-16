#!/bin/bash
rm *.data
i_max=$1

numberOfSimulations=50
numberOfDiscarted=10

for i in `seq 1 $i_max`; do ./withTemp.out $((2**$i)) $numberOfSimulations $numberOfDiscarted  ; done | tee withTemp.data
for i in `seq 1 $i_max`; do ./noTemp.out $((2**$i)) $numberOfSimulations $numberOfDiscarted  ; done | tee noTemp.data
