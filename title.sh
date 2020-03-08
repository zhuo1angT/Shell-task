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
        
        have_maintitle=0

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

                if [ "${fa_main_title}" != "" ]; then
                    printf "%s\n" "$fa_main_title" >>  "$1.title"
                    have_maintitle=1
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

        #echo "mother = ${mother[$1]}"
        #echo "sex = $sex"
        #echo "haveSom = $haveSon"

        if [ $sex == "male" ] || [ $haveSon == "0" ]; then

            # calc "ma-rank"
            mo_child_num=$(cat "${mother[$1]}".json | jq '.children|length')
            for ((i=0; i < mo_child_num; i++)); do
                cur_child_id=$(cat "${mother[$1]}".json | jq .children[$i])
                if [ $cur_child_id == $1 ]; then
                    mo_rank=$i
                    break
                fi
            done

            #echo "mo_rank = $mo_rank"

            if [ $mo_rank == "0" ]; then 
                # first_child
                
                mo_main_title=$(sed -n '1p' "${mother[$1]}".title)

                echo "have_maintitle = $have_maintitle"

                if [ "${mo_main_title}" != "" ] && [ $have_maintitle != "1" ]; then
                    printf "%s\n" "$mo_main_title" >>  "$1.title"
                fi
            else
                # not first_child
                index=mo_rank

                mo_title_num=$(cat "${mother[$1]}".json | jq '.title|length')
                
                while [ $index \< "$mo_title_num" ]; do
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
    input_str=""
	for i in "$@"; do
        input_str="$input_str $i"
    done
    input_str=${input_str:1}



    found_title=0

    for file in ./*.json; do
        title_num=$(cat "$file" | jq '.titles|length')    
        for ((i=0; i < title_num; i++)); do
            cur_title=$(cat "$file" | jq -r .titles[$i])

            #echo "cur_title = $cur_title"
            #echo "input_str = $input_str"

            if [ "$cur_title" == "$input_str" ]; then
                id=$(cat "$file" | jq .id)
                
                found_title=1
                title_index=$i

                break
            fi
        done
        if [ $found_title == "1" ]; then
            break
        fi
    done


    if [ $found_title == "0" ]; then
        echo "Error! No such title in the current Database!"
        return 1
    fi




    child_num=$(cat "$id".json | jq '.children|length')
    sex=$(cat "$id".json | jq -r .sex)

    #echo "child_num = $child_num"
    #echo "id = $id"

    while [ "$child_num" != "0" ]; do
        #sons_id
        son_count=0
        for ((i=0; i < child_num; i++)); do
            child_id=$(cat "$id".json | jq .children[$i])
            child_sex=$(cat "$child_id".json | jq -r .sex)

            #echo "child_id = $child_id"
            #echo "child_sex = $child_sex"

            if [ "$child_sex" == "male" ]; then
                sons_id[$son_count]=$child_id
                son_count=$((son_count+1))
            fi
        done

        if [ "$child_num" == "0" ]; then
            echo "Finally no one inherits this title"
            return 0
        fi

        # only have daughter
        if [ "$son_count" == "0" ]; then
            inherit_child_index=$((title_index % child_num))
            inherit_child_id=$(cat "$id".json | jq .children["${inherit_child_index}"])
            inherit_child_name=$(cat "$id".json | jq -r .name)
            echo "$inherit_child_id: $inherit_child_name"
            return 0
        fi

        inherit_son_index=$((title_index % son_count))
        id="${sons_id[inherit_son_index]}"
        child_num=$(cat "$id".json | jq '.children|length')

        actural_inherits=0
        while read line; do

            line_str=""
	        for i in "${line[@]}"; do
                line_str="$line_str $i"
            done
            line_str=${line_str:1}



            if [ "$line_str" == "$input_str" ]; then
                actural_inherits=1
                break
            fi
    	done < "$id.title"

        if [ $actural_inherits == "0" ]; then
            echo "Finally no one inherits this title"
            return 0
        fi
    done
    echo "$id"
}


function process_title()
{
    ""
}



