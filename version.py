#!/usr/bin/python3

import os
import sys
import json
import requests

def get_label(input_json):
    data = json.loads(input_json)
    labels = data['labels']
    labels_list = []
    for label in labels:
        name = label['name']
        if name == 'patch' or name =='minor' or name == 'major':
            labels_list.append(name)

    if len(labels_list) == 1:
        return labels_list[0]
    else:
        print("Error: Zero or more than two versioning labels")
        sys.exit(1)

def increment_version(url, input_file):
    input_json = requests.get(url).text
    label = get_label(input_json)
    with open(input_file, 'r') as input:
        version = input.readline()
        [major, minor, patch] = list(map(int, version.split('.')))
        if label == 'patch':
            patch += 1
        elif label == 'minor':
            minor += 1
        elif label == 'major':
            major += 1
        final_version = '.'.join(list(map(str, [major, minor, patch])))

    with open(input_file, 'w') as input:
        input.write(final_version)
    return final_version

if __name__ == '__main__':
    print(increment_version(sys.argv[1], sys.argv[2]))
