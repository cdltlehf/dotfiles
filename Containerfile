# Reference: https://github.com/containers/common/blob/main/docs/Containerfile.5.md

FROM registry.fedoraproject.org/fedora-minimal:latest

RUN microdnf -y install --nodocs --setopt=install_weak_deps=0 \
    curl make \
    && microdnf clean all

WORKDIR /root/dotfiles
COPY . .

RUN make
