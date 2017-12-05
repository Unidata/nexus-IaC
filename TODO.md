# TODO

1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more often
than every two weeks. Monthly maybe? A full build and test of THREDDS would exercise the restored server well.
   - Note that as of 2017-10-12, a full restoration required ~15m to download backups from S3 (currently ~10GB) and
     and another ~6m for Nexus to recreate its databases from the backup files.
     The job will have to account for that delay, possibly with something like this:
     https://stackoverflow.com/a/34522653/3874643
1. Break up the monolithic Apache config. See the comment at the top of vhosts.conf.
1. Remove `get_url.validate_certs=false` and `unarchive.validate_certs=false` from `prepare_tools.yml` once
Ansible 2.4.2 is released.
1. During reprovisioning, programmatically pause Uptime Robot's monitoring of artifacts, using its REST API.
1. Nuke the proxy repositories. Best to wait until both THREDDS master and 5.0.0 are no longer depending on them.
