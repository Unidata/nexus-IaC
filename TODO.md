# TODO

1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more
frequently than every two weeks. Monthly maybe?
1. Add some spiffy Gradle magic in thredds-doc to upload the site to Nexus.
1. Break up the monolithic Apache config. See the comment at the top of vhosts.conf.
1. In restore.yml, we rename 'blobs' to 'blobs-old' and then restore 'blobs' from S3. That results in us downloading
the ENTIRE blobstore from S3. Slow and expensive! Instead, make a copy of 'blobs' at 'blobs-old' and then exploit
duplicity's rysnc functionality to restore 'blobs' in-place. Should be much faster.
1. For security, delete the default OS user (e.g. 'ubuntu' or 'debian'). It should correspond to `ansible_user`.
At the very least, delete the user's `authorized_keys`, so that login—post provisioning—is restricted to the users we
setup in `users-and-groups.yml`.
1. As of Nexus 3.3, tasks can be manually run using a simpler REST API endpoint that does *not* involve a Groovy
script. Let's use that instead in backup.yml. See https://artifacts.unidata.ucar.edu/swagger-ui/#/ and
http://www.sonatype.org/nexus/2017/09/25/nexus-repository-new-beta-rest-api-for-content/.
