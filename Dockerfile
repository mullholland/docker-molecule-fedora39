FROM fedora:39

LABEL maintainer="mullholland"
LABEL build_update="2023-05-18"

ENV container=docker

RUN dnf -y update && dnf clean all

# Enable systemd.
RUN dnf -y update && dnf clean all \
  && dnf -y install systemd && dnf clean all && \
  (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install requirements.
RUN dnf makecache \
 && dnf upgrade -y \
 && dnf -y install \
      sudo \
      which \
      ca-certificates \
      iproute \
      util-linux \
 && dnf clean all

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers


VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

CMD ["/usr/sbin/init"]
