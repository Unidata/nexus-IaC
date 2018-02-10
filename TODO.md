# TODO

1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more often
than every two weeks. Monthly maybe? A full build and test of THREDDS would exercise the restored server well.
   - Note that as of 2017-10-12, a full restoration required ~15m to download backups from S3 (currently ~10GB) and
     and another ~6m for Nexus to recreate its databases from the backup files.
     The job will have to account for that delay, possibly with something like this:
     https://stackoverflow.com/a/34522653/3874643
1. Break up the monolithic Apache config. See the comment at the top of vhosts.conf.
1. During reprovisioning, programmatically pause Uptime Robot's monitoring of artifacts, using its REST API.
1. ansible-oracle-java seems to break each time Oracle releases a new JDK. To fix, I need to pull new commits from
upstream that manually update the JDK version and hash numbers. Instead, we should be detecting the latest version
automatically. Oracle doesn't make that easy, but there is a script that seems to work:
https://gist.github.com/n0ts/40dd9bd45578556f93e7
