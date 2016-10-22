#!/bin/bash

echo 'compiling the tools'
# make

echo 'generate the data'

#part 1

echo 'generating data part1'
echo '' > ./data/part1/HW_part1_serial 
for i in `seq 1 10`; do ./HW_part1.out $((2**$i)) 500 10  ; done | tee ./data/part1/HW_part1_serial
echo '' > ./data/part1/HW_part1_parallel
for i in `seq 1 10`; do ./HW_part1_par.out $((2**$i)) 500 10  ; done | tee ./data/part1/HW_part1_parallel

echo 'generating data part2'
mp=10
numberOfSim=5000
echo '' > ./data/part1/HW_part2_l0
for i in `seq 1 $mp`; do ./HW_part2_l0.out $((2**$i)) $numberOfSim 10  ; done | tee ./data/part1/HW_part2_l0
echo '' > ./data/part1/HW_part2_l3
for i in `seq 1 $mp`; do ./HW_part2_l3.out $((2**$i)) $numberOfSim 10  ; done | tee ./data/part1/HW_part2_l3
echo '' > ./data/part1/HW_part2_i_l0
for i in `seq 1 $mp`; do ./HW_part2_l0_opti.out $((2**$i)) $numberOfSim 10  ; done | tee ./data/part1/HW_part2_i_l0
echo '' > ./data/part1/HW_part2_i_l3
for i in `seq 1 $mp`; do ./HW_part2_l3_opti.out $((2**$i)) $numberOfSim 10  ; done | tee ./data/part1/HW_part2_i_l3




