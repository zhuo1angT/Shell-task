#!/bin/bash

# shellcheck disable=SC1091,SC2162,SC2002


source ./family.sh


function generate_fa_mo()
{
    unset father
    unset mother

    for file in ./*.json; do
        if test -f "$file"; then
            child_num=$(cat "$file" | jq '.children|length')
            if [ "$child_num" == "0" ]; then
                continue
            fi

            id=$(cat "$file" | jq .id)
            sex=$(cat "$file" | jq -r .sex)

            for ((i=0; i < child_num; i++)); do
                child_id=$(cat "$id".json | jq .id)
                if [ $sex == "male" ]; then
                    father[$child_id]=$id
                else
                    mother[$child_id]=$id
                fi
            done
        fi
    done
}




function generate_all_title()
{
    ""
}



function query_person_title()
{
    # People who has no mother (and, or, father)..
    if [ -z "${mother[$1]}" ]; then
        title_num=$(cat "$1".json | jq '.titles|length')
        for ((i=0; i < title_num; i++)); do
            cur_title=$(cat "$1".json | jq .titles[$i])
            printf "%s" "$cur_title "
        done
    fi

    
    
}



function query_inherit()
{
    ""   
}


function process_title()
{
    ""
}