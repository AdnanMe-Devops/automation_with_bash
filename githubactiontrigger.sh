#!/bin/bash

repo="/home/deployment/src/deployment-activity-trigger"
export HTTPS_PROXY="proxy"

if ! [ -d "${repo}" ]; then
    echo "Repo: ${repo} not found!! Before using the script clone the repo  !"
    exit 1
fi



cd "${repo}"
git pull
echo -en "." >> test.md
git add -A test.md
git commit -m 'bash script to automatic and trigger deployment in github action '
git push origin master
