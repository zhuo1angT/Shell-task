#!/bin/bash


read -a tao
i=0
while [ $i -lt 3 ]
do
    echo ${tao[i]}
    i=$((i+1))
done
