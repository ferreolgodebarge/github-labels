#!/bin/bash

function get_label(){
	acc=0
	local labels=$1
	for row in $(echo "${labels}" | jq -r '.[].name'); do
		if [ ${row} = "patch" ]; then ((++acc)); res="patch"; fi
		if [ ${row} = "minor" ]; then ((++acc)); res="minor"; fi
		if [ ${row} = "major" ]; then ((++acc)); res="major"; fi
	done
	if [ $acc = 1 ]; then
		echo "$res";
	else
		exit 1;
	fi
}

function increment_version(){
	local _url=$1
	local _file=$2
	
	labels=$(curl -s "$_url" | jq '.labels')
	label=$(get_label "$labels")
	
	if [ $? = 1 ]; then echo "Error: Two versioning labels"; exit 1; fi

	patch="$(cat "$_file" | cut -d'.' -f3)"
	minor="$(cat "$_file" | cut -d'.' -f2)"
	major="$(cat "$_file" | cut -d'.' -f1)"

	if [ $label = "patch" ]; then
		((++patch));
	elif [ $label = "minor" ]; then
		((++minor));
	elif [ $label = "major" ]; then
		((++major));
	fi

	echo "New version applied for this merge: $major.$minor.$patch"
	echo "$major.$minor.$patch" > $_file
}

increment_version $1 $2
