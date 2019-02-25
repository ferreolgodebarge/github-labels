# Github Label

This repository contains a script to increase version contained in a file, depending on the label specified in a Github PR.

For example :

```
$ ./version.sh https://api.github.com/repos/ferreolgodebarge/github-labels/pulls/1 version 
```

This code changes the `version` file, incrementing the `patch`, `minor`, or `major` number, depending on the label chosen in the PR.

Usually, this script has to be run by a job description file (e.g. Jenkinsfile), when the PR is merged. 

Versioning becomes then automatic.


This script needs jq.
