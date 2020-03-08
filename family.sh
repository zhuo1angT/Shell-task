#!/bin/bash

# shellcheck disable=SC2002



# If the one does not have a family field, then he is not considered as a
# "illegitimate child", we just have "find father" and "find son" recursively.


function generate_all_family()
{

    # Maintain a stack to do the recursive family asign
    # without function calls

    unset fam 

    top=0

    for file in ./*.json; do
        if test -f "$file"; then
                    
            id=$(cat "$file" | jq .id)
            fm=$(cat "$file" | jq -r .family)
            sex=$(cat "$file" | jq -r .sex)

            if [ "$fm" != "null" ] || [ -n "${fam[id]}" ]; then
                if [ "$sex" == "male" ]; then
                    stack[$top]=$id
                    top=$top+1
                fi
            fi


            while [ "$top" != "0" ]; do

                child_num=$(cat "${stack[$top-1]}".json | jq '.children|length')
                fm=$(cat "${stack[$top-1]}".json | jq -r .family)
                cur_id=$(cat "${stack[$top-1]}".json | jq .id)
                top=$((top-1))

                for ((i=0; i < child_num; i++)); do
                    cur_child=$(cat "$cur_id".json | jq .children[$i])
                    child_fm=$(cat "$cur_child".json | jq -r .family)
                            
    
                    # No family field in JSON
                    # Should asign family field to him (her)
                    if [ "$child_fm" == "null" ] && [ -z "${fam[cur_child]}" ]; then    
                        fam[cur_child]=$fm
                        stack[$top]=$cur_child
                        top=$((top+1))
                    fi
                done
            done
        fi
    done    

}


function query_person_family()
{
    if [ ! -f "$1.json" ]; then
        echo "Error! no JSON file represents person of ID $1"
    else
        st=$(cat "$1".json | jq -r .family)

        if [[ $st != "null" ]]; then
            echo "$st"
        else
            if [ -z "${fam[$1]}" ]; then
                echo "wildman"
            else
                echo "${fam[$1]}"
            fi
        fi
    fi
}


function process_family()
{
    for file in ./*.json; do
        if test -f "$file"; then
            cur_fm=$(cat "$file" | jq -r .family)
            cur_id=$(cat "$file" | jq .id)
            cur_name=$(cat "$file" | jq -r .name)
            if [ -z "${fam[cur_id]}" ] && [  "$cur_fm" == "null" ]; then
                echo "$cur_id: \"$cur_name\"" >> "$1"/wildman
            elif [ -n "${fam[cur_id]}" ]; then
                echo "$cur_id: \"$cur_name\"" >> "$1"/"${fam[cur_id]}"
            elif [ -n "$cur_fm" ]; then
                echo "$cur_id: \"$cur_name\"" >> "$1"/"$cur_fm"
            fi
        fi
    done
}



function green() { 
    
    line_cnt=0

    for file in ./*.json; do
        if test -f "$file"; then
            fm=$(cat "$file" | jq -r .family)
            sex=$(cat "$file" | jq -r .sex)
            id=$(cat "$file" | jq .id)
            if { [ "$fm" == "null" ] && [ -z "${fam[id]}" ]; } || [ "$sex" == "female" ]; then
                continue
            fi
            
            child_cnt=$(cat "$file" | jq '.children|length')
            for ((i=0; i < "$child_cnt"; i++)) do
                child_id=$(cat "$file" | jq .children[$i])
                child_fm=$(cat "$child_id".json | jq -r .family)

                
                if [ "$fm" == "null" ]; then
                    father_fam=${fam[id]}
                else
                    father_fam=$fm
                fi

                if [ "$father_fam" != "$child_fm" ] && [ "$child_fm" != "null" ]; then
                    child_name=$(cat "$child_id".json | jq .name)
 
                    raw_str[line_cnt]="$child_id: $child_name"
                    line_cnt=$((line_cnt+1))
 
                fi
            done
            
            #echo "$fm $child_num"
        fi
    done


    index=0
    for ((i=0; i < 10; i++)); do
        cur_file_lines=$((line_cnt/10))

        if [ $i \< $((line_cnt%10)) ]; then
            cur_file_lines=$((cur_file_lines+1))
        fi
        
        for ((j=0; j < cur_file_lines; j++)); do
            str=$(printf "%s" "${raw_str[index]}" | base64)

            echo "$str" >> "illegitimacy$i.base"
            index=$((index+1))
        done
    done
    
}

