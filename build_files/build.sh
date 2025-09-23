#!/bin/bash
dnf install -y vim fzf butane cockpit
# post install
systemctl enable nfs-server.service
