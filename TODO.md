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
1. ansible-debian-upgrade-reboot seems to always restart the host, even if nothing was updated. If we're going to run
site.yml against the OpenStack VM nightly and after every commit, that's gonna lead to unacceptable downtime.
1. Now that we've incorporated Packer, I don't think we need to provide unidata_provisioner_id_rsa in
prepare_tools.yml any longer. The key is still needed by backup_prod.sh, however.
1. Remove `get_url.validate_certs=false` and `unarchive.validate_certs=false` from `prepare_tools.yml` once
Ansible 2.4.2 is released.
