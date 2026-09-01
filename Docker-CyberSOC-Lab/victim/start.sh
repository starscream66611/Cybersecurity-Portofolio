#!/bin/bash

# Create runtime directory required by SSH
mkdir -p /run/sshd

# Create shared log directory
mkdir -p /shared-logs

touch /shared-logs/access.log
touch /shared-logs/error.log
touch /shared-logs/auth.log

# Start Apache
service apache2 start

# Stream Apache logs to Splunk volume
tail -F /var/log/apache2/access.log >> /shared-logs/access.log &
tail -F /var/log/apache2/error.log >> /shared-logs/error.log &

# Start SSH and write logs directly into shared volume
/usr/sbin/sshd -D -E /shared-logs/auth.log &

echo "Victim server started. Apache + SSH logging enabled."

# Keep container alive
tail -f /dev/null