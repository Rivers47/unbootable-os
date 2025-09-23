# Allow build scripts to be referenced without being copied into the final image
ARG COREOS_VERSION="${COREOS_VERSION:-stable}"
ARG FEDORA_VERSION="${FEDORA_VERSION:-42}"
ARG IMAGE_VERSION="${IMAGE_VERSION:-stable}"
ARG IMAGE_REGISTRY="${IMAGE_REGISTRY:-ghcr.io/ublue-os}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-coreos-stable}"

# FROMs for copying
ARG AKMODS_COMMON="${IMAGE_REGISTRY}/akmods:${KERNEL_FLAVOR}-${FEDORA_VERSION}"
ARG AKMODS_NVIDIA="${IMAGE_REGISTRY}/akmods-nvidia:${KERNEL_FLAVOR}-${FEDORA_VERSION}"
ARG AKMODS_ZFS="${IMAGE_REGISTRY}/akmods-zfs:${KERNEL_FLAVOR}-${FEDORA_VERSION}"
FROM ${AKMODS_COMMON} AS akmods-common
FROM ${AKMODS_ZFS} AS akmods-zfs

FROM scratch AS ctx
COPY build_files /

# Base Image
FROM quay.io/fedora/fedora-coreos:${COREOS_VERSION}

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=akmods-zfs,src=/rpms,dst=/tmp/rpms/akmods-zfs \
	--mount=type=bind,from=akmods-common,src=/kernel-rpms,dst=/tmp/rpms/kernel \
	--mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
