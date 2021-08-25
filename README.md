# Saleforce Apex GraphQL Client

[![CI](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/actions/workflows/scratch-org-ci.yml/badge.svg?branch=dev)](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/actions/workflows/scratch-org-ci.yml)
[![codecov](https://codecov.io/gh/IlyaMatsuev/Apex-GraphQL-Client/branch/main/graph/badge.svg?token=ZOSPAKZTGC)](https://codecov.io/gh/IlyaMatsuev/Apex-GraphQL-Client)

This is a package for Salesforce that aimed to provide a convenient way to communicate with a GraphQL server via Apex.

### Content:

-   [Installation](#installation)
-   [Usage](#usage)
-   [Documentaiton](#documentation)
-   [Questions](#questions)
-   [Contributing](#contributing)
-   [License](#license)

## Installation

There are a few options for you to deploy/download the project

### Download a package

This project is available as a Salesforce package. So, you can just install it following [the link](http://login.salesforce.com/packaging/installPackage.apexp?p0=04t5Y000001ELb9QAG).

If you prefer using salesforce CLI you can simply run:

```bash
sfdx force:package:install --wait 10 --publishwait 10 --package gql-apex-client@0.0.0-4 --noprompt -u {ORG_ALIAS}
```

### Deploy from source

1. Clone the project

```bash
git clone https://github.com/IlyaMatsuev/Apex-GraphQL-Client.git
```

2. Go to the root project directory

```bash
cd ./apex-graphql-client
```

3. If you want to deploy the project to a dev org or an existing scratch org you should use this:

Windows:

```bash
./scripts/sh/update-org.sh {ORG_ALIAS}
```

MacOS/Linux:

```bash
sh ./scripts/sh/update-org.sh {ORG_ALIAS}
```

If you upload sources to a new scratch org, then run init script with such parameters as scratch alias, dev hub alias, and amount of days the scratch will expire (optional).

Windows:

```bash
./scripts/sh/init-scratch.sh {SCRATCH_ALIAS} {DEV_HUB_ALIAS} {EXPIRED_IN_DAYS}
```

MacOS/Linux:

```bash
sh ./scripts/sh/init-scratch.sh {SCRATCH_ALIAS} {DEV_HUB_ALIAS} {EXPIRED_IN_DAYS}
```

4. Follow the instructions in the script (if there are)

## Usage

The package can be used for the following:

-   Generate string GraphQL nodes, queries, mutations, etc
-   Send GraphQL requests with the GraphQL HTTP client

### Generate a GraphQL node

GraphQL node statement:

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

Equivalent Apex code:

```java
GraphQLNode continentsNode = new GraphQLNode('continents')
    .withField('name')
    .withNode(new GraphQLNode(
        'countries',
        new List<String> { 'name', 'capital', 'currency' }
    ));

// Will print a well-formatted node just like on the example above
System.debug(continentsNode.build(true));
```

### Create a query GraphQL request

GraphQL query statement:

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

Equivalent Apex code:

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

After you created a query or mutation you can send it to the GraphQL endpoint:

```java
...
GraphQLRequest request = query.buildRequest();

// Add custom header if needed
request.withHeader('Authorization', 'Bearer token');

// Provide a GraphQL endpoint to the client
GraphQLHttpClient client = new GraphQLHttpClient('https://gql-endpoint.com/graphql');

GraphQLResponse response = client.send(request);

// Check if there are any errors and data
System.debug(response.hasErrors());
System.debug(response.hasData());

List<GraphQLResponseError> errors = response.getErrors();
Map<String, Object> dataAsMap = response.getData();
// It's also possible to get data as any Apex class type
SomeWrapper dataAsWrapper = (SomeWrapper) response.getDataAs(SomeWrapper.class);
```

Alternatively, sometimes it's easier to just send a request as a plain string, so you can do:

```java
String query = 'query { countries { name, capital, currency } }';

GraphQLRequest request = new GraphQLRequest(query);

// Provide a GraphQL endpoint to the client
GraphQLHttpClient client = new GraphQLHttpClient('https://gql-endpoint.com/graphql');

GraphQLResponse response = client.send(request);

...
```

All examples can be found [here](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/blob/main/docs/examples).

## Documentation

The documentation describes all Apex types and usage cases for them. Please see it [here](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/blob/main/docs).

## Questions

If you have any questions you can start a discussion. If you think something works not as expected you can create an issue. If you want to request a new feature you can create an issue with the appropriate template selected.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.

## License

[MIT](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/blob/main/LICENSE)
