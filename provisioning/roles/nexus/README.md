# nexus

This role installs and configures [Nexus Repository Manager OSS](https://www.sonatype.com/nexus-repository-oss)
version 3.x on Ubuntu 16.04.

## Inclusion of third-party software

This project contains source code from [ansible-nexus3-oss](https://github.com/savoirfairelinux/ansible-nexus3-oss),
version 1.7.1. The license for that project is available in `/licenses/third-party/ansible-nexus3-oss/`.

### Details of use:

The original project aims to be more configurable and robust than our needs require. So, we've stripped away all of
the automation that we won't need for our immutable server. The list of changes is too long to track;
in reality, we're rewriting the entire role, using the original project as a guide (and copying some bits).
