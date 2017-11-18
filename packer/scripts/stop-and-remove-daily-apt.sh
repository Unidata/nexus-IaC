#!/usr/bin/env bash

# Exit immediately if any command exits with a non-zero status.
set -e

# Stop all apt services. We're mostly targeting the "apt-daily*" stuff.
systemctl stop 'apt*'

# Wait for apt to become available. This shouldn't take long since we've just stopped all activities.
# It may take a few seconds for the processes to die though.
/tmp/wait-for-free.sh /var/lib/dpkg/lock /var/lib/apt/lists/lock

# Remove the "unattended-upgrades" package, which is responsible for the "apt-daily*" services.
apt-get purge -y unattended-upgrades
