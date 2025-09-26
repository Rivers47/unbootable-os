#!/bin/bash
dnf install -y vim fzf butane cockpit htop zoxide bfs
# post install
systemctl enable nfs-server.service
systemctl enable smb.service
systemctl enable cockpit.socket

