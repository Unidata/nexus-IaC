# TODO

1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more
frequently than every two weeks. Monthly maybe?
1. Break up the monolithic Apache config. See the comment at the top of vhosts.conf.
1. In restore.yml, we rename 'blobs' to 'blobs-old' and then restore 'blobs' from S3. That results in us downloading
the ENTIRE blobstore from S3. Slow and expensive! Instead, make a copy of 'blobs' at 'blobs-old' and then exploit
duplicity's rysnc functionality to restore 'blobs' in-place. Should be much faster.
1. On Travis, change the 2nd stage to run site.yml against OpenStack if the 1st stage is successful.
