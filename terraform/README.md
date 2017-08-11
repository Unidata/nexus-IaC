# Orchestrating Jetstream resources using Terraform

We aim to describe the entirety of the infrastructure as code, and provision that infrastructure with [Terraform](
https://www.terraform.io/).

## OpenStack

Jetstream runs atop the [OpenStack cloud operating system](https://www.openstack.org/software/). To orchestrate
resources with Terraform, we'll need to interact with the system at the OpenStack level, not the Atmosphere level.

### Authentication

[Ensure that XSEDE and TACC credentials are in order](
https://iujetstream.atlassian.net/wiki/display/JWT/After+API+access+has+been+granted)

If you are not sure of your TACC password, you'll want to [reset it](
https://portal.tacc.utexas.edu/password-reset/-/password/request-reset). It is **not** set to the same as your XSEDE
password by default.

You'll then [setup openrc.sh](https://iujetstream.atlassian.net/wiki/display/JWT/Setting+up+openrc.sh).
The `OS_AUTH_URL` you'll need can be found [here](https://wiki.ucar.edu/display/unidata/Jetstream+Authentication).

Finally, execute `source openrc.sh` on the command line.

### CLI tools (Optional)

This step isn't required for Terraform to work, but for informational and debugging purposes, it can be useful to
have the OpenStack CLI tools installed. Plus, we can use the tools to ensure that we setup our `openrc.sh` properly.

There are docs on installing the tools for Mac [here](
https://iujetstream.atlassian.net/wiki/display/JWT/Installing+the+Openstack+clients+on+OS+X).
There are docs for Windows and Linux [here](
http://docs.openstack.org/user-guide/common/cli_install_openstack_command_line_clients.html). All you REALLY need is
`python-openstackclient`, which installs the `openstack` tool. However, a lot of literature on the internet references
older tools, such as `nova`, `keystone`, `glance`, etc. For those commands to work, you'll need to install the
appropriate packages, such as `python-novaclient`, `python-keystoneclient`, `python-glanceclient`, etc.

With that done, you can test your configuration by running `openstack image list`. If you get the catalog listing back,
you're ready to go. Please note that there are several Jetstream "Featured" API images available. They will be named
"JS-API-Featured-xxxxxx".

### Horizon dashboard

The Horizon dashboard is a GUI for OpenStack itself, and is VASTLY more powerful than the [Atmosphere dashboard](
https://use.jetstream-cloud.org/application/dashboard). You can use the dashboard to create resources if you wish,
but that seems silly given that we have Terraform. Instead, we can simply use it to verify that Terraform did the
work that we expected it to do.

Logging into the Horizon dashboard is covered [here](
https://iujetstream.atlassian.net/wiki/display/JWT/After+API+access+has+been+granted). And [this](
https://iujetstream.atlassian.net/wiki/display/JWT/Setup+for+Horizon+API+User+Instances) is a brief tutorial.

## Terraform

The capabilities of Terraform's [OpenStack provider](https://www.terraform.io/docs/providers/openstack/index.html)
closely match those of the [OpenStack CLI](https://docs.openstack.org/python-openstackclient/latest/cli/index.html).
That allows us to use the commands from the [Jetstream Wiki's OpenStack CLI Primer](
https://iujetstream.atlassian.net/wiki/display/JWT/OpenStack+command+line) as a basis for the resources that we need to
create using Terraform. We're also closely following [Terraform's openstack-with-networking example](
https://github.com/terraform-providers/terraform-provider-openstack/tree/master/examples/app-with-networking).

### Usage

Once you've [downloaded Terraform](https://www.terraform.io/downloads.html), change to this directory and run:

`terraform init`

You only need to do that once for each Terraform project. Next, do:

`terraform plan`

That'll display the changes that Terraform will make to the infrastructure. Finally, if those changes look good, do:

`terraform apply`
