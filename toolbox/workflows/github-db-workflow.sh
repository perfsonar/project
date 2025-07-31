echo "Run the Debian GitHub workflow script"
dpkg -l jq

echo "Change directory to artifact DEBs"
cd artifacts/

echo "List DEB directory"
ls

echo "List APT sources"
ls -al /etc/apt/sources.list.d/

echo "List available repositories"
sudo apt update
sudo apt-cache policy

echo "Create repository"
sudo apt install -y dpkg-dev
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

echo "Add local repository"
echo "deb [trusted=yes] file://$(pwd) ./" | sudo tee /etc/apt/sources.list.d/local-repo.list

echo "Update APT and list repositories again"
sudo apt update
sudo apt-cache policy

echo "Change directory back to build"
cd /build/

 
echo "Display repository file"
ls -al /etc/apt/sources.list.d/local-repo.list
cat /etc/apt/sources.list.d/local-repo.list


##  took this out to see if owamp would build
#echo "check jq version"
#sudo dpkg -l jq
#sudo apt install --only-upgrade jq
#sudo apt install  jq
#sudo dpkg -l jq



echo "Run unibuild"
unibuild  build
mkdir ./unibuild-repo
unibuild gather ./unibuild-repo
