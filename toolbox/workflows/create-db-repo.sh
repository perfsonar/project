#!/usr/bin/env bash
set -e

echo "** Run create deb repo sh **"

file="/build/variables.txt"
echo "Before sourcing:"
env | sort

echo "Sourcing variables from $file"
. "$file"

echo "After sourcing:"
env | sort

echo "Create a Debian/Ubuntu repo to be uploaded"

cd artifacts
pwd
ls

echo "apt-get install dpkg-dev"
sudo apt-get update
sudo apt-get install -y dpkg-dev

final_cache_path="$repo/$os_dir/"
REPO_ROOT="$repo/$os_dir/$deb_codename"
echo "Repo root: $REPO_ROOT"
echo "final cache path root: $final_cache_path"

exit
mkdir -p "$REPO_ROOT"

cp DEBS/*.deb "$REPO_ROOT"/

cd "$REPO_ROOT"

echo "Generating Packages index..."
dpkg-scanpackages . /dev/null > Packages
gzip -kf Packages

echo "Contents of repo directory:"
ls -l

echo "** End create deb repo sh **"

