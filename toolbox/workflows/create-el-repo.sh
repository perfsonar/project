#!/bin/sh -e

echo "**  Run create el repo sh ** "
file="/build/variables.txt"
# Read the variables from the file
source $file
 
echo "Create a repo to be uploaded "
echo " ls in create repo"
ls
echo
echo
echo " what dir pwd"
pwd
echo
echo
echo "cat variables.txt:"
cat variables.txt

cd artifacts 
echo " *********. "
echo " ls artifacts"
ls
echo
echo
echo " what dir pwd"
pwd
echo
echo
echo "ls the RPMS"
ls -al RPMS

echo "dnf install create repo"
sudo dnf -y install createrepo

LOCAL_PATH="/repo/nightly/el/"

final_cache_path="$repo/$os_dir/$el_version/.cache"
echo "sudo create repo"
echo "final cache path $final_cache_path"
sudo createrepo --update --simple-md-filenames  -p -d RPMS
echo "list repodata dir"
ls -l RPMS/repodata/
##sudo createrepo --update --simple-md-filenames -c $final_cache_path -p -d $repo/$os_dir/$el_version/x86_64/perfsonar/$build_branch
echo "ls the RPMS"
ls -al RPMS


echo "**  End create el repo sh ** "
