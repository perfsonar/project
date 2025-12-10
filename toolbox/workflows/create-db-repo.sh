#!/usr/bin/env bash
#set -e

echo "** Create deb repo sh **"

file="/build/variables.txt"
echo "cat variables.txt"
cat /build/variables.txt

source $file


cd artifacts

echo "apt-get install dpkg-dev"
sudo apt-get update
sudo apt-get install -y dpkg-dev

final_cache_path="$repo/$os_dir/"
echo "Repo path: $final_cache_path"
ls $final_cache_path

echo "ls build dir"
ls -al build
exit


echo "Generating Packages index..."
dpkg-scanpackages . /dev/null > Packages

echo "Contents of repo directory:"
ls -l

echo "** End create deb repo sh **"

