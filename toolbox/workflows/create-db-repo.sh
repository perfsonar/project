
#!/bin/sh
set -eu

echo "** build deb repo with reprepro **"

file="/build/variables.txt"

echo "list /build/project/toolbox/workflows"
ls -al /build/project/toolbox/workflows/

echo "Contents of variables file:"
cat "$file"
. "$file"

SRC_DIR="artifacts/debian"
REPO_DIR="/var/local/repo"

# TODO: determine this dynamic nightly build vs tag
DIST="${DIST:-perfsonar-5.3-snapshot}"
COMPONENT="${COMPONENT:-main}"
ARCH="${ARCH:-amd64}"
ORIGIN="${ORIGIN:-perfSONAR}"
LABEL="${LABEL:-perfSONAR}"
DESCRIPTION="${DESCRIPTION:-perfSONAR APT Repository}"

echo "Current directory:"
pwd

echo "Repo contents:"
ls -R | head -50

echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y reprepro dpkg-dev

echo "Creating repo directories..."
sudo mkdir -p "$REPO_DIR/conf"

echo "Copy the distributions file"
sudo cp "/build/project/toolbox/workflows/distributions" "$REPO_DIR/conf/distributions"

echo "Contents of $SRC_DIR:"
ls -l "$SRC_DIR" || true

echo "Adding packages to reprepro..."

found_pkg=0

# Include source packages (.dsc)
for dsc in "$SRC_DIR"/*.dsc; do
    [ -f "$dsc" ] || continue
    found_pkg=1
    echo "Including DSC: $dsc"
    sudo reprepro --waitforlock 12 -v -b "$REPO_DIR" includedsc "$DIST" "$dsc"
done

# Include binary packages via .changes
for changes in "$SRC_DIR"/*_[^s][a-z0-9]*.changes; do
    [ -f "$changes" ] || continue
    found_pkg=1
    echo "Including CHANGES: $changes"
    sudo reprepro --waitforlock 12 --ignore=wrongdistribution -v -b "$REPO_DIR" include "$DIST" "$changes"
done

if [ "$found_pkg" -eq 0 ]; then
    echo "ERROR: No .dsc or .changes files found in $SRC_DIR"
    exit 1
fi

echo "Final repo contents:"
echo "$REPO_DIR"
sudo ls -al "$REPO_DIR"

echo "Exporting repo artifacts..."
mkdir -p ./artifacts/repo
sudo cp -r "$REPO_DIR"/* ./artifacts/repo/

echo "** End build deb repo with reprepro **"
