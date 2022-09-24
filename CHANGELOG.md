# Version 1.4

SFDX package name and version: gql-apex-client@1.4.0-0
Package Id: 04t5Y000001wNVYQA2

All information regarding the installation and usage is described on the [main repo page](https://github.com/IlyaMatsuev/Apex-GraphQL-Client).

## What's changed

### Variable reference from nested object arguments

Earlier it was not possible to reference a variable from the nested arguemnt object. So, the code like this:

```java
GraphQLNode node = new GraphQLNode('test')
    .withArgument('arg', new Map<String, Object> { 'key1' => '$ref', 'key2' => 'some string' })l;
System.debug(node.build(true));
```

Would print this:

```gql
test (arg:{key2:"some string",key1:"$ref"})
```

Now, it's possible to reference variables, so the same code would print you this:

```gql
test (arg: { key2: "some string", key1: $ref })
```

The `pretty` parameter in the `build()` method now works for argument objects as well.

---

Please, open a discussion or issue if you face any problems with the package. Best regards!

# Version 1.3

SFDX package name and version: gql-apex-client@1.3.0-0
Package Id: 04t5Y000001wNU6QAM

All information regarding the installation and usage is described on the [main repo page](https://github.com/IlyaMatsuev/Apex-GraphQL-Client).

This release does not contain any new features. However, some components have been renamed or removed

## What's changed

-   Remove the `HttpConstants` class (Since the name is quite generic and the package is not managed, this class can potentially lead to conflicts when installing the package)
-   Rename the `CommonConstants` class to `GraphQLConstants` (Same reason as for the `HttpConstants` class)
-   Remove CustomLabels (To reduce the number of package components, the custom labels didn't have a lot of sense in the scope of this package)
-   Remove static resources (To reduce the number of package components, static resources were only used for mocks in the test classes)
-   Rename `GraphQLNodeBase` to `GraphQLBaseNode` (Sounds more appropriate)
-   Rename `GraphQLConfiguration__mdt `to `GraphQLConfig__mdt` and `ConfigurationValue__c` to `Value__c` (Easier and shorter to reference in code)

---

Please, open a discussion or issue if you face any problems with the package. Best regards!

# Version 1.2

SFDX package name and version: gql-apex-client@1.2.0-0
Package Id: 04t5Y000001wLvEQAU

All information regarding the installation and usage is described on the [main repo page](https://github.com/IlyaMatsuev/Apex-GraphQL-Client).

## What's changed

### Null arguments

Now it's possible to define `null` arguments for GraphQL nodes.

GraphQL:

```
testNode(newArg: null) {
  field1
  field2
}
```

Apex equivalent:

```java
GraphQLNode node = new GraphQLNode('testNode', new List<String> { 'field1', 'field2' });
node.withArgument('newArg', null);
System.debug(node.build(true));
```

# #What's new

### Support for standard GraphQL directives

Now you can mark your nodes with the standard `@include` and `@skip` directives to indicate whether you want to include or skip a node it's applied for. The example for `@include` directive below:

```
query ($withNode: Boolean!) {
  testNode @include(if: $withNode) {
    field1
    field2
  }
}
```

Apex equivalent:

```java
GraphQLQueryNode query = new GraphQLQueryNode(
  new GraphQLNode('testNode', new List<String> { 'field1', 'field2' })
    // Provide the variable name that we want this directive to refer to
    .includeIf('withNode')
    // You can use skipIf() as well
    //.skipIf('withoutNode')
).withVariable('withNode', 'Boolean!');
System.debug(query.build(true));

// Then you can assign the variable name from GraphQLRequest

```

[How to use directives in GraphQL?](https://spec.graphql.org/June2018/#sec-Language.Directives)

---

Please, open a discussion or issue if you face any problems with the package. Best regards!

# Version 1.1

SFDX package name and version: gql-apex-client@1.1.0-1
Package Id: 04t5Y000001ELhrQAG

All information regarding the installation and usage is described on the [main repo page](https://github.com/IlyaMatsuev/Apex-GraphQL-Client).

## What's changed

### Extensions in GraphQL errors

GraphQL errors now can contain extensions not only as Strings but as any objects. The same refers to the path field - now path can have strings and numbers. Also, a new method was added for simplifying working with the extensions in the errors:

```java

...
List<GraphQLResponseError> errors = response.getErrors();
GraphQLResponseError firstError = errors.get(0);

ErrorExtensionsWrapper extensions = (ErrorExtensionsWrapper) firstError
           // Read extensions as the ErrorExtensionsWrapper class
            .getExtensionsAs(ErrorExtensionsWrapper.class);
...

```

### Refactoring of the GraphQL parsing architecture

The GraphQL parsing strategy has been changed and it's not allowed now to create your own general parser implementation.
Now, there is a separate parser for every node type. So, the "_GraphQL Node Parser_" configuration metadata has been deleted.

---

Please, open a discussion or issue if you face any problems with the package. Best regards!

# Version 1.0

SFDX package name and version: gql-apex-client@1.0.0-1
Package Id: 04t5Y000001ELgFQAW

All information regarding the installation and usage is described on the [main repo page](https://github.com/IlyaMatsuev/Apex-GraphQL-Client).

## What's new

### Support for nodes aliases

Now you can mark your nodes (fields) with aliases, so, in the response, you'll receive the data from the server by the name you want.

```java
GraphQLNode countriesNode = new GraphQLNode('countries', new List<String> { 'id', 'name' })
    // Mark with alias
    .byAlias('allCountries');

GraphQLQueryNode query = new GraphQLQueryNode(countriesNode);

System.debug(query.build(true));
/*
query {
  allCountries: countries {
    id
    name
  }
}
*/
```

[How to use node aliases in GraphQL?](https://spec.graphql.org/June2018/#sec-Field-Alias)

---

### Simple string requests

Sometimes it's better to send a request just from the string without a need to build instances of GraphQLNode or GraphQLQueryNode etc. So, that's how it can be done

```java
String query = 'query { countries { name, capital, currency } }';

GraphQLRequest request = new GraphQLRequest(query);

GraphQLHttpClient client = new GraphQLHttpClient('https://gql-endpoint.test');

// Do with the response whatever you need
GraphQLResponse response = client.send(request);
```

---

### Support for GraphQL fragments

Now you can use fragments for your queries/mutations to make your GraphQL request structure look better.

```java
// Create fragment instance passing its name and type it's referring to
GraphQLFragmentNode cityFieldsFragment = new GraphQLFragmentNode('CityFields', 'City')
    .withField('id')
    .withField('name');

GraphQLNode citiesNode = new GraphQLNode('cities')
    // Use fragment fields for the "cities" node
    .withFragment(cityFieldsFragment.name);

GraphQLQueryNode query = new GraphQLQueryNode(citiesNode)
    // Define fragment for the query
    .withFragment(cityFieldsFragment);

System.debug(query.build(true));
/*
query {
  cities {
    ...CityFields
  }
}
fragment CityFields on City {
    id
    name
}
*/
```

[How to use fragments in GraphQL?](https://spec.graphql.org/June2018/#sec-Language.Fragments)

---

## What's changed

### GraphQLNode and GraphQL(Query/Mutation/Subscription)Node structure

The above classes were refactored:

-   `variables` property now is accessible only from GraphQLQueryNode, GraphQLMutationNode, and GraphQLSubscriptionNode. It's no more accessible from the GraphQLNode type;
-   `arguments` property now is accessible from GraphQLNode type only.

These changes were applied due to logical reasons: arguments can be only applied for nodes (fields) inside the query but not for the query itself; variables can be defined only in the top node like query or mutation but not in the child nodes.

---

Please, open a discussion or issue if you face any problems with the package. Best regards!

# Version 0.0

SFDX package name and version: gql-apex-client@0.0.0-4
Package Id: 04t5Y000001ELb9QAG

All information regarding the installation and usage is described on the [main repo page](https://github.com/IlyaMatsuev/Apex-GraphQL-Client).
