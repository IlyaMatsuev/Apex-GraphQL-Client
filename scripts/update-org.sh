#!/bin/sh

# This script deploys and configures the package to the sandbox or dev org by the provided username or alias
# Example: ./scripts/update-org.sh test.sandbox@test.com

org_alias=$1

if [[ -z "$org_alias" ]]
then
	echo "Specify the org alias as the first parameter."
	exit 1
fi

echo
echo "Authorizing the org..."
echo "Please login to the org."
sfdx force:auth:web:login -a "$org_alias"

echo
echo "Deploying to $org_alias..."
sfdx force:source:deploy -u "$org_alias" -p ./src

echo
echo "Assigning permissions..."
sfdx force:user:permset:assign -n GraphQLApexClientUser -u "$scratch_alias"

echo
echo "Deployment has been finished."
echo "Open the org with 'sfdx force:org:open -u $org_alias'"
