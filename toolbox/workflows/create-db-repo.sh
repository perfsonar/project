#!/usr/bin/env bash
#set -e

echo "** build deb repo sh **"

file="/build/variables.txt"
echo "cat variables.txt"
cat /build/variables.txt

source $file

cd artifacts/debian

echo "apt-get install dpkg-dev"
sudo apt-get update
sudo apt-get install -y dpkg-dev

echo "Generating Packages index..."
dpkg-scanpackages . /dev/null > Packages

echo "Generating compressed Packages.gz..."
gzip -9c Packages > Packages.gz

echo "Generating Release file..."
apt-ftparchive release . > Release


echo "Contents of repo directory:"
ls -l

echo "** End build deb repo sh **"

