#!/bin/sh

# This script deploys and configures the package to the sandbox or dev org by the provided username or alias
# Example: ./scripts/pkg-deploy.sh test.sandbox@test.com

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

org_alias=$1

info() {
    echo
    echo "${green}$1${reset}"
}

error() {
    echo "${red}$1${reset}"
	exit 1
}

if [[ -z "$org_alias" ]]
then
	error "Specify the org alias or username as the first parameter"
fi

info "Installing dependencies..."
sfdx force:package:install -p <package-id> -w 10 -b 10 -u "$org_alias" \
    || (\
        info "Please login to the org" \
        && sfdx force:auth:web:login -a "$org_alias" \
        && sfdx force:package:install -p <package-id> -w 10 -b 10 -u "$org_alias" \
    ) || { exit 1; }

info "Deploying to $org_alias..."
sfdx force:source:deploy -u "$org_alias" -p ./src || { exit 1; }

info "Assigning permissions..."
sfdx force:user:permset:assign -n GraphQLApexClientUser -u "$org_alias"

info "Deployment has been finished.\\nOpen the org with 'sfdx force:org:open -u $org_alias'"
