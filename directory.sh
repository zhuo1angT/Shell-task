#!/bin/bash

# shellcheck disable=SC1091,SC2162

function change_directory()
{
    cd "$1" || return
	pwd
}


function copy_dircetory()
{
    st=$(cp ./*.json "$1/")
	if [ "$st" == 0 ]; then
		echo "Error: Copying JSON file failed!"
	fi
	pwd
}


function database_backup()
{
	archive=backup-$(date +"%Y-%m-%d""-""%H-%M")

	if [ "$#" == 1 ]; then
		archive="$1"/$archive
	fi

	tar -czf "$archive".tar.gz "./"
	echo "Directory backed up in archive file \"$archive.tar.gz\"."

}


function restore_from_tar()
{
	tar -xzvf "$1".tar.gz
}


function manually_import()
{
	touch entity.json
				
	echo "{" >> entity.json
	read -p "Enter name: > " name
	echo "\"name\":\"$name\"" >> entity.json
		
	read -p "Enter ID: > " ID
	echo ",\"ID\":\"$ID\"" >> entity.json

	read -p "Enter sex: > " sex
	echo ",\"sex\":\"$sex\"" >> entity.json

	echo "Enter couples..."
	echo "raw ID, separated with space, nothing else shall be entered:" 
	echo " > "
	read -a couples

	if [ "${#couples[*]}" -gt 0 ]; then 
		echo ",\"couples\":[" >> entity.json
	fi

	for ((i=0; i < "${#couples[*]}"; i++)); do
		if [ $i -gt 0 ]; then
			printf "," >> entity.json
		fi
		printf "%s" "${couples[$i]}" >> entity.json
	done

	if [ "${#couples[*]}" -gt 0 ]; then 
		echo "]" >> entity.json
	fi


	echo "Enter children..."
	echo "raw ID, separated with space, nothing else shall be entered:"
	echo " > "

	read -a children

	if [ "${#children[*]}" -gt 0 ]; then 
		echo ",\"children\":[" >> entity.json
	fi

	for ((i=0; i < "${#children[*]}"; i++)); do
		if [ $i -gt 0 ]; then
			printf "," >> entity.json
		fi
			printf "%s" "${children[$i]}" >> entity.json
	done

	if [ "${#children[*]}" -gt 0 ]; then 
		echo "]" >> entity.json
	fi

	read -p "Enter maintitle: > " maintitle
	echo ",\"maintitle\":\"$maintitle\"" >> entity.json


	echo "Enter all titles..."
	echo "raw string, separated with space, nothing else shall be entered:"
	echo " > " 
	read -a titles


	if [ "${#titles[*]}" -gt 0 ]; then 
		echo ",\"titles\":[" >> entity.json
	fi

	for ((i=0; i < "${#titles[*]}"; i++)); do
		if [ $i -gt 0 ]; then
			printf "," >> entity.json
		fi
		printf "\"%s\"" "${titles[$i]}" >> entity.json
	done

	if [ "${#titles[*]}" -gt 0 ]; then 
		echo "]" >> entity.json
	fi
	
	echo "}" >> entity.json

	mv entity.json  "$ID".json
}
