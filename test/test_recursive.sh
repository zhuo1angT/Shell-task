#!/bin/bash

N=$1
RET=1

function multi()
{
    local LOCAL_N=$1
    local LOCAL_N_SUB_1=$(($LOCAL_N - 1))

    if [ $LOCAL_N_SUB_1 -lt 1 ]
    then
        RET=1
    else
        multi $LOCAL_N_SUB_1
        RET=`expr $LOCAL_N \* $RET`
    fi
}

multi $N

echo $RET
