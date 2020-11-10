FROM opensuse/leap:latest

# metadata
LABEL description="Base OpenSUSE SAP container"
LABEL version="2020.11"

# set environment vars
ENV HOME=/root \
LC_CTYPE="en_US.UTF-8" \
LC_ALL="en_US.UTF-8" \
SHELL=/bin/bash

# install required packages
RUN zypper -n -q refresh -f \
&& zypper -n -q update -y --skip-interactive \
&& zypper -n -q install -f -y bzip2 \
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
&& zypper -n -q clean -a

# os-release
RUN echo -e "NAME=\"SLES\"\nVERSION=\"15\"\nVERSION_ID=\"15\"\nPRETTY_NAME=\"SUSE Linux Enterprise Server 15\"\nID=\"sles\"\nID_LIKE=\"suse\"\nANSI_COLOR=\"0;32\"\nCPE_NAME=\"cpe:/o:suse:sles:15\"" > /etc/os-release

# kernel params
RUN echo -e "fs.file-max=20000000\nfs.aio-max-nr=262144\nvm.memory_failue_early_kill=1\nvm.max_map_count=135217728\nnet.ipv4.ip_local_port_range=40000 60999" >> /etc/sysctl.d/sysctl.conf

# directories
RUN mkdir -p /install_media \
&& mkdir -p /run/uuidd

# create users and groups
RUN groupadd -g 8 mail \
&& groupadd -g 1000 sapsys \
&& useradd -g 1000 -G users -m -p 'Qwerty123' -s /usr/bin/csh -u 1000 sapadm \
&& useradd -g 1000 -G users -m -p 'Qwerty123' -s /usr/bin/csh -u 1001 hdbadm \
&& useradd -g 1000 -G users -m -p 'Qwerty123' -s /usr/bin/csh -u 1002 devadm \
&& useradd -g 1000 -G users -m -p 'Qwerty123' -s /usr/bin/csh -u 1003 daaadm
