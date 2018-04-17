#!/bin/sh

# Set timezone
TZ=${TZ:-UTC}
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Make sure volumes are mounted correctly
if [ ! -d /usr/lib/unifi/data ]; then
  printf "\nERROR: volume /usr/lib/unifi/data not mounted.\n" >&2
  exit 1
fi

# Copy default system.properties file
if [ ! -e /usr/lib/unifi/data/system.properties ]; then
  cp /etc/unifi/system.properties /usr/lib/unifi/data/.
fi

# Create default site folder
if [ ! -d /usr/lib/unifi/data/sites/default ]; then
  mkdir -p /usr/lib/unifi/data/sites/default
fi

# Copy default config.properties file
if [ ! -e /usr/lib/unifi/data/sites/default/config.properties ]; then
  cp /etc/unifi/config.properties /usr/lib/unifi/data/sites/default/.
fi

# Fix user and group ownerships
chown -R root:root /usr/lib/unifi/data

# Change workdir
cd /usr/lib/unifi

# Start unifi in console mode
exec /usr/bin/java "$@" -Djava.awt.headless=true -jar /usr/lib/unifi/lib/ace.jar start
