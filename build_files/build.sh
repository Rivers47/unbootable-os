#!/bin/bash
set -ouex pipefail
ARCH="$(rpm -E %{_arch})"
RELEASE="$(rpm -E %fedora)"

pushd /tmp/rpms/kernel
KERNEL_VERSION=$(find kernel-*.rpm | grep -P "kernel-(\d+\.\d+\.\d+)-.*\.fc${RELEASE}\.${ARCH}" | sed -E 's/kernel-//' | sed -E 's/\.rpm//')
popd
# this installs a package from fedora repos
dnf -y install /tmp/rpms/akmods-zfs/kmods/zfs/*.rpm /tmp/rpms/akmods-zfs/kmods/zfs/other/zfs-dracut-*.rpm
depmod -a -v ${KERNEL_VERSION}

dnf remove -y nfs-utils-coreos
dnf5 install -y cockpit cockpit-networkmanager cockpit-podman cockpit-selinux cockpit-system firewalld fwupd-efi intel-compute-runtime podman pv wireguard-tools hdparm man-db nfs-utils samba samba-usershares smartctl 
#dnf install cockpit-machines libvirt virt-install pciutils open-vm-tools

# zfs
# post install
systemctl enable podman.socket
systemctl disable coreos-oci-migration-motd.service
systemctl disable docker.socket
systemctl disable zincati.service

cp -a /etc/firewalld/firewalld-server.conf /etc/firewalld/firewalld.conf

# cleanup
rm -rf /tmp/* || true
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;

# this currently fails on /usr/etc and /var/cache
#bootc container lint
ostree container commit
mkdir -p /var/tmp \
&& chmod -R 1777 /var/tmp
