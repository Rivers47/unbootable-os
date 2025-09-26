#!/bin/bash
dnf install -y vim fzf butane cockpit htop zoxide bfs
# post install
systemctl enable nfs-server.service
systemctl enable smb.service
systemctl enable cockpit.socket


#install sanoid
cd /tmp
sudo git clone https://github.com/jimsalterjrs/sanoid.git
cd sanoid
git checkout $(git tag | grep "^v" | tail -n 1)
sudo cp sanoid syncoid findoid sleepymutex /usr/local/sbin
sudo mkdir /etc/sanoid
sudo cp sanoid.defaults.conf /etc/sanoid
sudo touch /etc/sanoid/sanoid.conf
sudo cp sanoid.conf /etc/sanoid/sanoid.example.conf

