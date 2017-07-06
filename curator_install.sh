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
cp -av $REPO/etc/cron.d/* /etc/cron.d/
cp -av $REPO/etc/curator/config/* /etc/curator/config/
cp -av $REPO/etc/curator/action/* /etc/curator/action/

cat << EOF >> /etc/nsm/securityonion.conf


#Curator options
CURATOR_ENABLED="yes"
CURATOR_OPTIONS=""

EOF

cat << EOF >> /usr/sbin/so-elastic-start

if [ "$CURATOR_ENABLED" = "yes" ]; then
        echo -n "so-curator: "
        docker run --name=so-curator \
                --detach \
#                --link=so-elasticsearch:elasticsearch \
                --volume /etc/curator/config/curator.yml:/etc/curator/config/curator.yml:ro \
                --volume /etc/curator/action/:/etc/curator/action/:ro \
                --volume /var/log/curator/:/var/log/curator/ \
                so-curator
fi

EOF
