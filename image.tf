##############################################################################
# This file creates custom image using cp-GW qcow2 image hosted in vnfsvc COS
#  - Creates IAM Authorization Policy in vnfsvc account
#  - Creates Custom Image in User account
#
# Note: There are following gaps in ibm is provider and thus using Terraform tricks
# to overcome the gaps for the PoC sake.
##############################################################################

locals {
  user_acct_id = "${substr(element(split("a/", data.ibm_is_vpc.cp_vpc.resource_crn), 1), 0, 32)}"
  apikey       = "${var.ibmcloud_endpoint == "cloud.ibm.com" ? var.ibmcloud_svc_api_key : var.ibmcloud_svc_api_key_test}"
  instance_id  = "${var.ibmcloud_endpoint == "cloud.ibm.com" ? var.vnf_cos_instance_id : var.vnf_cos_instance_id_test}"
  image_url    = "${var.ibmcloud_endpoint == "cloud.ibm.com" ? var.vnf_cos_image_url : var.vnf_cos_image_url_test}"
}

# IAM Authorization to create custom images
data "external" "authorize_policy_for_image" {
  depends_on = ["data.ibm_is_vpc.cp_vpc"]
  program    = ["bash", "${path.module}/scripts/create_auth.sh"]

  query = {
    ibmcloud_endpoint           = "${var.ibmcloud_endpoint}"
    ibmcloud_svc_api_key        = "${local.apikey}"
    source_service_account      = "${local.user_acct_id}"
    source_service_name         = "is"
    source_resource_type        = "image"
    target_service_name         = "cloud-object-storage"
    target_resource_type        = "bucket"
    roles                       = "Reader"
    target_resource_instance_id = "${local.instance_id}"
    region                      = "${data.ibm_is_region.region.name}"
    resource_group_id           = "${data.ibm_resource_group.rg.id}"
  }
}

# Generating random ID
resource "random_uuid" "test" {}

resource "ibm_is_image" "cp_custom_image" {
  depends_on       = ["data.external.authorize_policy_for_image", "random_uuid.test"]
  href             = "${local.image_url}"
  name             = "${var.vnf_vpc_image_name}-${random_uuid.test.result}"
  operating_system = "centos-7-amd64"

  timeouts {
    create = "30m"
    delete = "10m"
  }
}

data "external" "delete_auth_policy_for_image" {
  depends_on = ["ibm_is_image.cp_custom_image"]
  program    = ["bash", "${path.module}/scripts/delete_auth.sh"]

  query = {
    id                   = "${lookup(data.external.authorize_policy_for_image.result, "id")}"
    ibmcloud_endpoint    = "${var.ibmcloud_endpoint}"
    ibmcloud_svc_api_key = "${local.apikey}"
    region               = "${data.ibm_is_region.region.name}"
  }
}

data "ibm_is_image" "cp_custom_image" {
  name       = "${var.vnf_vpc_image_name}-${random_uuid.test.result}"
  depends_on = ["ibm_is_image.cp_custom_image"]
}

output "auth_policy_id" {
  value = "${lookup(data.external.authorize_policy_for_image.result, "id")}"
}
