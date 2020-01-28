#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

####
## USAGE: Called by bash when exiting on error.
## Will dump stdout and stderr from lgo file to stdout
####
function error_exit() {
  cat "$MSG_FILE"
  exit 1
}

####
## USAGE: _log <log_message>
####
function _log() {
    echo "$1" > "$MSG_FILE"
}

####
## USAGE: prep_deps
## Install 'ibmcloud is' command and setting IBM cloud as gen 2.
####
function prep_deps() {
    _log "## Entering function: ${FUNCNAME[0]}"
    # Install the Infrastructure-Services IBMCloud CLI Plugin.
    ibmcloud plugin install infrastructure-service -f &> $MSG_FILE
    # Set IBM Cloud VPC to generation 2. As of now, it is hard coded.
    ibmcloud is target --gen 2 &> $MSG_FILE
    _log "## Exiting function: ${FUNCNAME[0]}"
}

####
## USAGE: parse_input
## Parsing input from the terraform and assigning to script variable.
## 1. custom_image_id - Custom Image ID which needs to be deleted after vsi creation.
## 2. ibmcloud_endpoint - IBM Cloud end-point, mostly "cloud.ibm.com"
## 3. ibmcloud_svc_api_key - IBM Cloud service API Key for login.
## 4. region - VPC region
####
function parse_input() {
    _log "## Entering function: ${FUNCNAME[0]}"
    eval "$(jq -r '@sh "custom_image_id=\(.custom_image_id) ibmcloud_endpoint=\(.ibmcloud_endpoint) ibmcloud_svc_api_key=\(.ibmcloud_svc_api_key) region=\(.region)"')"
    _log "## Exiting function: ${FUNCNAME[0]}"
}

####
## USAGE: login
## login to cloud.ibm.com
####
function login() {
    _log "## Entering function: ${FUNCNAME[0]}"
    # Login to IBMCloud for given region and resource-group
    ibmcloud login -a $ibmcloud_endpoint --apikey $ibmcloud_svc_api_key -r $region &> $MSG_FILE
    _log "## Exiting function: ${FUNCNAME[0]}"
}

####
## USAGE: delete_image
## Deleting Custom Image from User Account after VSI Creation.
####
function delete_image() {
    _log "## Entering function: ${FUNCNAME[0]}"
    # Command to elete Custom Image from user account.
    ibmcloud is image-delete $custom_image_id -f &> $MSG_FILE
    _log "## Exiting function: ${FUNCNAME[0]}"
}

####
## USAGE: produce_output
## Returnig output to terraform variable.
## Ex.
##    {
##        "custom_image_id": "r006-7d9aa110-a111-4386-a2a3-65568f2845cb"
##    }
####
function produce_output() {
    _log "## Entering function: ${FUNCNAME[0]}"
    jq -n --arg custom_image_id "$custom_image_id" '{"custom_image_id":$custom_image_id}'
    _log "## Exiting function: ${FUNCNAME[0]}"
}

#### Main Script execution starts here.
# Global variables shared by functoins
MSG_FILE="/tmp/out.log" && rm -f "$MSG_FILE" &> /dev/null && touch "$MSG_FILE" &> /dev/null

prep_deps
parse_input
login
delete_image
produce_output