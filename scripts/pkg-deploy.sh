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

info "Deploying components..."
sf project:deploy:start -o "$org_alias" -d ./src \
    || (\
        info "Please login to the org" \
        && sf org:login:web -a "$org_alias" \
        && sf project:deploy:start -o "$org_alias" -d ./src \
    ) || { exit 1; }

info "Assigning permissions..."
sf user:permset:assign -n GraphQLApexClientUser -u "$org_alias"

info "Deployment has been finished.\\nOpen the org with 'sf org:open -o $org_alias'"
