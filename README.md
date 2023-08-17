# Saleforce Apex GraphQL Client

[![CI](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/actions/workflows/scratch-org-ci.yml/badge.svg?branch=main)](https://github.com/IlyaMatsuev/Apex-GraphQL-Client/actions/workflows/scratch-org-ci.yml)
[![codecov](https://codecov.io/gh/IlyaMatsuev/Apex-GraphQL-Client/branch/main/graph/badge.svg?token=ZOSPAKZTGC)](https://codecov.io/gh/IlyaMatsuev/Apex-GraphQL-Client)

The package for Salesforce that aimed to provide a convenient way to communicate with a GraphQL server via Apex.

What is supported:

-   Building queries, mutations and subscriptions
-   Building graphql nodes (fields). If you want to send requests yourself
-   Passing arguments to the graphql nodes (fields)
-   Passing variables to the graphql operations from request
-   Passing directives to the graphql operations and nodes
-   Using fragments for graphql requests. Inline fragments are supported as well.
-   Sync and async graphql HTTP client for sending requests (with callback implementation for async calls)
-   Handling responses in GraphQL format

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
GraphQLField continents = new GraphQLField('continents')
    .withField('name')
    .withField(new GraphQLField(
        'countries',
        new List<String> { 'name', 'capital', 'currency' }
    ));

// Will print a well-formatted node just like on the example above
System.debug(continents.build(true));
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
GraphQLField countries = new GraphQLField(
    'countries',
    new List<String> { 'name', 'capital', 'currency' }
)
    .withArgument('filter', 'Bel')
    .withArgument('count', 1);

GraphQLField continents = new GraphQLField(
    'continents',
    new List<String> { 'name' }
);

GraphQLQuery query = new GraphQLQuery(
    new List<GraphQLField> { countries, continents }
);

System.debug(query.build(true));
```

After you created a query or mutation you can send it to the GraphQL endpoint:

```java
...
GraphQLRequest request = query.asRequest();

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

You can just install the package by the link on a [sandbox](http://test.salesforce.com/packaging/installPackage.apexp?p0=04t5Y000001zNZLQA2) or [dev org](http://login.salesforce.com/packaging/installPackage.apexp?p0=04t5Y000001zNZLQA2).

If you prefer using salesforce CLI you can simply run:

```bash
sfdx force:package:install -p 04t5Y000001zNZLQA2 -w 10 -b 10 -u <username>
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

For more detailed information about the content of the repository and the package, please visit [the documentation page](https://ilyamatsuev.github.io/Apex-GraphQL-Client/).

The changelog is [here](https://ilyamatsuev.github.io/Apex-GraphQL-Client/#/changelog).

## Questions

If you have any questions you can start a discussion. If you think something works not as expected you can create an issue. If you want to request a new feature you can create an issue with the appropriate template selected.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.

## License

[MIT](LICENSE)
