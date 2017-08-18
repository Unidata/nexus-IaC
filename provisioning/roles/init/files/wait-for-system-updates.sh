#!/usr/bin/env bash
#
# Waits up to $timeout seconds for a file to no longer be accessed by any process on the system.
# Additionally, once the file is found to be free, it ensures that the file is STILL free $sleep_time seconds later.
#
# The script is intended to be used with lock files, specifically /var/lib/dpkg/lock, which we need exclusive access
# to when trying to update the Apt cache.

elapsed=0
timeout=180
sleep_time=3
lock_file=/var/lib/dpkg/lock

while [ $elapsed -lt $timeout ]; do    # Loop until elapsed >= timeout.
  sleep $sleep_time
  (( elapsed += sleep_time ))

  sudo fuser $lock_file
  if [ $? -eq 0 ]; then
    continue    # Process still accessing file. Continue looping.
  fi

  # File is free *now*, but may start being accessed by another (likely related) process almost immediately.
  # Wait a bit longer and assert that the file is still free.
  sleep $sleep_time
  (( elapsed += sleep_time ))

  sudo fuser $lock_file
  if [ $? -ne 0 ]; then
    break    # File is still free! Exit the loop.
  fi
done

if [ $elapsed -ge $timeout ]; then
  >&2 echo "Exceeded timeout ($timeout seconds) waiting for the file lock."
  exit 1
else
  echo "Waited $elapsed seconds."
  exit 0
fi
