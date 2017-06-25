# Testing

Leverages Docker to ensure that our playbook is well-written and that it puts the system in the desired state.

## Local testing

Tests can be executed locally in two ways.

### Against an already-running Nexus instance on a Vagrant VM

In the provisioning directory, do:
```
ansible-playbook -i inventories/vagrant/hosts test.yml
ansible-playbook -i inventories/vagrant/hosts -v test.yml --tags "git-lfs"
```

This will execute only the tests included in the test playbook; Nexus config is assumed to have already been done.

### Against a fresh Docker container

After installing [Docker](https://www.docker.com/), do the following in this directory:
```
./test.sh
```

This script will:

1. Download the [docker-ubuntu1604-ansible](https://hub.docker.com/r/geerlingguy/docker-ubuntu1604-ansible/) image
   and run it in a new container.
1. [Check the syntax](https://ansible-tips-and-tricks.readthedocs.io/en/latest/ansible/commands/#check-for-bad-syntax)
   of the main playbook.
1. Run the main playbook to ensure that the configuration of Nexus succeeds.
1. Run the main playbook again, to test whether it is idempotent.
1. Run the test playbook.

#### Log in to container

It can sometimes be useful to "log in" to a container for debugging. Obviously, the container must still be running
in order to do this.

##### Leave container running

By default, `test.sh` will stop and remove the container after tests finish.
To skip the removal step, run the script like so:
```
cleanup=false ./test.sh
```
The container will also be left running if one of the tests fails.

##### Find container ID

```
docker ps
```

##### Attach to container

```
docker exec -it [container-id] bash
```

This will drop you into a bash shell inside the container. When fininshed, type `exit`.

[Reference](https://stackoverflow.com/a/26496854/3874643)

##### Remove container

Once you're done debugging, stop and remove the container:
 ```
 docker rm -f [container-id]
 ```
It should no longer appear in `docker ps`.

## Continuous integration

`test.sh` runs automatically on [Travis](https://travis-ci.org/cwardgar/nexus-IaC) each time we push a commit to GitHub.

## Inclusion of third-party software

This project contains source code from Jeff Geerling's
[Ansible Role Test Shim Script](https://gist.github.com/geerlingguy/73ef1e5ee45d8694570f334be385e181/).
The license for the script is not explicitly stated, but it is likely MIT, as that is the license he uses for all of
his [GitHub public repositories](https://github.com/geerlingguy?tab=repositories).

A copy of the MIT license can be found in `/licenses/third-party/geerlingguy/`.

### Details of use

`test.sh` is derived from the aforementioned script. We've simplified it by dropping support for all Linux distros
except 'ubuntu1604'. We've also done some light refactoring and documentation additions. Finally, we've added
support for running a separate playbook that includes tests only.
