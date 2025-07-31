#!/bin/sh -e
#
# Script for Jenkins job 'perfsonar-oneshot'
#
echo "run the github work flow script"
echo " change dir to artifact RPM"
cd artifacts/RPMS
echo " ls rpm dir"
ls
echo " list yum repos  "
ls -al /etc/yum.repos.d/
echo " list repos "
sudo dnf repolist --all
echo " createrepo "
sudo createrepo .
echo " list repos "
sudo dnf repolist --all
echo " config repo gpgcheck = 0 "
sudo dnf config-manager --add-repo . --setopt=gpgcheck=0
echo " list yum repos II "
ls -al /etc/yum.repos.d/
pwd
cd /build
echo " echo gpgcheck and cat file "
sudo chmod 666 /etc/yum.repos.d/build_artifacts_RPMS.repo
ls -al /etc/yum.repos.d/build_artifacts_RPMS.repo
sudo echo "gpgcheck=0" >> /etc/yum.repos.d/build_artifacts_RPMS.repo
sudo chmod 644 /etc/yum.repos.d/build_artifacts_RPMS.repo
ls -al /etc/yum.repos.d/build_artifacts_RPMS.repo
cat /etc/yum.repos.d/build_artifacts_RPMS.repo
echo "make "
make
