#!/usr/bin/env bash
#
# Wait up to 'timeout' seconds for a file to be free, i.e. no longer being accessed by any process on the system.
# Additionally, ensure that the file is free for at least 'desired_time_for_file_to_be_free' consecutive seconds.
#
# The script is intended to be used with lock files, specifically /var/lib/dpkg/lock, which we need exclusive access
# to when trying to update the Apt cache.

# "set -e" isn't appropriate here because fuser is expected to return non-zero.

elapsed=0
timeout=360
poll_interval=3

# Script will exit when the file has been free for this many consecutive seconds.
desired_time_for_file_to_be_free=15
# The number of consecutive seconds that the file has been free. Initialized to "-1", meaning "NOT FREE".
time_file_has_been_free=-1

lock_file=/var/lib/dpkg/lock

# Loop until (elapsed >= timeout) or (time_file_has_been_free >= desired_time_for_file_to_be_free).
while [ $elapsed -lt $timeout ]; do
  sudo fuser $lock_file

  if [ $? -eq 0 ]; then    # File is being accessed by a process.
    # Set to "-1", meaning "NOT FREE".
    time_file_has_been_free=-1
  else    # File is free!
    if [ $time_file_has_been_free -eq -1 ]; then
      # File was previously "NOT FREE". It's free now, but it's only been that way 1 time (zero seconds).
      time_file_has_been_free=0
    else
      # File was also free "poll_interval" seconds ago, so add that time.
      (( time_file_has_been_free += poll_interval ))
    fi
  fi

  if [ $time_file_has_been_free -ge $desired_time_for_file_to_be_free ]; then
    break    # File has been free for at least 'desired_time_for_file_to_be_free' consecutive seconds.
  fi

  sleep $poll_interval
  (( elapsed += poll_interval ))
done

if [ $elapsed -ge $timeout ]; then
  >&2 echo "Exceeded timeout ($timeout seconds) waiting for the file lock."
  exit 1
else
  echo "File has been free for $desired_time_for_file_to_be_free consecutive seconds. Waited $elapsed seconds total."
  exit 0
fi
