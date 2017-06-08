# Tests

Leverages Docker to ensure that our playbook is well-written and that it puts the system in the desired state.

## Local testing

Tests can be executed locally in two ways.

### Against an already-running Nexus instance on a Vagrant VM

In the provisioning directory, do:
```
ansible-playbook -i inventories/vagrant/hosts site.yml --tags "test"
```

This will execute only the functional tests defined in `/provisioning/tasks/tests.yml`.

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
1. Execute the functional tests defined in `/provisioning/tasks/tests.yml`.

#### Log in to container

It can sometimes be useful to "log in" to a container for debugging. Obviously, the container must still be running
in order to do this.

##### Leave container running

By default, `test.sh` will stop and remove the container after tests finish.
To skip the removal step, run the script like so:
```
cleanup=false ./test.sh
```
The container will also be left running if one of the tests fail.

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
