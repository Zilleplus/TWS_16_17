#!/bin/bash

echo "-- RUN.SH testing different values on the algo"
echo -e "-577.0 \n 13.0" | ./a.out

small=$(echo '2^-4' | bc)

declare -a b=(10 100 1000 -10 -100 -1000 10 100 1000 -10 -100 -1000)
declare -a c=(1 100 1000 10 100 1000 -10 -100 -1000 -10 -100 -1000)

# get length of an array, b and c should have the same lenght, it makes no sense to do itotherwise
arraylength=${#b[@]}

# use for loop to read all values and indexes
for (( i=0; i<${arraylength}; i++ ));
do
    echo " "
    echo "b=${b[$i]} and c=${c[$i]}" 
    echo -e "${b[$i]} \n ${b[$i]}" | ./a.out
done


