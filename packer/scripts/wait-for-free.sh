#!/usr/bin/env bash
#
# Wait up to TIMEOUT seconds for the script arguments (which are files) to be free, i.e. no longer accessed by any
# process on the system. Additionally, ensure that they are free for at least DESIRED_TIME_FOR_FILES_TO_BE_FREE
# consecutive seconds.
#
# The script is intended to be used with lock files, specifically '/var/lib/dpkg/lock' and '/var/lib/apt/lists/lock',
# which we need exclusive access to when trying to do anything with apt.

# "set -e" isn't appropriate here because fuser is expected to return non-zero.

ELAPSED=0
TIMEOUT=360
POLL_INTERVAL=3

# Script will exit when the files have been free for this many consecutive seconds.
DESIRED_TIME_FOR_FILES_TO_BE_FREE=9

# The number of consecutive seconds that the files have been free. Initialized to "-1", meaning "NOT FREE".
TIME_FILES_HAVE_BEEN_FREE=-1

if [ $# -eq 0 ]; then
    echo "ERROR: Specify the path(s) of file(s) to wait on."
    exit 1
fi

# Loop until (ELAPSED >= TIMEOUT) or (TIME_FILES_HAVE_BEEN_FREE >= DESIRED_TIME_FOR_FILES_TO_BE_FREE).
while [ $ELAPSED -lt $TIMEOUT ]; do
  sudo fuser $*

  if [ $? -eq 0 ]; then    # At least one file is being accessed by a process.
    # Set to "-1", meaning "NOT FREE".
    TIME_FILES_HAVE_BEEN_FREE=-1
  else    # All files are free!
    if [ $TIME_FILES_HAVE_BEEN_FREE -eq -1 ]; then
      # Files were previously "NOT FREE". They're free now, but it's only been so this instant (zero seconds).
      TIME_FILES_HAVE_BEEN_FREE=0
    else
      # Files were also free POLL_INTERVAL seconds ago, so add that time.
      (( TIME_FILES_HAVE_BEEN_FREE += POLL_INTERVAL ))
    fi
  fi

  if [ $TIME_FILES_HAVE_BEEN_FREE -ge $DESIRED_TIME_FOR_FILES_TO_BE_FREE ]; then
    break  # Files have been free for at least DESIRED_TIME_FOR_FILES_TO_BE_FREE consecutive seconds.
  fi

  sleep $POLL_INTERVAL
  (( ELAPSED += POLL_INTERVAL ))
done

if [ $ELAPSED -ge $TIMEOUT ]; then
  >&2 echo "Exceeded TIMEOUT ($TIMEOUT seconds) waiting for [$*] to become available."
  exit 1
else
  echo "[$*] have been free for $DESIRED_TIME_FOR_FILES_TO_BE_FREE consecutive seconds. Waited $ELAPSED seconds total."
  exit 0
fi
