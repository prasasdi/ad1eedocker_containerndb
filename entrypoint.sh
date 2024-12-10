#!/bin/bash

# Buat user baru dan atur password dari environment variables
useradd -ms /bin/bash $SSH_USERNAME
echo "$SSH_USERNAME:$SSH_PASSWORD" | chpasswd
adduser $SSH_USERNAME sudo

# Konfigurasi SSH
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'export VISIBLE=now' >> /etc/profile

# Mulai SSH daemon
service ssh start

# Eksekusi CMD dari Dockerfile atau docker-compose.yml
exec "$@"
