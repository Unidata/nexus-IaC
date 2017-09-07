# TODO

1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more
frequently than every two weeks. Monthly maybe?
1. Add some spiffy Gradle magic in thredds-doc to upload the site to Nexus.
1. Get certs for artifacts.unidata.ucar.edu and docs.unidata.ucar.edu. Globally change "artifacts2" -> "artifacts"
and "docs2" -> "docs".
1. Once we have real certs, delete all of the config that deals with self-signed certs.
