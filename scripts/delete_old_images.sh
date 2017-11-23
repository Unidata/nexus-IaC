#!/usr/bin/env bash
# LOOK: This script assumes that prepare_tools.sh has been run already.

# Exit immediately if any command exits with a non-zero status.
set -e

# Add OpenStack variables to the environment. We created this file in prepare_tools.sh.
source ~/.openstack/openrc.sh

image_name_substr="nexus-"
num_images_to_keep=3

# Bash functions don't have return values.
# So instead, we're just going to print the values to STDOUT and capture them later.
function print_nexus_image_ids_sorted_by_creation_time() {
    # 1. Print all of the available Glance images. The fields will be in the format: ID,Name,Status
    # 2. Find the images with $image_name_substr in their names.
    # 3. Sort the matching lines by the 2nd field: Name. Our Packer-generated image names are of the form
    #    "nexus-yyyy-mm-ddThh:mm:ssZ", so when we sort them by Name, we're also sorting them by time of creation.
    # 4. Print only the 1st field of the remaining lines: ID.
    openstack image list --format csv --quote none | \
            grep "$image_name_substr"              | \
            sort --field-separator=, --key=2       | \
            cut -d , -f 1
}

nexus_image_ids=(`print_nexus_image_ids_sorted_by_creation_time`)  # Capture STDOUT lines into an array.
num_images="${#nexus_image_ids[@]}"

# If there are more than $num_images_to_keep images, delete the oldest ones.
for ((i = 0; i < num_images - num_images_to_keep; i++)); do
    image_id="${nexus_image_ids[$i]}"
    openstack image delete $image_id && echo "Deleted old image: $image_id"
done
