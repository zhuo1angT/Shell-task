#!/bin/bash

# shellcheck disable=SC1091,SC2162

echo ""
echo "Royal family database management system  0.1"
echo "Enter \"commands\" to get command list."
echo -e "Enter \"help \033[4mcommand\033[0m\" to get more detailed command info."
echo ""



source ./helper.sh 
source ./directory.sh
source ./family.sh



while true
do
	echo -e "\033[36mroyal> \033[0m\c"  # When debug, comment this line, tool bug here

	read -a command

	#echo "${#command[*]}"


	if [ "${command[0]}" == "commands" ]
	then 
		if [ "${#command[*]}" == 1 ]
		then
			list_command
		else
			echo "Error! Argument more than one."
			echo "Do you mean \"commands\"?"
		fi


	elif [ "${command[0]}" == "help" ]
	then 
		if [ "${#command[*]}" == 2 ]
		then 
			command_info "${command[1]}"
		else
			report_argument_num_error	
		fi



	# Directory functions, implemented in "directory.sh"

	elif [ "${command[0]}" == "cd" ]
	then
		if [ "${#command[*]}" == 2 ]
		then
			change_directory "${command[1]}"
			generate_all_family
		else
			report_argument_num_error "cd"
		fi



	elif [ "${command[0]}" == "cp" ]
	then 
		if [ "${#command[*]}" == 2 ]
		then
			copy_dircetory "${command[1]}"	
		else
			report_argument_num_error "cp"
		fi


	elif [ "${command[0]}" == "backup" ]
	then	

		if [ "${#command[*]}" == 2 ]
		then
			database_backup "${command[0]}"
		elif [ "${#command[*]}" == 1 ]
		then
			database_backup
		else
			report_argument_num_error "backup"
		fi



	elif [ "${command[0]}" == "restore" ]
	then
		if [ "${#command[*]}" == 2 ]
		then
			restore_from_tar "${command[1]}"
			generate_all_family
		else
			report_argument_num_error "restore"
		fi
	


	elif [ "${command[0]}" == "import" ]
	then
		if [ "${#command[*]}" == 3 ]
		then
			if [ "${command[1]}" == "-d" ]
			then
				cp "${command[2]}"/*.json "$PWD"
			elif [ "${command[1]}" == "-t" ]
			then
				# Acturally, it is a merge operation
				restore_from_tar "${command[2]}"
			fi
		elif [ "${#command[*]}" == 2 ]
		then	
			if [ "${command[1]}" == "-m" ]
			then
				manually_import
			fi
		else
			report_argument_num_error import
		fi
		generate_all_family





	elif [ "${command[0]}" == "queryPersonFamily" ]
	then
		# shortcut: if the "argc" is not 2, gives 0 without calc the next expr
		# use regular expresion to check if the argument is a number (ID is required)  
		if [ "${#command[*]}" == 2 ] && [[ "${command[1]}" != *[!0-9]* ]]
		then
			query_person_family "${command[1]}"
		else
			report_argument_num_error queryPersonFamily
		fi

	
	elif [ "${command[0]}" == "processFamily" ]
	then
		if [ "${#command[*]}" == 1 ]
		then
			process_family "./"
		elif [ "${#command[*]}" == 2 ]; then
			process_family "${command[1]}"
		else
			report_argument_num_error processFamily
		fi
	

	elif [ "${command[0]}" == "green" ]
	then
		green


	elif [ "${command[0]}" == "exit" ]
	then
		if [ "${#command[*]}" == 1 ]
		then
			exit 0
		else
			report_argument_num_error exit
		fi

	

	elif [ "${#command[*]}" != "0" ]; then
		echo "Unknown command! Please enter \"commands\" to check for all commands"
	fi

done






