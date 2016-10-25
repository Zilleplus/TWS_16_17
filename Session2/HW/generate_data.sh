#!/bin/bash

echo 'compiling the tools'
make clean
make

echo 'generating data part1'
i_max=18
numberOfSim=1000
numberOfDiscarted=100
dataLocation="./data/part1"

rm $dataLocation/*
for i in `seq 1 $i_max`; do ./HW_part1.out $((2**$i)) $numberOfSim $numberOfDiscarted  ; done | tee "$dataLocation/HW_part1_serial"
for i in `seq 1 $i_max`; do ./HW_part1_sec_level3.out $((2**$i)) $numberOfSim $numberOfDiscarted ; done | tee "$dataLocation/HW_part1_serial_level3"
for i in `seq 1 $i_max`; do ./HW_part1_sec_max_opt.out $((2**$i)) $numberOfSim $numberOfDiscarted ; done | tee "$dataLocation/HW_part1_sec_max_opt"

for i in `seq 1 $i_max`; do ./HW_part1_par.out $((2**$i)) $numberOfSim $numberOfDiscarted ; done | tee "$dataLocation/HW_part1_parallel"
for i in `seq 1 $i_max`; do OMP_NUM_THREADS=2 ./HW_part1_par.out $((2**$i)) $numberOfSim $numberOfDiscarted ; done | tee "$dataLocation/HW_part1_parallel_t2"
for i in `seq 1 $i_max`; do OMP_NUM_THREADS=3 ./HW_part1_par.out $((2**$i)) $numberOfSim $numberOfDiscarted ; done | tee "$dataLocation/HW_part1_parallel_t3"

for i in `seq 1 $i_max`; do ./HW_part1_par_l3.out $((2**$i)) $numberOfSim $numberOfDiscarted ; done | tee "$dataLocation/HW_part1_level3_parallel"
for i in `seq 1 $i_max`; do OMP_NUM_THREADS=2 ./HW_part1_par_l3.out $((2**$i)) $numberOfSim $numberOfDiscarted ; done | tee "$dataLocation/HW_part1_parallel_level3_t2"
for i in `seq 1 $i_max`; do OMP_NUM_THREADS=3 ./HW_part1_par_l3.out $((2**$i)) $numberOfSim $numberOfDiscarted ; done | tee "$dataLocation/HW_part1_parallel_level3_t3"

echo 'generating data part2'
numberOfSim=5000
numberOfDiscarted=50
dataLocation="./data/part2"
sizeVector=1000

rm $dataLocation/*
echo 'in cpp level0:' | tee "$dataLocation/data_sim_part2" 
./HW_part2_l0.out $sizeVector $numberOfSim numberOfDiscarted | tee -a  "$dataLocation/data_sim_part2"
echo 'in cpp level3:' | tee -a "$dataLocation/data_sim_part2" 
./HW_part2_l3.out $sizeVector $numberOfSim numberOfDiscarted | tee -a  "$dataLocation/data_sim_part2"
echo 'in hpp level0:' | tee -a "$dataLocation/data_sim_part2" 
./HW_part2_l0_opti.out $sizeVector $numberOfSim numberOfDiscarted | tee -a "$dataLocation/data_sim_part2"
echo 'in hpp level3:' | tee -a  "$dataLocation/data_sim_part2" 
./HW_part2_l3_opti.out $sizeVector $numberOfSim numberOfDiscarted | tee -a "$dataLocation/data_sim_part2"

echo 'generating data part3'
#i_max=8
numberOfSim=500
numberOfDiscarted=50
dataLocation="./data/part3"

rm $dataLocation/*
for i in `seq 1 $i_max`; do ./HW_part3_par.out $((2**$i)) $numberOfSim numberOfDiscarted  ; done | tee "$dataLocation/HW_part3_par"
for i in `seq 1 $i_max`; do ./HW_part3_par_l3.out $((2**$i)) $numberOfSim numberOfDiscarted  ; done | tee "$dataLocation/HW_part3_par_level3"
for i in `seq 1 $i_max`; do ./HW_part3_serial.out $((2**$i)) $numberOfSim numberOfDiscarted  ; done | tee "$dataLocation/HW_part3_serial"
for i in `seq 1 $i_max`; do ./HW_part3_serial_level3.out $((2**$i)) $numberOfSim numberOfDiscarted  ; done | tee "$dataLocation/HW_part3_serial_level3"
