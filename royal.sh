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
				tar -xzvf "$2".tar.gz
			fi
		elif [ "${#command[*]}" == 2 ]
		then	
			if [ "${command[1]}" == "-m" ]
			then
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

				if [ "${#couples[*]}" -gt 0 ]
				then 
					echo ",\"couples\":[" >> entity.json
				fi

				for ((i=0; i < "${#couples[*]}"; i++))
				do
					if [ $i -gt 0 ]
					then
						printf "," >> entity.json
					fi
					printf "%s" "${couples[$i]}" >> entity.json
				done

				if [ "${#couples[*]}" -gt 0 ]
				then 
					echo "]" >> entity.json
				fi



				echo "Enter children..."
				echo "raw ID, separated with space, nothing else shall be entered:"
				echo " > "
				read -a children

				if [ "${#children[*]}" -gt 0 ]
				then 
					echo ",\"children\":[" >> entity.json
				fi

				for ((i=0; i < "${#children[*]}"; i++))
				do
					if [ $i -gt 0 ]
					then
						printf "," >> entity.json
					fi
					printf "%s" "${children[$i]}" >> entity.json
				done

				if [ "${#children[*]}" -gt 0 ]
				then 
					echo "]" >> entity.json
				fi

				read -p "Enter maintitle: > " maintitle
				echo ",\"maintitle\":\"$maintitle\"" >> entity.json



				echo "Enter all titles..."
				echo "raw string, separated with space, nothing else shall be entered:"
				echo " > " 
				read -a titles


				if [ "${#titles[*]}" -gt 0 ]
				then 
					echo ",\"titles\":[" >> entity.json
				fi

				for ((i=0; i < "${#titles[*]}"; i++))
				do
					if [ $i -gt 0 ]
					then
						printf "," >> entity.json
					fi
					printf "%s" "${titles[$i]}" >> entity.json
				done

				if [ "${#titles[*]}" -gt 0 ]
				then 
					echo "]" >> entity.json
				fi
				echo "}" >> entity.json
			
				mv entity.json  "$ID".json
			
			fi
		fi



	fi

done






