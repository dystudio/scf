
# Path to the file containing the private-key part of an openstack
# key-pair created manually within MPC.

key_file             = "..."

# The name of the aforementioned key-apir, as known to MPC.

openstack_keypair    = "..."

# The network id provided by openstack to access everything.

openstack_network_id = "..."

# The 'name' of the 'cluster' to create. All resources created by the
# setup will have this string as their prefix. Use this to distinguish
# the setup from all other similar setups.

cluster-prefix       = "..."

## HP's Docker Trusted Registry: Authentication
docker_username = "legituser"
docker_email    = "legit@user"
docker_password = "trustme"

## DTR location and images inside
## The defaults are in hcf.tf
## Only the hcf_version should be changed, to select among the
## possible hcf versions.
#docker_trusted_registry = ""
#docker_org              = "helioncf"
#hcf_image_prefix        = "hcf-"
#hcf_version             = "..."
