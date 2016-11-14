#!/bin/bash
rm *.data
i_max=18
for i in `seq 1 $i_max`; do ./poissonFloat.out $((2**$i))   ; done | tee floats.data
for i in `seq 1 $i_max`; do ./poissonDouble.out $((2**$i))   ; done | tee double.data
for i in `seq 1 $i_max`; do ./poissonLongDouble.out $((2**$i))   ; done | tee longDouble.data

