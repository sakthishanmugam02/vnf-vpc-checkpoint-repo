##############################################################################
# Variable block - See each variable description
##############################################################################

##############################################################################
# vnf_cos_instance_id - Vendor provided COS instance-id hosting
#                               cp-GW image.
#                               The value for this variable is enter at offering
#                               onbaording time. This variable is hidden from the user.
##############################################################################
variable "vnf_cos_instance_id" {
  default     = ""
  description = "The COS instance-id hosting the cp-GW qcow2 image."
}

##############################################################################
# vnf_cos_image_url - Vendor provided cp-GW image COS url.
#                             The value for this variable is enter at offering
#                             onbaording time.This variable is hidden from the user.
##############################################################################
variable "vnf_cos_image_url" {
  default     = ""
  description = "The COS image object SQL URL for cp-GW qcow2 image."
}

##############################################################################
# vnf_cos_instance_id_test - Vendor provided COS instance-id hosting 
#                               cp-GW image in test.cloud.ibm.com. 
#                               The value for this variable is enter at offering
#                               onbaording time. This variable is hidden from the user.
##############################################################################
variable "vnf_cos_instance_id_test" {
  default     = ""
  description = "The COS instance-id hosting the cp-GW qcow2 image in test.cloud.ibm.com."
}

##############################################################################
# vnf_cos_image_url_test - Vendor provided cp-GW image COS url in test.cloud.ibm.com.
#                             The value for this variable is enter at offering
#                             onbaording time.This variable is hidden from the user.
##############################################################################
variable "vnf_cos_image_url_test" {
  default     = ""
  description = "The COS image object url for cp-GW qcow2 image in test.cloud.ibm.com."
}

##############################################################################
# zone - VPC zone where resources are to be provisioned.
##############################################################################
variable "zone" {
  default     = "us-south-1"
  description = "The VPC Zone that you want your VPC networks and virtual servers to be provisioned in. To list available zones, run `ibmcloud is zones`."
}

##############################################################################
# vpc_name - VPC where resources are to be provisioned.
##############################################################################
variable "vpc_name" {
  default     = ""
  description = "The name of your VPC where cp-GW VSI is to be provisioned."
}

##############################################################################
# subnet_name - Subnet where resources are to be provisioned.
##############################################################################
variable "subnet_id" {
  default     = ""
  description = " The id of the subnet where cp-GW VSI to be provisioned."
}
##############################################################################
# ssh_key_name - The name of the public SSH key to be used when provisining cp-GW VSI.
##############################################################################
variable "ssh_key_name" {
  default     = ""
  description = "The name of the public SSH key to be used when provisining cp-GW VSI."
}

##############################################################################
# vnf_vpc_image_name - The name of the cp-GW custom image to be provisioned in your IBM Cloud account.
##############################################################################
variable "vnf_vpc_image_name" {
  default     = "cp-GW-15-0-1-0-0-11"
  description = "The name of the cp-GW custom image to be provisioned in your IBM Cloud account."
}

##############################################################################
# vnf_vpc_image_name - The name of your cp-GW Virtual Server to be provisioned
##############################################################################
variable "vnf_instance_name" {
  default     = "cp-1arm-vsi01"
  description = "The name of your cp-GW Virtual Server to be provisioned."
}

##############################################################################
# vnf_profile - The profile of compute cpU and memory resources to be used when provisioning cp-GW VSI.
##############################################################################
variable "vnf_profile" {
  default     = "bx2-2x8"
  description = "The profile of compute cpU and memory resources to be used when provisioning cp-GW VSI. To list available profiles, run `ibmcloud is instance-profiles`."
}

variable "vnf_license" {
  default     = ""
  description = "Optional. The BYOL license key that you want your cp virtual server in a VPC to be used by registration flow during cloud-init."
}

variable "ibmcloud_endpoint" {
  default     = "cloud.ibm.com"
  description = "The IBM Cloud environmental variable 'cloud.ibm.com' or 'test.cloud.ibm.com'"
}

variable "destination_ip" {
  default     = ""
  description = "traffic rules for custom route"
}
