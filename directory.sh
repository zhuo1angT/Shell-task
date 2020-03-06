#!/bin/bash


function change_directory()
{
    cd "$1" || return
	pwd
}

function copy_dircetory()
{
    st=$(cp ./*.json "$1/")
	if [ "$st" == 0 ]
	then
		echo "Error: Copying JSON file failed!"
	fi
	pwd
}

function database_backup()
{
	archive=backup-$(date +"%Y-%m-%d""-""%H-%M")

	if [ "$#" == 2 ]
	then
		archive="$2"/$archive
	fi

	tar czf "$archive".tar.gz *.json
	echo "Directory $PWD backed up in archive file \"$archive.tar.gz\"."

}


function restore_from_tar()
{
	tar -xzvf "$1".tar.gz
}