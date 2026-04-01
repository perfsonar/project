
#!/bin/sh
set -eu

echo "** build deb repo with reprepro **"

file="/build/variables.txt"

echo "Contents of variables file:"
cat "$file"
. "$file"

SRC_DIR="artifacts/debian"
REPO_DIR="/var/local/repo"

DIST="${DIST:-stable}"
COMPONENT="${COMPONENT:-main}"
ARCH="${ARCH:-amd64}"
ORIGIN="${ORIGIN:-perfSONAR}"
LABEL="${LABEL:-perfSONAR}"
DESCRIPTION="${DESCRIPTION:-perfSONAR APT Repository}"

echo "Current directory:"
pwd

echo "Repo contents:"
ls -R | head -50

echo "copy the distribution file"
cp /build/distribution /var/local/repo/distribution

echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y reprepro dpkg-dev

echo "Creating repo directories..."
sudo mkdir -p "$REPO_DIR/conf"

echo "Writing distributions config..."
sudo tee "$REPO_DIR/conf/distributions" > /dev/null <<EOF
Origin: $ORIGIN
Label: $LABEL
Suite: $DIST
Codename: $DIST
Architectures: $ARCH
Components: $COMPONENT
Description: $DESCRIPTION
EOF

echo "Copying deb files into repo working area..."
sudo mkdir -p "$REPO_DIR"
sudo find "$REPO_DIR" -maxdepth 1 -type f -name '*.deb' -exec rm -f {} \;
sudo cp -v "$SRC_DIR"/*.deb "$REPO_DIR"/

echo "Contents of $REPO_DIR before import:"
sudo ls -l "$REPO_DIR"

echo "Adding packages to reprepro..."
found_deb=0
for deb in "$REPO_DIR"/*.deb; do
    if [ ! -f "$deb" ]; then
        continue
    fi

    found_deb=1
    echo "Including $deb"
    sudo reprepro -b "$REPO_DIR" includedeb "$DIST" "$deb"
done

if [ "$found_deb" -eq 0 ]; then
    echo "ERROR: No .deb files found in $REPO_DIR"
    exit 1
fi

echo "Final repo contents:"
sudo find "$REPO_DIR" -maxdepth 3 -type f | sort

echo "** End build deb repo with reprepro **"
