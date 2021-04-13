#!/usr/bin/env bash

# Disable sudo password
sed -i 's/^%sudo.*/%sudo   ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

# Change password
echo "administrator:$ADMIN_PASSWORD" | chpasswd

# Upgrade
apt-get update
apt-get upgrade -y

# Prepare for cloning
rm -rf /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
rm -rf /etc/cloud/cloud.cfg.d/99-installer.cfg
rm -rf /var/lib/cloud/seed/nocloud
rm -rf /var/lib/cloud/seed/nocloud-net
echo 'disable_vmware_customization: false' >> /etc/cloud/cloud.cfg

# Install powershell
apt-get install -y wget apt-transport-https software-properties-common

wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
dpkg -i /tmp/packages-microsoft-prod.deb
apt-get update

add-apt-repository universe
apt-get install -y powershell