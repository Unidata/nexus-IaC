# TODO

1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more often
than every two weeks. Monthly maybe? A full build and test of THREDDS would exercise the restored server well.
   - Note that as of 2017-10-12, a full restoration required ~15m to download backups from S3 (currently ~10GB) and
     and another ~6m for Nexus to recreate its databases from the backup files.
     The job will have to account for that delay, possibly with something like this:
     https://stackoverflow.com/a/34522653/3874643
1. Break up the monolithic Apache config. See the comment at the top of vhosts.conf.
1. In restore.yml, we rename 'blobs' to 'blobs-old' and then restore 'blobs' from S3. That results in us downloading
the ENTIRE blobstore from S3. Slow and expensive! Instead, make a copy of 'blobs' at 'blobs-old' and then exploit
duplicity's rysnc functionality to restore 'blobs' in-place. Should be much faster.
1. Remove `get_url.validate_certs=false` and `unarchive.validate_certs=false` from `prepare_tools.yml` once
Ansible 2.4.2 is released.
1. The "Jenkins build is back to normal" notification doesn't work in `nexus-reprovision-pipeline.groovy`.
I've attempted to fix this, but I don't know if it worked yet. We'll have to wait for the next pipeline failure.
1. Update description and README.md to indicate that the server is now an immutable phoenix.
1. Add monitoring.
1. Nuke the proxy repositories. In thredds 5.0.0, the only 3rd party repo we use is bintray for Gretty.
1. Consider renaming inventory directories to 'nexus-prod', 'nexus-dev', and 'nexus-test'. The reason is that there's
not actually anything OpenStack-specific in `inventories/openstack` any more. In fact, `amazon-nexus.json` uses it
as its inventory when it creates a Nexus image on AWS.
1. Change developer password. Couldn't hurt to change the admin password too.
1. Create a Nexus page on the UCAR wiki. It ought to have the admin password.
