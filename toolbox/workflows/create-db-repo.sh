
#!/usr/bin/env bash
set -euo pipefail

echo "** build deb repo with reprepro **"

file="/build/variables.txt"

echo "Contents of variables file:"
cat "$file"
source "$file"

# Source directory containing built .deb packages
SRC_DIR="artifacts/debian"

# Target reprepro repository root
REPO_DIR="/var/local/repo"

# These can come from variables.txt if present
# Fallbacks are provided so the script still works
DIST="${DIST:-${BUILD_BRANCH:-stable}}"
COMPONENT="${COMPONENT:-main}"
ARCH="${ARCH:-$(dpkg --print-architecture)}"
ORIGIN="${ORIGIN:-perfSONAR}"
LABEL="${LABEL:-perfSONAR}"
DESCRIPTION="${DESCRIPTION:-perfSONAR APT Repository}"

echo "Using settings:"
echo "  SRC_DIR=$SRC_DIR"
echo "  REPO_DIR=$REPO_DIR"
echo "  DIST=$DIST"
echo "  COMPONENT=$COMPONENT"
echo "  ARCH=$ARCH"

echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y reprepro dpkg-dev

echo "Creating repo directories..."
sudo mkdir -p "$REPO_DIR/conf"
sudo mkdir -p "$REPO_DIR/incoming"

echo "Writing distributions config..."
sudo tee "$REPO_DIR/conf/distributions" > /dev/null <<EOF
Origin: $ORIGIN
Label: $LABEL
Suite: $DIST
Codename: $DIST
Architectures: $ARCH source
Components: $COMPONENT
Description: $DESCRIPTION
EOF

echo "Copying deb files into repo working area..."
sudo find "$REPO_DIR" -maxdepth 1 -type f -name '*.deb' -delete || true
sudo cp -v "$SRC_DIR"/*.deb "$REPO_DIR/"

echo "Contents of $REPO_DIR before import:"
sudo ls -l "$REPO_DIR"

echo "Adding packages to reprepro..."
shopt -s nullglob
deb_files=( "$REPO_DIR"/*.deb )

if [ ${#deb_files[@]} -eq 0 ]; then
    echo "ERROR: No .deb files found in $REPO_DIR"
    exit 1
fi

for deb in "${deb_files[@]}"; do
    echo "Including $deb"
    sudo reprepro -b "$REPO_DIR" includedeb "$DIST" "$deb"
done

echo "Final repo contents:"
sudo find "$REPO_DIR" -maxdepth 3 -type f | sort

echo "** End build deb repo with reprepro **"
