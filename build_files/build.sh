#!/bin/bash
dnf install -y vim fzf butane cockpit htop zoxide bfs

curl --output /tmp/7z.tar.xz https://www.7-zip.org/a/7z2501-linux-x64.tar.xz
tar xvf /tmp/7z.tar.xz 7zz 7zzs
mv 7zz 7zzs /usr/bin

# post install
systemctl enable nfs-server.service
systemctl enable smb.service
systemctl enable cockpit.socket

