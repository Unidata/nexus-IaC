# TODO

1. When provisioning OpenStack host, over 5 minutes is spent upgrading the OS. Perhaps we can take a snapshot after
that process is done (i.e. after 'ansible-debian-upgrade-reboot' completes) and use that as our base image? It would
reduce deployment time.
1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more
frequently than every two weeks. Monthly maybe?
1. Enable email notifications for the nexus-backup job on Jenkins.
