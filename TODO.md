# TODO

1. Create Jenkins job to periodically test a FULL restoration of the PRODUCTION backups. It should not run more often
than every two weeks. Monthly maybe? A full build and test of THREDDS would exercise the restored server well.
   - Note that as of 2017-10-12, a full restoration required ~15m to download backups from S3 (currently ~10GB) and
     and another ~6m for Nexus to recreate its databases from the backup files.
     The job will have to account for that delay, possibly with something like this:
     https://stackoverflow.com/a/34522653/3874643
1. Break up the monolithic Apache config. See the comment at the top of vhosts.conf.
1. During reprovisioning, programmatically pause Uptime Robot's monitoring of artifacts, using its REST API.
1. Install [Fail2ban](https://www.fail2ban.org/wiki/index.php/Main_Page). nexus-prod is starting to get a lot of
traffic, apparently from other Maven repo managers that are proxying it. The user agents are strings like
"Artifactory/4.5.2", "Artifactory/5.6.0", "Nexus/3.6.0-02", etc. I'm seeing up to 3 requests per second. Not sure
if this is a pressing concern.
1. The original project at https://github.com/savoirfairelinux/ansible-nexus3-oss (that I forked) is no longer being
maintained. However, there's a new high-quality fork at https://github.com/ansible-ThoTeam/nexus3-oss. Consider
integrating my changes into that. I've already copied some of its code for configuring Nexus's email settings.
1. Automate the periodic generation of the Ubuntu base image on Jetstream. This is tricky because we need to provide
appropriate values for `builders[0].source_image_name` in both `packer/openstack-base.json` and
`packer/openstack-nexus.json`.
