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
		change_directory "${command[1]}"
	

	elif [ "${command[0]}" == "cp" ]
	then 
		copy_dircetory "${command[1]}"


	elif [ "${command[0]}" == "backup" ]
	then	

		if [ "${#command[*]}" == 2 ]
		then
			database_backup "${command[0]}"
		else
			database_backup
		fi



	elif [ "${command[0]}" == "restore" ]
	then
		restore_from_tar "${command[1]}"
	fi




done






