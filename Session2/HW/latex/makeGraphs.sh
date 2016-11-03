#!/bin/bash

pdflatex -shell-escape -interaction=nonstopmode HW_part1_sort_sequential.tex
pdflatex -shell-escape -interaction=nonstopmode HW_part1_sort_parallel.tex
pdflatex -shell-escape -interaction=nonstopmode HW_part3.tex

mv ./*.pdf ../graphs/
mv ./*.aux ./aux_files
mv ./*.log ./logs
