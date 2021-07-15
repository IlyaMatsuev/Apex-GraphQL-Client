# Saleforce GraphQL Client

This is a package for Salesforce which aimed to provide a convenient way for communicating with a GraphQL server via Apex.

### Content:

- [Installation](#installation)
- [Usage](#usage)
- [Documentaiton](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Installation

There are a few options for you to deploy/download the project

### Download a package

This project is available as a Salesforce package. So, you can just install it following [the link](/packaging/installPackage.apexp?p0=<package_id>).

If you prefer using salesforce CLI you can simply run:

```bash
sfdx force:package:install --wait 10 --publishwait 10 --package <package_id> --noprompt -u {ORG_ALIAS}
```

### Deploy from source

1. Clone the project

```bash
git clone https://github.com/IlyaMatsuev/Sf-GraphQL-Client.git
```

2. Go to the root project directory

```bash
cd ./sf-graphql-client
```

3. If you want to deploy the project to a dev org or an existing scratch org you should use this:

```bash
./scripts/sh/update-org.sh <ORG_ALIAS>
```

If you upload sources to a new scratch org, then run init script with such parameters as scratch alias, dev hub alias and amount of days the scratch will expire (optional).

```bash
./scripts/sh/init-scratch.sh {SCRATCH_ALIAS} {DEV_HUB_ALIAS} {EXPIRED_IN_DAYS}
```

4. Follow the instructions in script (if there are)

## Usage

The package can be used for the following:

- Generate string GraphQL nodes, queries, mutations, etc
- Send GraphQL requests with pre-build GraphQL serice

... All other stuff is coming soon

## Documentation

The documentation describes all Apex types and usage cases for them. Please see it [here]().

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.

## License

[MIT](https://github.com/IlyaMatsuev/Sf-GraphQL-Client/blob/main/LICENSE)
