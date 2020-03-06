#!/bin/bash


function change_directory()
{
    cd "$1" || return
	pwd
}


