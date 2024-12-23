#!/bin/sh

# This script creates a new scratch org with deployed and configured package
# The script requires at least 2 parameters: devhub username/alias and new scratch org alias
# Example: ./scripts/pkg-from-scratch.sh dev.hub@test.com test.scratch@test.com

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
default_scratch_duration=10

devhub_alias=$1
scratch_alias=$2
days=${3:-$default_scratch_duration}

info() {
    echo
    echo "${green}$1${reset}"
}

error() {
    echo "${red}$1${reset}"
	exit 1
}

if [[ -z "$devhub_alias" ]]
then
	error "Specify a dev hub org alias as the first parameter"
fi

if [[ -z "$scratch_alias" ]]
then
	error "Specify a scratch org alias as the second parameter"
fi

info "Creating scratch..."
sf org:create:scratch -f ./config/project-scratch-def.json -v "$devhub_alias" -a "$scratch_alias" -y "$days" \
    || (\
        sf org:login:web -a "$devhub_alias" \
        && sf org:create:scratch -f ./config/project-scratch-def.json -v "$devhub_alias" -a "$scratch_alias" -y "$days"\
    ) || { exit 1; }

sh ./scripts/pkg-deploy.sh "$scratch_alias"
