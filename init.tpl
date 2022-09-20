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
sudo shutdown -r now