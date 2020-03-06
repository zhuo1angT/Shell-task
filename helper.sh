#!/bin/bash



# read -p "Please enter data directory..." path

# cd $path



function ListCommand()
{
	echo ""

	echo -e "cd \t\t\t\033[4mData Dirctory\033[0m" 
	echo -e "cp \t\t\t\033[4mNew Dirctory\033[0m"
	echo -e "backup \t\t\t[\033[4mOutput File Dirctory\033[0m]"
	echo -e "restore \t\t\033[4mDBFile Path\033[0m [\033[4mWorking Dir\033[0m]"
	
	echo -e "import \t\t\t[OPTION] ..."	
	echo -e "queryFamily \t\t\033[4mPerson ID\033[0m"
	echo -e "processFamily \t\t[\033[4mOutput File Path\033[0m]"
	echo -e "green \t\t\t[\033[4mOutput File Path\033[0m]"
	
	echo -e "queryPersonTitle \t[\033[4mPerson ID\033[0m]"
	echo -e "queryInherit \t\t[\033[4mTitle Name\033[0m]"
	echo -e "processTitle \t\t[\033[4mOutput File Path\033[0m]"
	
	echo -e "exit"
	echo "----------------"
}





function CommandInfo()
{
	echo ""
	echo ""
	case $1 in
	"cd") 
		echo "Change the data dirctory to the given path."
		;;
	"cp") 
		echo "Copy the current database to the given path."
		;;
	"backup") 
		echo "Compress and save the database to the given path."
		echo "Default value is the current \"Working Directory\","
		echo "With a filename of current time."
		;;
	"restore") 
		echo "Load data from the compressed database and extract them to \"Working Directory\"."
	    echo "Default value is the current path." 
		;;
	"import")
		echo "There are three ways to import data to \"Working Directory\"."
		echo ""
		echo "\"import -d ...\""
		echo "Copy All \"*.JSON\" file from \"Data Dirctory\" to current \"Working Directory\"." 
		echo "The caller have to guarantee that all JSON file encodes profile."
		echo ""
		echo "\"import -t ...\""
		echo "Extract data from packed \".tar\" to \"Working Directory\""
		echo ""
		echo "\"import -m ...\""
		echo "Manually enter person profile, create a JSON file simultaneously."
		;;
	"queryFamily")
		echo "Query a person's family by his(hers) ID"
		;;
	"processFamily")
		echo "Process family relations, each of the family is sorted by the ID and saved in a file."
		echo "Export these files together to the given path."
		;;
	"green")
		echo "Find out \"Illegitimate Children\", encode the data by \"BASE-64\"."
		echo "Then, split the encoded data to 10 pieces in lines evenly."
		echo "Finally, compress these file into a \".tar\" file."
		;;
	"queryPersonTitle")
		echo "Query a person's tital, after all the inheritance."
		;;
	"queryInherit")
		echo "Query whose's going to inherit the given title."
		;;
	"processTitle")
		echo "Export all titles and the people who ultimately inherit them to another file."
		;;
	"exit")
		echo "Exit this shell program."
		;;
	*)
		echo "Error! \"$1\" is not a command!"
		;;
	esac
	
	echo "----------------"
}


function report_argument_num_error()
{
	echo "Error! Argument number wrong!"
	
	if [ $# == 1 ]
	then
		echo -e "Enter \"help \033[4m$1\033[0m\" to get more detailed command info."
	else
		echo -e "Enter \"help \033[4mcommand\033[0m\" to get command list"	
	fi
}














