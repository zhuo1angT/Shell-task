#!/bin/bash

# shellcheck disable=SC1091,SC2162

echo ""
echo "Royal family database management system  0.1"
echo "Enter \"commands\" to get command list."
echo -e "Enter \"help \033[4mcommand\033[0m\" to get more detailed command info."
echo ""



source ./helper.sh 
source ./directory.sh


while true
do
	echo -e "\033[36m royal> \033[0m\c"  # When debug, comment this line, tool bug here
	read -a command

	#echo "${#command[*]}"

	if [ "${command[0]}" == "commands" ]
	then 
		ListCommand
		
	elif [ "${command[0]}" == "help" ]
	then 
		CommandInfo "${command[1]}"
	

	# Function Implementation
	elif [ "${command[0]}" == "cd" ]
	then
		changeDirectory "${command[1]}"
	
	elif [ "${command[0]}" == "cp" ]
	then 
		st=$(cp ./*.json "${command[1]}/")
		if [ "$st" == 0 ]
		then
			echo "Error: Copying JSON file failed!"
		fi
		pwd

	elif [ "${command[0]}" == "backup" ]
	then	
		archive=backup-$(date +"%Y-%m-%d""-""%H-%M")

		if [ "${#command[*]}" == 2 ]
		then
			archive="${command[1]}"/$archive
		fi

		tar czf "$archive".tar.gz *.json
		echo "Directory $PWD backed up in archive file \"$archive.tar.gz\"."

	elif [ "${command[0]}" == "restore" ]
	then
		tar -xzvf "${command[1]}".tar.gz
	fi




done






