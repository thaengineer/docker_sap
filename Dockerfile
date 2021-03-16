FROM opensuse/leap:latest

# metadata
LABEL release.description="Base OpenSUSE SAP container"
LABEL release.version="2021.03"
LABEL release.license="none"

# environment
ENV HOSTNAME=sapdevci \
HOME=/root \
LC_CTYPE="en_US.UTF-8" \
LC_ALL="en_US.UTF-8" \
SHELL=/bin/bash

# install required packages
RUN zypper -q -n refresh -f \
&& zypper -q -n update -y --no-recommends \
&& zypper -q -n install -y -l --no-recommends \
bzip2 \
chrony \
curl \
expect \
file \
gzip \
hostname \
htop \
iproute2 \
iputils \
java-1_8_0-openjdk \
java-1_8_0-openjdk-devel \
java-1_8_0-openjdk-headless \
less \
libatomic1 \
net-tools \
numactl \
openssh \
p7zip \
python \
python-pip \
sudo \
systemd \
systemd-sysvinit \
tar \
tcsh \
unrar \
unzip \
util-linux-systemd \
uuidd \
vim \
which \
xz \
zip \
&& zypper -q -n clean -a \
&& rm -rf /var/cache/zypp/*

# os-release
RUN rm -f /etc/os-release \
&& echo -e 'NAME="SLES"\nVERSION="12-SP3"\nVERSION_ID="12.3"\nPRETTY_NAME="SUSE Linux Enterprise Server 12 SP3"\nID="sles"\nANSI_COLOR="0;32"\nCPE_NAME="cpe:/o:suse:sles:12:sp3"' >> /etc/os-release

# kernel params
RUN echo -e "fs.file-max=20000000\nfs.aio-max-nr=262144\nvm.memory_failue_early_kill=1\nvm.max_map_count=135217728\nnet.ipv4.ip_local_port_range=40000 60999" >> /etc/sysctl.d/sysctl.conf

# directories
RUN mkdir -p /install_media \
&& mkdir -p /run/uuidd

# create users and groups
# && useradd -g 1000 -G users -m -p 'Qwerty123' -s /usr/bin/csh -u 1000 sapadm \
RUN groupadd -g 1000 sapsys \
&& useradd -g 1000 -G users -m -s /usr/bin/csh -u 1000 -p 'Qwerty123' hdbadm \
&& useradd -g 1000 -G users -m -s /usr/bin/csh -u 1001 -p 'Qwerty123' sapadm \
&& useradd -g 1000 -G users -m -s /usr/bin/csh -u 1002 -p 'Qwerty123' devadm \
&& useradd -g 1000 -G users -m -s /usr/bin/csh -u 1003 -p 'Qwerty123' daaadm

# open required ports
EXPOSE 22 1128-1129 3200-3399 3600-3699 4238-4241 4800-4899 8000-8199 30000-50000-59916
