#!/bin/bash

scriptDir=$(dirname ${0})

source ${scriptDir}/tf_fmt.sh

function parseInputs {
 
  # Required inputs
  if [ "${INPUT_TERRAFORM_VERSION}" != "" ]; then
    tfVersion=${INPUT_TERRAFORM_VERSION}
  else
    echo "Input terraform_version cannot be empty"
    exit 1
  fi

  if [ "${INPUT_TERRAFORM_SUBCOMMAND}" != "" ]; then
    tfSubcommand=${INPUT_TERRAFORM_SUBCOMMAND}
  else
    echo "Input terraform_subcommand cannot be empty"
    exit 1
  fi
 
  # Optional inputs
  tfWorkingDir=${INPUT_TERRAFORM_WORKING_DIR}
}


function installTerraform {
  url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"
  echo "Downloading Terraform v${tfVersion}"
  curl -s -L -o /tmp/terraform_${tfVersion} ${url}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to download Terraform v${tfVersion}"
    exit 1
  fi
  unzip -d /usr/local/bin /tmp/terraform_${tfVersion}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to unzip Terraform v${tfVersion}"
    exit 1
  fi
}

# function debug {

#   pwd
#   ls -la
#   printenv

#   cat ${GITHUB_EVENT_PATH}
# }

parseInputs

case "${tfSubcommand}" in
  fmt)
    installTerraform
    terraformFmt
    ;;
  *)
    echo "Error: Must provide a valid value for terraform_subcommand"
    ;;
esac