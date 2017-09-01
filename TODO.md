# TODO

1. When provisioning OpenStack host, over 5 minutes is spent upgrading the OS. Perhaps we can take a snapshot after
that process is done (i.e. after 'ansible-debian-upgrade-reboot' completes) and use that as our base image? It would
reduce deployment time.
1. Create admin and developer logins for Nexus and store them in vault.yml.
1. Create a job to run backup.yml against nexus-prod nightly. Can this be accomplished with Travis cron jobs? Or do
we need to do it on Jenkins?
1. Periodically test a FULL resoration of the PRODUCTION backups. It should not run more frequently than every two
weeks. Monthly maybe?
