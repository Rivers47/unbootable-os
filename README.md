Custom coreos build based on ucore-hci.
Additional packages are `vim fzf butane cockpit htop zoxide bfs` and the official 7z.

Also, nfs, samba, and cockpit socket is enabled by default.

`rpm-ostree rebase ostree-unverified-registry:ghcr.io/rivers47/unbootable-os:latest`
