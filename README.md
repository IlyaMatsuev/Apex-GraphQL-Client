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
./scripts/sh/update-org.sh {ORG_ALIAS}
```

If you upload sources to a new scratch org, then run init script with such parameters as scratch alias, dev hub alias, and amount of days the scratch will expire (optional).

```bash
./scripts/sh/init-scratch.sh {SCRATCH_ALIAS} {DEV_HUB_ALIAS} {EXPIRED_IN_DAYS}
```

4. Follow the instructions in the script (if there are)

## Usage

The package can be used for the following:

- Generate string GraphQL nodes, queries, mutations, etc
- Send GraphQL requests with GraphQL HTTP service

... All other stuff is coming soon

### Generate a GraphQL node

What we want:

```bash
continents {
  name
  countries {
    name
    capital
    currency
  }
}
```

How to get it:

```java
GraphQLNode continentsNode = new GraphQLNode('continents')
    .withField('name')
    .withNode(new GraphQLNode(
        'countries',
        new List<String> { 'name', 'capital', 'currency' }
    ));

// Will print a well-formatted node
System.debug(continentsNode.build(true));
```

### Create a query GraphQL request

What we want:

```bash
query {
  countries(filter: "Berlin", count: 1) {
    name
    capital
    currency
  }
  continents {
    name
  }
}
```

How to get it:

```java
GraphQLNode countriesNode = new GraphQLNode(
    'countries',
    new List<String> { 'name', 'capital', 'currency' }
)
    .withArgument('filter', 'Berlin')
    .withArgument('count', 1);

GraphQLNode continentsNode = new GraphQLNode(
    'continents',
    new List<String> { 'name' }
);

GraphQLQueryNode query = new GraphQLQueryNode(
    new List<GraphQLNode> { countriesNode, continentsNode }
);

System.debug(query.build(true));
```

All examples can be found [here](https://github.com/IlyaMatsuev/Sf-GraphQL-Client/blob/main/docs/examples).

## Documentation

The documentation describes all Apex types and usage cases for them. Please see it [here](https://github.com/IlyaMatsuev/Sf-GraphQL-Client/blob/main/docs/documentation/README.md).

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.

## License

[MIT](https://github.com/IlyaMatsuev/Sf-GraphQL-Client/blob/main/LICENSE)
