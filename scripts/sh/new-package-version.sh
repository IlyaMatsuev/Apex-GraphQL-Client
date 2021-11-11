default_devhub_alias=gql-client-devhub

devhub_alias=${1:-$default_devhub_alias}
package_name=$2

# Create a new package version
sfdx force:package:version:create -p gql-apex-client -d ./src --wait 10 -v "$devhub_alias" -x -c

# Promote the new version
sfdx force:package:version:promote -p "$package_name" -v "$devhub_alias"
