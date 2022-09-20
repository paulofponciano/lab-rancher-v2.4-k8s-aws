#!/bin/bash
sudo apt-get update
sudo apt-get -y upgrade
sudo cp /etc/localtime /etc/localtime.default
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/Recife /etc/localtime
sudo apt-get -y -qq install wget git htop vim zip unzip collectd software-properties-common
sudo curl https://releases.rancher.com/install-docker/20.10.sh | sh
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get apache2-utils
sudo apt-get install -y kubectl
sudo mkdir ~/.kube
docker run -d --name rancher --restart=unless-stopped -v /opt/rancher:/var/lib/rancher  -p 80:80 -p 443:443 rancher/rancher:v2.4.3