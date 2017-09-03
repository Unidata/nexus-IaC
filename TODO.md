# TODO

1. In `configure.sh`, run `restore.yml` after `site.yml`. Test that it works.
1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more
frequently than every two weeks. Monthly maybe?
1. Enable email notifications for the nexus-backup job on Jenkins.
1. For demo, ensure that we can provision on Ubuntu 14.
1. Add some spiffy Gradle magic in thredds-doc to upload the site to Nexus.
