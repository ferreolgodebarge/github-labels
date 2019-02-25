#!/bin/bash

function get_label(){
	local _labels=$1
	local _acc=0
	local _res
	for row in $(echo "${_labels}" | jq -r '.[].name'); do
		if [ ${row} = "patch" ]; then ((++_acc)); _res="patch"; fi
		if [ ${row} = "minor" ]; then ((++_acc)); _res="minor"; fi
		if [ ${row} = "major" ]; then ((++_acc)); _res="major"; fi
	done
	if [ $_acc = 1 ]; then
		echo "$_res";
	else
		exit 1;
	fi
}

function increment_version(){
	local _url=$1
	local _file=$2
	local _labels=$(curl -s "$_url" | jq '.labels')
	local _label=$(get_label "$_labels")
	
	if [ $? = 1 ]; then echo "Error: Zero or more than two versioning labels"; exit 1; fi

	patch="$(cat "$_file" | cut -d'.' -f3)"
	minor="$(cat "$_file" | cut -d'.' -f2)"
	major="$(cat "$_file" | cut -d'.' -f1)"

	if [ $_label = "patch" ]; then
		((++patch));
	elif [ $_label = "minor" ]; then
		((++minor));
	elif [ $_label = "major" ]; then
		((++major));
	fi

	echo "New version applied for this merge: $major.$minor.$patch"
	echo "$major.$minor.$patch" > $_file
}

increment_version $1 $2
