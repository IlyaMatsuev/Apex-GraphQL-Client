# Saleforce Apex GraphQL Client

[![CI](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/actions/workflows/scratch-org-ci.yml/badge.svg?branch=main)](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/actions/workflows/scratch-org-ci.yml)
[![codecov](https://codecov.io/gh/IlyaMatsuev/Apex-GraphQL-Client/branch/main/graph/badge.svg?token=ZOSPAKZTGC)](https://codecov.io/gh/IlyaMatsuev/Apex-GraphQL-Client)

The package for Salesforce that aimed to provide a convenient way to communicate with a GraphQL server via Apex.

What is supported:

-   Building particular string nodes (if you want to send requests yourself)
-   Building queries, mutations and subscriptions
-   Passing arguments to the graphql nodes (fields)
-   Passing arguments to the graphql queries and mutations from request
-   Sync and async graphql HTTP service for sending requests (with callback implementation for async calls)
-   Functionality for handling GraphQL responses
-   Using fragments for graphql requests
-   Using `@include` and `@skip` directives for graphql nodes (fields)

What is NOT supported:

-   Sending subscription requests (WebSocket protocol is not supported by Apex)

If you think there is something that is not implemented yet as for GraphQL client I'd appreciate if you open an issue/discussion in this repository.

## Overview

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
  countries(filter: "Bel", count: 1) {
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
    .withArgument('filter', 'Bel')
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

All examples can be found [here](docs/examples/).

## Installation

### From Unmanaged Package

You can just install the package by the link on a [sandbox](http://test.salesforce.com/packaging/installPackage.apexp?p0=04t5Y000001wNU6QAM) or [dev org](http://login.salesforce.com/packaging/installPackage.apexp?p0=04t5Y000001wNU6QAM).

If you prefer using salesforce CLI you can simply run:

```bash
sfdx force:package:install -p 04t5Y000001wNU6QAM -w 10 -b 10 -u <username>
```

### From Source

You can also install the package with the automated scripts: [`pkg-deploy.sh`](scripts/pkg-deploy.sh) and [`pkg-from-scratch.sh`](scripts/pkg-from-scratch.sh). First is for deploying changes to the existing org:

```bash
./scripts/pkg-deploy.sh <username>
```

Second is for creating a new configured scratch org:

```bash
./scripts/pkg-from-scratch.sh <devhub_username> <scratch_username>
```

## Documentation

The documentation describes all Apex types and usage cases for them. Please see it [here](docs).

## Questions

If you have any questions you can start a discussion. If you think something works not as expected you can create an issue. If you want to request a new feature you can create an issue with the appropriate template selected.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.

## License

[MIT](LICENSE)
