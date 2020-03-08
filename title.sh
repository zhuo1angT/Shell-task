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
                child_id=$(cat $file | jq .children[$i])
                if [ $sex == "male" ]; then
                    father[$child_id]=$id
                else
                    mother[$child_id]=$id
                fi
            done
        fi
    done


}



function have_son()
{
    haveSon=0
    child_num=$(cat "$1".json | jq '.children|length')
    for ((i=0; i < child_num; i++)); do
        cur_child_id=$(cat "$1".json | jq .children[$i])
        child_sex=$(cat "$cur_child_id".json | jq -r .sex)
        if [ $child_sex == "male" ]; then
            haveSon=1
            return
        fi
    done
}






function query_person_title()
{
    # People who has no mother (and, or, father)...

    if [ -z "${mother[$1]}" ]; then
        title_num=$(cat "$1".json | jq '.titles|length')
        for ((i=0; i < title_num; i++)); do
            cur_title=$(cat "$1".json | jq -r .titles[$i])
            printf "%s\n" "$cur_title" >>  "$1.title"
        done
    else
        
        if [ ! -f "${father[$1]}.title" ]; then
            query_person_title "${father[$1]}"
        fi

        if [ ! -f "${mother[$1]}.title" ]; then
            query_person_title "${mother[$1]}"
        fi



        sex=$(cat "$1".json | jq -r .sex)


        # check if father have son
        have_son "${father[$1]}"
        
        if [ $sex == "male" ] || [ $haveSon == "0" ]; then

            # calc "fa-rank"
            fa_child_num=$(cat "${father[$1]}".json | jq '.children|length')
            for ((i=0; i < fa_child_num; i++)); do
                cur_child_id=$(cat "${father[$1]}".json | jq .children[$i])
                if [ $cur_child_id == $1 ]; then
                    fa_rank=$i
                    break
                fi
            done


            if [ $fa_rank == "0" ]; then 
                # first_child
                
                fa_main_title=$(sed -n '1p' "${father[$1]}".title)

                if [ "$fa_main_title" != "null" ]; then
                    printf "%s\n" "$fa_main_title" >>  "$1.title"
                fi
            else
                # not first_child
                index=fa_rank

                fa_title_num=$(cat "${father[$1]}".json | jq '.title|length')
                
                while [ $index \< $fa_title_num ]; do
                    cur_title=$(sed -n "${index}p" "${father[$1]}".title)
                    printf "%s\n" "$cur_title" >>  "$1.title"
                    index=$((index+fa_child_num-1))
                done
            fi

        fi

        have_son "${mother[$1]}"

        if [ $sex == "male" ] || [ $haveSon == "0" ]; then

            # calc "fa-rank"
            mo_child_num=$(cat "${mother[$1]}".json | jq '.children|length')
            for ((i=0; i < mo_child_num; i++)); do
                cur_child_id=$(cat "${mother[$1]}".json | jq .children[$i])
                if [ $cur_child_id == $1 ]; then
                    mo_rank=$id
                    break
                fi
            done

            if [ $mo_rank == "0" ]; then 
                # first_child
                
                mo_main_title=$(sed -n '1p' "${mother[$1]}".title)

                if [ $mo_main_title != "null" ]; then
                    printf "%s\n" "$mo_main_title" >>  "$1.title"
                fi
            else
                # not first_child
                index=mo_rank

                mo_title_num=$(cat "${mother[$1]}".json | jq '.title|length')
                
                while [ $index \< $mo_title_num ]; do
                    cur_title=$(sed -n "${index}p" "${mother[$1]}".title)
                    printf "%s\n" "$cur_title" >>  "$1.title"
                    index=$((index+mo_child_num-1))
                done
            fi

        fi
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



