#!/bin/sh

# This script creates a new scratch org with deployed and configured package
# The script requires at least 2 parameters: devhub username/alias and new scratch org alias
# Example: ./scripts/init-scratch.sh dev.hub@test.com test.scratch@test.com

default_scratch_duration=7

scratch_alias=$1
dev_hub_alias=$2
days=${3:-$default_scratch_duration}

if [[ -z "$scratch_alias" ]]
then
	echo "Specify a scratch org alias as the first parameter."
	exit 1
fi

if [[ -z "$dev_hub_alias" ]]
then
	echo "Specify a dev hub org alias as the second parameter."
	exit 1
fi

echo
echo "Authorizing the dev hub..."
echo "Please login to your DevHub org."
sfdx force:auth:web:login -a "$dev_hub_alias"

echo
echo "Creating scratch..."
sfdx force:org:create -f ./config/project-scratch-def.json -a "$scratch_alias" -v "$dev_hub_alias" -d "$days"

echo
echo "Deploying to $scratch_alias..."
sfdx force:source:push -u "$scratch_alias"

echo
echo "Assigning permissions..."
sfdx force:user:permset:assign -n GraphQLApexClientUser -u "$scratch_alias"

echo
echo "Deployment has been finished."
echo "Open the scratch with 'sfdx force:org:open -u $scratch_alias'"
