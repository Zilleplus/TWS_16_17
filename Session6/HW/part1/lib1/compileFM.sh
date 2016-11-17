#!/bin/bash

gfortran fmsave.f95  -c -O3
gfortran FM.f95  -c -O3
gfortran FMZM90.f95  -c -O3
gfortran TestFM.f95  -c -O3
gfortran  fmsave.o  FM.o  FMZM90.o  TestFM.o  -o TestFM.out

./TestFM.out
