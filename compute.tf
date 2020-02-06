##############################################################################
# This file creates the compute instances for the solution.
# - Virtual Server using cp-GW custom image
##############################################################################

##############################################################################
# Read/validate sshkey
##############################################################################
data "ibm_is_ssh_key" "cp_ssh_pub_key" {
  name = "${var.ssh_key_name}"
}

##############################################################################
# Read/validate vsi profile
##############################################################################
data "ibm_is_instance_profile" "vnf_profile" {
  name = "${var.vnf_profile}"
}

##############################################################################
# Create CHECKPOINT virtual server.
##############################################################################
resource "ibm_is_instance" "cp_vsi" {
  name    = "${var.vnf_instance_name}"
  image   = "${data.ibm_is_image.cp_custom_image.id}"
  profile = "${data.ibm_is_instance_profile.vnf_profile.name}"

  primary_network_interface = {
    subnet = "${data.ibm_is_subnet.cp_subnet1.id}"
  }

  vpc  = "${data.ibm_is_vpc.cp_vpc.id}"
  zone = "${data.ibm_is_zone.zone.name}"
  keys = ["${data.ibm_is_ssh_key.cp_ssh_pub_key.id}"]

  # user_data = "$(replace(file("cp-userdata.sh"), "cp-LICENSE-REPLACEMENT", var.vnf_license)"

  //User can configure timeouts
  timeouts {
    create = "10m"
    delete = "10m"
  }
  # Hack to handle some race condition; will remove it once have root caused the issues.
  provisioner "local-exec" {
    command = "sleep 30"
  }
}
