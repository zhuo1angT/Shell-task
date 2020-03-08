#!/bin/bash

# shellcheck disable=SC2002


# test the efficiency of "jq parse"

cd "data" || return 

n=100
for ((i=0; i < n; i++)); do

    name=$(cat 1.json | jq -r .name) 

done