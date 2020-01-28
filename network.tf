##############################################################################
# This file creates various network resources for the solution.
#  - VPC in user specified region and resource_group
#  - Address_Prefix in user specified region, zone and resource_group (for poc is using default)
#  - Public_Gateway in user specified region, zone and resource_group
#  - Subnet in user specified region, zone and resource_group
#  - Floating_IP attached to virtual server's primary network interface
##############################################################################


##############################################################################
# Read/validate VPC
##############################################################################
data "ibm_is_vpc" "cp_vpc" {
  name = "${var.vpc_name}"
}

data "ibm_is_subnet" "cp_subnet1" {
  identifier = "${var.subnet_id}"
}

# resource block to create vpc route rules
resource "ibm_is_vpc_route" "custom_route" {
  name        = "cp-route"
  vpc         = "${data.ibm_is_vpc.cp_vpc.id}"
  zone        = "${var.zone}"
  destination = "${var.destination_ip}"
  next_hop    = "${ibm_is_instance.cp_vsi.primary_network_interface.0.primary_ipv4_address}"
}
