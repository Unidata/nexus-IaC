# Configure the OpenStack Provider. See https://www.terraform.io/docs/providers/openstack/index.html
# Commented out for now; we're using environment variables from openrc.sh instead.

//provider "openstack" {
//  # The Username to login with. If omitted, the OS_USERNAME environment variable is used.
//  user_name   = "admin"
//  # The Name of the Tenant (Identity v2) or Project (Identity v3) to login with.
//  # If omitted, the OS_TENANT_NAME or OS_PROJECT_NAME environment variable are used.
//  tenant_name = "admin"
//  # The Password to login with. If omitted, the OS_PASSWORD environment variable is used.
//  password    = "pwd"
//  # The Identity authentication URL. If omitted, the OS_AUTH_URL environment variable is used.
//  auth_url    = "http://myauthurl:5000/v2.0"
//}
