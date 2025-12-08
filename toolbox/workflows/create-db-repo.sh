#!/usr/bin/env bash
set -e

echo "** Run create deb repo sh **"

file="/build/variables.txt"
# Load variables (repo, os_dir, deb_codename, etc.)
. "$file"

echo "Create a Debian/Ubuntu repo to be uploaded"

cd artifacts

echo "apt-get install dpkg-dev"
sudo apt-get update
sudo apt-get install -y dpkg-dev

#    Example: /repo/nightly/deb/$os_dir/$deb_codename
REPO_ROOT="$repo/$os_dir/$deb_codename"
echo "Repo root: $REPO_ROOT"

mkdir -p "$REPO_ROOT"

cp DEBS/*.deb "$REPO_ROOT"/

cd "$REPO_ROOT"

echo "Generating Packages index..."
dpkg-scanpackages . /dev/null > Packages
gzip -kf Packages

echo "Contents of repo directory:"
ls -l

echo "** End create deb repo sh **"

