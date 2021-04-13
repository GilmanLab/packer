#!/usr/bin/env bash

# Install required packages
apt install -y \
    realmd \
    libnss-sss \
    libpam-sss \
    sssd \
    sssd-tools \
    adcli \
    samba-common-bin \
    smbclient \
    oddjob \
    oddjob-mkhomedir \
    packagekit \
    krb5-user

# Enable home directories
pam-auth-update --enable mkhomedir