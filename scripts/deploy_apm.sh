#!/bin/bash

# Get commandline arguments
while (( "$#" )); do
  case "$1" in
    --destroy)
      flagDestroy="true"
      shift
      ;;
    --dry-run)
      flagDryRun="true"
      shift
      ;;
    --app-name)
      appName="$2"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

### Check input

# New Relic account ID
if [[ $NEWRELIC_ACCOUNT_ID == "" ]]; then
  echo "Define New Relic account ID as an environment variable [NEWRELIC_ACCOUNT_ID]. For example: -> export NEWRELIC_ACCOUNT_ID=xxx"
  exit 1
fi

# New Relic region
if [[ $NEWRELIC_REGION == "" ]]; then
  echo "Define New Relic region as an environment variable [NEWRELIC_REGION]. For example: -> export NEWRELIC_REGION=us or export NEWRELIC_REGION=eu"
  exit 1
else
  if [[ $NEWRELIC_REGION != "us" && $NEWRELIC_REGION != "eu" ]]; then
    echo "New Relic region can either be 'us' or 'eu'."
    exit 1
  fi
fi

# New Relic API key
if [[ $NEWRELIC_API_KEY == "" ]]; then
  echo "Define New Relic API key as an environment variable [NEWRELIC_API_KEY]. For example: -> export NEWRELIC_API_KEY=xxx"
  exit 1
fi

# Application name
if [[ $appName == "" ]]; then
  echo "Define application name with the flag [--app-name]. For example -> <mydopeappprod>"
  exit 1
fi

#################
### TERRAFORM ###
#################

if [[ $flagDestroy != "true" ]]; then

  # Initialize Terraform
  terraform -chdir=../terraform/apm init \
    -backend-config="resource_group_name=rgtrackereuwterraform" \
    -backend-config="storage_account_name=sttrackereuwterraform" \
    -backend-config="container_name=tfstates" \
    -backend-config="key=${NEWRELIC_ACCOUNT_ID}-apm-${appName}-local"

  # Plan Terraform
  terraform -chdir=../terraform/apm plan \
    -var NEW_RELIC_ACCOUNT_ID=$NEWRELIC_ACCOUNT_ID \
    -var NEW_RELIC_API_KEY=$NEWRELIC_API_KEY \
    -var NEW_RELIC_REGION=$NEWRELIC_REGION \
    -var app_name=$appName \
    -out "./tfplan"

  # Apply Terraform
  if [[ $flagDryRun != "true" ]]; then
    terraform -chdir=../terraform/apm apply tfplan
  fi
else

  # Destroy Terraform
  terraform -chdir=../terraform/apm destroy \
    -var NEW_RELIC_ACCOUNT_ID=$NEWRELIC_ACCOUNT_ID \
    -var NEW_RELIC_API_KEY=$NEWRELIC_API_KEY \
    -var NEW_RELIC_REGION=$NEWRELIC_REGION \
    -var app_name=$appName
fi
#########
