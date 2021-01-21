#!/usr/bin/env bash

# "Build" script for rc24.sh releases
# By HTV04

if ! command -v zip &> /dev/null
then
	printf "\"zip\" command not found! Please install the \"zip\" package using your package manager.\n\n"
	exit
fi

printf "Now creating rc24.sh release ZIP for ${1}-${2}...\n\n"

mkdir -p rc24.sh-${1}-${2}

cp bin/${1}/{2}/Sharpii rc24.sh-${1}-${2}

cp -r resources/Files rc24.sh-${1}-${2}

cp src/${1}/rc24.sh rc24.sh-${1}-${2}

zip -r rc24.sh-${1}-${2}.zip rc24.sh-${1}-${2}

printf "Done!\n\n"