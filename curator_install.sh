#!/bin/bash
# Install script for curator on Security Onion and Elastic Stack
REPO="securityonion-curator-docker"
URL="https://github.com/weslambert/$REPO.git"
git clone $URL
echo "export DOCKER_CONTENT_TRUST=1" >> /etc/profile.d/securityonion-docker.sh
export DOCKER_CONTENT_TRUST=1
#docker pull wlambert/so-curator
cd $REPO
docker build -t so-curator .
mkdir -p /etc/curator/config
mkdir -p /etc/curator/action
mkdir -p /var/log/curator
chown -R 1000:1000 /etc/curator/
chown -R 1000:1000 /var/log/curator
cp -av etc/cron.d/* /etc/cron.d/
cp -av etc/config/* /etc/curator/config/
cp -av etc/action/* /etc/curator/action/

cat << EOF >> /etc/nsm/securityonion.conf


#Curator options
CURATOR_ENABLED="yes"
CURATOR_OPTIONS=""

EOF
