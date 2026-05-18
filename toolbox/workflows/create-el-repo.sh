#!/bin/sh -e

echo "**  Run create el repo sh ** "
file="/build/variables.txt"
# Read the variables from the file
source $file
 
echo "Create a repo to be uploaded "

cd artifacts 

echo "dnf install create repo"
sudo dnf -y install createrepo

LOCAL_PATH="/repo/nightly/el/"

final_cache_path="$repo/$os_dir/$el_version/.cache"
echo "final cache path $final_cache_path"
sudo createrepo --update --simple-md-filenames  -p -d RPMS
echo "list repodata dir"
ls -l RPMS/repodata/
##sudo createrepo --update --simple-md-filenames -c $final_cache_path -p -d $repo/$os_dir/$el_version/x86_64/perfsonar/$build_branch

echo "**  End create el repo sh ** "
