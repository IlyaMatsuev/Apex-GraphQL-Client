# Version 2.1

SFDX package name and version: gql-apex-client@2.1.2.0
Package Id: 04t7R000001dcReQAI

## Breaking changes

### `asEnum()` method is deleted for `GraphQLArgument` and `GraphQLVariable` classes

That was done because these methods are not needed anymore with introduction of the new `GraphQLEnum` class, which can be used for passing enum values into arguments and variable default values.

Example:

```gql
{
    countryByCode(code: CODE_NL) {
        name
    }
}
```

Apex equivalent:

```java
GraphQLField countryByCode = new GraphQLField('countryByCode')
    .withField('name')
    .withArgument('code', new GraphQLEnum('CODE_NL'));

GraphQLQuery query = new GraphQLQuery(countryByCode);
System.debug(query.build(true));
```

# Version 2.0

SFDX package name and version: gql-apex-client@2.0.0
Package Id: 04t5Y000001zNZLQA2

All information regarding the installation and usage is described on the [main repo page](https://github.com/IlyaMatsuev/Apex-GraphQL-Client).

## Breaking changes

### Package classes amd methods naming changes

The names of the below classes have been changed:

Global classes:

-   `GraphQLBaseNode` --> `GraphQLNode`
-   `GraphQLNode` --> `GraphQLField`
-   `GraphQLFragmentNode` --> `GraphQLFragment`
-   `GraphQLOperation` --> `GraphQLOperationType`
-   `GraphQLQueryNode` --> `GraphQLQuery`
-   `GraphQLMutationNode` --> `GraphQLMutation`
-   `GraphQLSubscriptionNode` --> `GraphQLSubscription`

Public classes:

-   `GraphQLNodeParser` --> `GraphQLFieldParser`
-   `GraphQLFragmentNodeParser` --> `GraphQLFragmentParser`
-   `GraphQLOperationNodeParser` --> `GraphQLOperationParser`
-   `GraphQLConfigManager` --> `GraphQLConfigs`
-   `GraphQLConfig` --> `GraphQLConfigs.Option`

Exceptions:

-   `GraphQLBaseNodeException` --> `GraphQLNodeException`
-   `GraphQLOperationNodeException` --> `GraphQLOperationException`
-   `GraphQLConfigManagerException` --> `GraphQLConfigsException`

Tests:

-   `GraphQLNodeTest` --> `GraphQLFieldTest`
-   `GraphQLFragmentNodeTest` --> `GraphQLFragmentTest`
-   `GraphQLQueryNodeTest` --> `GraphQLQueryTest`
-   `GraphQLMutationNodeTest` --> `GraphQLMutationTest`
-   `GraphQLSubscriptionNodeTest` --> `GraphQLSubscriptionTest`
-   `GraphQLConfigManagerTest` --> `GraphQLConfigsTest`

The names of the below methods have been changed:

For `GraphQLNode`:

-   `hasNode(GraphQLField fieldNode)` --> `hasField(GraphQLField fieldNode)`

For `GraphQLField`, `GraphQLFragment`, `GraphQLQuery`, `GraphQLMutation` and `GraphQLSubscription`:

-   `withNode(GraphQLField fieldNode)` --> `withField(GraphQLField fieldNode)`
-   `withNodes(GraphQLField[] fieldNodes)` --> `withFields(GraphQLField[] fieldNodes)`

For `GraphQLQuery`, `GraphQLMutation` and `GraphQLSubscription`:

-   `withFragment(GraphQLFragment fragment)` => `defineFragment(GraphQLFragment fragment)`
-   `withFragments(GraphQLFragment[] fragments)` => `defineFragments(GraphQLFragment[] fragments)`
-   `withVariable(String name, String typeDefinition)` => `defineVariable(String name, String typeDefinition)`

This was made in order to be aligned with the terms (such as "field") provided by the GraphQL specification. And also to make the names shorter for more convenient usage.

Here is an example of how this changes the usage of the package:

Was:

```java
GraphQLNode node = new GraphQLNode('getCities').withArgument('limit', '$limit').withFragment('CityFields');

GraphQLQueryNode query = new GraphQLQueryNode()
  .withNode(node)
  .withFragment(new GraphQLFragmentNode('CityFields', 'City').withField('name'))
  .withVariable('limit', 'Int!');

System.debug(query.build(true));
```

Now:

```java
GraphQLField node = new GraphQLField('getCities').withArgument('limit', '$limit').withFragment('CityFields');

GraphQLQuery query = new GraphQLQuery()
  .withField(node)
  .defineFragment(new GraphQLFragment('CityFields', 'City').withField('name'))
  .defineVariable('limit', 'Int!');

System.debug(query.build(true));
```

### Unnecessary components have been removed

Some of the classes and custom metadata records have been removed because they were not too much useful. Below is the list of deleted components:

GraphQLConfig custom metadata records:

-   `DefaultGraphQLEndpoint` - Wasn't really helpful. The GraphQL endpoint should be defined at the code level, not with the custom metadata.
-   `RequestTimeout` - The timeout for the request can be set with `withTimeout` method on the `GraphQLRequest` class.

Classes:

-   `IGraphQLParser`
-   `IGraphQLClient`
-   `GraphQLDirectiveType`
-   `GraphQLConfig`

## What's new

### Add custom directives to operations and nodes

Previously, it was only possible to add `include` and `skip` directives to the nodes. Now you can add custom directives to the operations, fragments and fields with the help of `GraphQLDirective` class and `withDirective()` method.

Example:

```gql
query @auth(username: "John", password: "Wick") {
    profiles @test {
        name
    }
}
```

Apex equivalent:

```java
GraphQLQuery query = new GraphQLQuery()
  .withDirective(
    new GraphQLDirective('auth')
      .withArgument('username', 'John')
      .withArgument('password', 'Wick')
  )
  .withField(
    new GraphQLField('profiles')
      .withField('name')
      .withDirective(new GraphQLDirective('test'))
  );

System.debug(query.build(true));
```

### A builder for GraphQL variables in the operations

Now, a complex variable for the operation can be defined with the builder-like class called `GraphQLVariable`. It allows you to set up name, type, nullability and default value of the variable.

Example:

```gql
query ($var1: Int! = 1, $var2: SomeType! = { key: "value" }) {
    profiles {
        name
    }
}
```

Apex equivalent:

```java
GraphQLQuery query = new GraphQLQuery()
  .defineVariable(new GraphQLVariable('var1', 'Int!').withDefault(1))
  .defineVariable(
    new GraphQLVariable('var2', 'SomeType')
      .asNonNull()
      .withDefault(new Map<String, Object> { 'key' => 'value' })
  )
  .withField(new GraphQLField('profiles').withField('name'));

System.debug(query.build(true));
```

### Add inline fragments to nodes

There two new methods for `GraphQLField` and `GraphQLFragment` that will allow you to use inline fragments. Read more about inline fragments [here](https://spec.graphql.org/June2018/#sec-Inline-Fragments).

Example:

```gql
query {
    profiles {
        name
        ... on User {
            friends {
                count
            }
        }
        ... on Page {
            likers {
                count
            }
        }
    }
}
```

Apex equivalent:

```java
GraphQLField profiles = new GraphQLField('profiles')
  .withField('name')
  .withInlineFragment(
    new GraphQLFragment('User').withField(
        new GraphQLField('friends').withField('count')
    )
  )
  .withInlineFragment(
    new GraphQLFragment('Page').withField(
        new GraphQLField('likers').withField('count')
    )
  );

GraphQLQuery query = new GraphQLQuery().withField(profiles);

System.debug(query.build(true));
```

Also an example with an inline fragment marked with a directive and without the type specified:

```gql
query ($expandedInfo: Boolean) {
    user {
        name
        ... @include(if: $expandedInfo) {
            firstName
            lastName
        }
    }
}
```

```java
GraphQLField userNode = new GraphQLField('user')
  .withField('name')
  .withInlineFragment(
    new GraphQLFragment()
      .includeIf('expandedInfo')
      .withFields(new List<String> { 'firstName', 'lastName' })
  );

GraphQLQuery query = new GraphQLQuery()
  .withField(userNode)
  .defineVariable('expandedInfo', 'Boolean');

System.debug(query.build(true));
```

### Enum arguments

Now it's possible to define GraphQL enum arguments for GraphQL nodes. To do that, you'll need to create an instance of `GraphQLArgument` and call the `asEnum()` method.

GraphQL query:

```
testNode(newArg: ENUM_VALUE) {
  field1
  field2
}
```

Apex equivalent:

```java
GraphQLField node = new GraphQLField('testNode', new List<String> { 'field1', 'field2' });
node.withArgument(new GraphQLArgument('newArg', 'ENUM_VALUE').asEnum());
System.debug(node.build(true));
```

### Add ApexDoc comments for all global class members

Now, every global class, field, property, method has ApexDoc comments so that it would be easier to use the package from an IDEA.

## What's changed

### Child nodes are now of type `GraphQLNode` instead of `GraphQLField`

Which adds more flexibility as now the `nodes` field also stores inline fragments (`GraphQLFragment`). To determine what child nodes are fields and what are inline fragments there are two new methods:

`isFieldNode()` - True if the instance is `GraphQLField`
`isFragmentNode()` - True if the instance is `GraphQLFragment`

Generally, this change should not affect you as all other method signatures like `withField()` and etc. remain the same.

### Directives are available for both `GraphQLField` and `GraphQLFragment`

Previously, directives have been presented only on `GraphQLField` as a Map with the directive types as a key. Now the directives field is moved to `GraphQLNode`. It's also not a map anymore but just a list of `GraphQLDirective`. Map has been removed just because it wasn't really helpful.

### Refactoring of the `GraphQLRequest` class

-   One of the constructors has been simplified so it accepts only one parameter of `GraphQLOperation` type:

Was:

```java
...
GraphQLRequest request = new GraphQLRequest(GraphQLOperation.Query, query);
```

Now:

```java
...
GraphQLRequest request = new GraphQLRequest(query);
```

-   The `customHeaders` field has been renamed to simply `headers` for the `GraphQLRequest` class. The documentation is updated.

-   Add an opportunity to provide a timeout for the request:

```java
...
GraphQLRequest request = new GraphQLRequest(query);
// Timeout by default: 120000
System.debug(request.timeout);

// Set request timeout in milliseconds
request.withTimeout(10000);

// Get timeout: 10000
System.debug(request.timeout);
```

---

Please, open a discussion or issue if you face any problems with the package. Best regards!

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

## What's new

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

### GraphQLNode and GraphQL(Query/Mutation/Subscription)Node structure

The above classes were refactored:

-   `variables` property now is accessible only from GraphQLQueryNode, GraphQLMutationNode, and GraphQLSubscriptionNode. It's no more accessible from the GraphQLNode type;
-   `arguments` property now is accessible from GraphQLNode type only.

These changes were applied due to logical reasons: arguments can be only applied for nodes (fields) inside the query but not for the query itself; variables can be defined only in the top node like query or mutation but not in the child nodes.

---

Please, open a discussion or issue if you face any problems with the package. Best regards!
