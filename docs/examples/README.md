# Examples

-   [Building a node](#building-a-node)
-   [Sending a query](#sending-a-query)
-   [Sending a mutation](#sending-a-mutation)
-   [Sending a string query](#sending-a-string-query)
-   [Sending an async request](#sending-an-async-request)
-   [Using variables](#using-variables)
-   [Using directives](#using-directives)
-   [Using fragments](#using-fragments)
-   [Using inline fragments](#using-inline-fragments)
-   [Using enums](#using-enums)

## Building a node

Let's say you want to build a GraphQL query like this:

```gql
{
    countries(filter: "Bel") {
        name
        capital {
            id
            name
        }
    }
    cities(limit: 10) {
        name
    }
}
```

To build the `countries` node you would need to:

-   initialize an instance of `GraphQLField` with the node's name in the constructor
-   define an argument. In the example above we are using hardcoded values without variables
-   define all fields of this node. If the field is a node itself, we should simply create a new instance of `GraphQLField` for that node (in our example it is `capital`, with it's own fields `id` and `name`)

```java
GraphQLField countriesNode = new GraphQLField('countries')
    .withArgument('filter', 'Bel')
    .withField('name')
    .withField(new GraphQLField('capital', new List<String> { 'id', 'name' }));
```

Now we need to define the `cities` node from the initial GraphQL query in the same way:

```java
GraphQLField citiesNode = new GraphQLField('cities').withArgument('limit', 10).withField('name');
```

After that we can either wrap our nodes into a Query/Mutation/Subscription or wrap it as another node that can be used as part of any other GraphQL query that you want to do.

-   To wrap it into another node, just create a new instance of `GraphQLField` passing our two nodes as the list:

```java
GraphQLField rootNode = new GraphQLField(new List<GraphQLField> { countriesNode, citiesNode });

// You can check the result output by calling the build() method.
// The boolean parameter determines if the output should be well-formatted or not
System.debug(rootNode.build(true));
```

-   To make a GraphQL query out of these two nodes we should create an instance of `GraphQLQuery` like this:

```java
GraphQLQuery query = new GraphQLQuery(new List<GraphQLField> { countriesNode, citiesNode });
```

---

## Sending a query

From the previous example you should be able to build the Query by creating an instance of `GraphQLQuery`.
After that you can define variables, fragments, or add directives to your query instance. If you do not need any of that (like in the initial example) then you should just create an instance of `GraphQLRequest`:

> `GraphQLRequest` in this case would be an equivalent of `HttpRequest` if you were trying to send the request to a REST endpoint

```java
// "query" here is the instance of `GraphQLQuery`, created before
GraphQLRequest request = new GraphQLRequest(query)
    .withHeader('Authorization', 'Bearer token');
```

If you need to, you can provide any additional HTTP headers, for example `Authorization`.

Next, you will need to connect to your GraphQL server (endpoint) and send the request that you have just prepared:

```java
// Provide GraphQL endpoint to the client constructor
GraphQLHttpClient client = new GraphQLHttpClient('https://your-gql-endpoint-url.com');

// Send the request and receive the response
GraphQLResponse response = client.send(request);
```

> Instead of hardcoding the endpoint and providing Authorization headers manually, you can also use named credentials like this:  
> `GraphQLHttpClient client = new GraphQLHttpClient('callout:MyEndpointConnection');`

The response can be handled multiple ways:

-   get the `data` JSON node as an Apex Map and parse it yourself

```java
Map<String, Object> data = response.getData();
```

-   get the `data` JSON node as an Apex wrapper class created by you

```java
DataWrapper data = (DataWrapper) response.getDataAs(DataWrapper.class);
```

-   get a specific `data` JSON node as an Apex wrapper class created by you

```java
List<Country> countries = (List<Country>) response.getDataNodeAs('countries', List<Country>.class);
```

If you expect to get an error in the response, you can check for errors by using `hasErrors()` and `getErrors()` methods:

```java
if (response.hasErrors()) {
    List<GraphQLResponseError> errors = response.getErrors();
    GraphQLResponseError firstError = errors.get(0);

    System.debug('Error: ' + firstError.message);
    System.debug('Error details: ' + JSON.serializePretty(firstError.extensions));
}
```

---

## Sending a mutation

Sending a mutation with this library is almost the same as sending a query. The only difference is that instead of creating an instance of `GraphQLQuery` you would need to create an instance of `GraphQLMutation`. You might also need to take a look at [how to use variables](#using-variables).

The rest of the steps about sending request and receiving response are the same as in [this example](#sending-a-query) above.

That is it!

---

## Sending a subscription

> :warning: Sending a subscription is not currently supported by this library, That is due to the Apex limitation - Apex does not support WebSockets protocol, which is crutual for GraphQL subscriptions.

It is possible to build subscriptions with this library is almost the same as building a query or a mutation. The only difference is that instead of creating an instance of `GraphQLQuery` you would need to create an instance of `GraphQLSubscription`.

---

## Sending a string query

The simplest way to use this library is to send queries as plain Apex strings. This definitely does not look nice and organized but if your query is simple this can be useful. All you need to do is just define your entire GraphQL query as a string and send it using `GraphQLRequest`:

```java
String query =
    '{' +
    '    countries(filter: "Bel") {' +
    '        name' +
    '        capital { id, name }' +
    '    }' +
    '    cities(limit: 10) { name }' +
    '}';

GraphQLRequest request = new GraphQLRequest(query)
    .withHeader('Authorization', 'Bearer token');
```

The rest of the steps about sending request and receiving response are the same as in [this example](#sending-a-query).

---

## Sending an async request

Sometimes you need an ability to send a request asynchronously, so that you send the request right now but get the result later. There are also use cases when you don't need to handle the response at all, you may just need to send a request and forget about it (e.g. for mutations).

To send an asynchronous request the `GraphQLHttpClient` class contains method `sendAsync()` apart from the regular `send()`.

Let's review two cases:

-   You need to send a mutation asynchronously. You do not care about the result of the mutation, you only care to send it

In this case, you should send your request like this:

```java
// Provide GraphQL endpoint to the client constructor
GraphQLHttpClient client = new GraphQLHttpClient('https://your-gql-endpoint-url.com');

// "request" is the instance of `GraphQLRequest` created by you before. Second parameter is not needed here, so leave it `null`
Id jobId = client.sendAsync(request, null);
```

You get the queuable job id as the return value of the `sendAsync()` method, which you can use to track the job status if needed.

-   You need to send a query/mutation asynchronously. You want to send the request and handle it later, when the job is done and you get your response

In that case, you first need to implement a callback interface needed for handling the response:

```java
public class MyQueryCallback implements IGraphQLResponseCallback {
    public void received(GraphQLResponse response) {
        // Handle response as you need, just like in other examples
        Map<String, Object> data = response.getData();
    }
}
```

The interface `IGraphQLResponseCallback` has only one method `received()` which is basically the handler of your request.

```java
// Provide GraphQL endpoint to the client constructor
GraphQLHttpClient client = new GraphQLHttpClient('https://your-gql-endpoint-url.com');

// "request" is the instance of `GraphQLRequest` created by you before.
// Second parameter is the instance of a class that implements the `IGraphQLResponseCallback` interface
Id jobId = client.sendAsync(request, new MyQueryCallback());
```

Once the request is finished in Queuable job context, the `received()` method of the provided instance will be called, so that you can handle the response.

Handling of the response is the same as in [this example](#sending-a-query).

---

## Using variables

In the first example we built a node with hardcoded arguments. However, it's considered a bad practice because if the value changes you would need to change the query.

> To read more about GraphQL variables take a look at [this specification](https://spec.graphql.org/October2021/#sec-Language.Variables)

Let's change our initial query a little bit with the variable usage:

```gql
query ($filter: String, $limit: Int = 10) {
    countries(filter: $filter) {
        name
        capital {
            id
            name
        }
    }
    cities(limit: $limit) {
        name
    }
}
```

Now instead of hardcoding the actual values in our request we have created two new variables:

-   `filter` - String type
-   `limit` - Integer type with the default value 10

> Default value is used if we don't provide any value to the request when sending it

This is how we used to define our nodes in the initial example without using variables:

```java
GraphQLField countriesNode = new GraphQLField('countries')
    .withArgument('filter', 'Bel')
    .withField('name')
    .withField(new GraphQLField('capital', new List<String> { 'id', 'name' }));

GraphQLField citiesNode = new GraphQLField('cities')
    .withArgument('limit', 10)
    .withField('name');

GraphQLQuery query = new GraphQLQuery(new List<GraphQLField> { countriesNode, citiesNode });
```

This is how should look like if we want to use our two new variables:

```java
GraphQLField countriesNode = new GraphQLField('countries')
    // The first parameter is the name of the argument, the second is the name of the variable we are referencing to
    .withArgument('filter', 'filter')      // <---
    .withField('name')
    .withField(new GraphQLField('capital', new List<String> { 'id', 'name' }));

GraphQLField citiesNode = new GraphQLField('cities')
    .withArgument('limit', 'limit')      // <---
    .withField('name');
```

As you can see, we don't provide any value at this point, we are just saying that our arguments are going to reference the variables from the query. Therefore, the next step is to define the variables on the query:

```java
GraphQLQuery query = new GraphQLQuery(new List<GraphQLField> { countriesNode, citiesNode })
    // Defining our variables. First one has only its type. The second one also has a default value, so we create an instance of `GraphQLVariable`
    .defineVariable('filter', 'String')
    .defineVariable(new GraphQLVariable('limit', 'Int').withDefault(10));
```

We are still not providing any value! That is the point of variables - the actual value is provided only when we make a request, not when we build it. So, when we create a request, we need to specify each variable's value:

```java
GraphQLRequest request = new GraphQLRequest(query)
    .withHeader('Authorization', 'Bearer token')
    // Providing variables values by their names: filter and limit
    .withVariable('filter', 'Fr')
    .withVariable('limit', 5);
```

That is it. After that we can do the same steps we did in [this example](#sending-a-query) to send the request and handle the response.

---

## Using directives

Directives can be used to change the execution behaviour for a field or a query. GraphQL specification has a few standard directives such as `include` or `skip` but also allows to have custom directives defined on the GraphQL server.

> To read more about GraphQL variables take a look at [this specification](https://spec.graphql.org/October2021/#sec-Language.Directives)

To use the standard `include` directive on some field you should use `includeIf` method. Likewise for the `skip` there is the `skipIf` method:

```java
GraphQLField countriesNode = new GraphQLField('countries')
    .withField('name')
    .withField(new GraphQLField('capital', new List<String> { 'id', 'name' }))
    // We can either provide a name of a Boolean variable or just pass an Apex Boolean value. In the first case you would need to add a variable value to the request
    .includeIf('variableName');
```

You can also use your own directive (`@customDirective`) if you need to:

```java
GraphQLField countriesNode = new GraphQLField('countries')
    .withField('name')
    .withField(new GraphQLField('capital', new List<String> { 'id', 'name' }))
    // We can either provide a name of a Boolean variable or just pass an Apex Boolean value. In the first case you would need to add a variable value to the request
    .withDirective(new GraphQLDirective('customDirective'));
```

---

## Using fragments

Fragments can be used in complex queries where some nodes have identical structure. In order to not repeat yourself, the mutual field nodes can be moved into a separate fragment and then attached to the query.

> To read more about GraphQL fragments take a look at [this specification](https://spec.graphql.org/October2021/#sec-Language.Fragments)

Given the following query:

```gql
{
    countries {
        name
        capital {
            id
            name
        }
    }
    cities {
        id
        name
    }
}
```

You can notice that both `capital` and `cities` nodes have the same subset of fields to query: `id` and `name`. Apart from that they also return results for the same type - `City`. Because of that we can take all their mutual fields and put them into a fragment, which can be used by the nodes above:

```gql
{
    countries {
        name
        capital {
            ...CityFields
        }
    }
    cities {
        ...CityFields
    }
}

fragment CityFields on City {
    id
    name
}
```

Firstly, you need to define a fragment using the `GraphQLFragment` class:

```java
// The first constructor parameter is the name of the fragment, the second is the type of the entity we are making a fragment for
GraphQLFragment cityFieldsFragment = new GraphQLFragment('CityFields', 'City')
    .withField('id')
    .withField('name');
```

Next, we define our nodes for the query as we did in the other examples:

```java
GraphQLField countriesNode = new GraphQLField('countries')
    .withField('name')
    .withField(
        new GraphQLField('capital')
            // Use fragment fields for the capital node
            .withFragment(cityFieldsFragment.name)
    );

GraphQLField citiesNode = new GraphQLField('cities')
    // Use fragment fields for the cities node
    .withFragment(cityFieldsFragment.name);
```

This will basically make a reference `...` to the provided fragment name from the query. Now we need to add that fragment to our query:

```java
GraphQLQuery query = new GraphQLQuery(new List<GraphQLField> { countriesNode, citiesNode })
    // Define fragment for the query
    .defineFragment(cityFieldsFragment);
```

That is it, the fragment is added to the query. The rest of the steps about sending request and receiving response are the same as in [this example](#sending-a-query).

---

## Using inline fragments

Inline fragments are similar to the regular ones but they have different purpose. Inline fragments are not added on the query level. They are needed to define a subset of fields for a node depending on the type of the result of this node (e.g. if the node return type is an interface).

> To read more about GraphQL inline fragments take a look at [this specification](https://spec.graphql.org/October2021/#sec-Inline-Fragments)

Example:

```gql
{
    countries {
        name
        capital {
            ... on City {
                id
                name
            }
        }
    }
}
```

The first step is very similar to using the regular fragments - we create an instance of `GraphQLFragment` with the exception that the constructor accepts only one parameter, which is the type of the fragment. Inline fragments don't have names:

```java
GraphQLFragment cityFieldsFragment = new GraphQLFragment('City')
    .withField('id')
    .withField('name');
```

Another difference is that we don't need to include it to the query as for the regular fragments - inline fragments only exist on the node where they are defined. Therefore, we need to define the inline fragment on a node:

```java
GraphQLField countriesNode = new GraphQLField('countries')
    .withField('name')
    .withField(
        new GraphQLField('capital')
            // Use inline fragment fields for the capital node
            .withInlineFragment(cityFieldsFragment)
    );
```

Done! Now you can create a query and send it. The rest of the steps about sending request and receiving response are the same as in [this example](#sending-a-query).

---

## Using enums

To use GraphQL enums in arguments or variables you will need to utilize the `GraphQLEnum` class. It is basically a wrapper around the regular string that tells the parser that this string must not have quotes around when placed as an argument or default value for a variable.

Let's say you want to send a query like this:

```gql
{
    countryByCode(code: CODE_NL) {
        name
    }
}
```

This is how you build it:

```java
GraphQLField countryByCode = new GraphQLField('countryByCode')
    .withField('name')
    .withArgument('code', new GraphQLEnum('CODE_NL'));

GraphQLQuery query = new GraphQLQuery(countryByCode);
```

If you want to have it as a variable, you can build a query as you would usually do and provide a simple string to the request variable value:

```gql
query ($code: CountryCode) {
    countryByCode(code: $code) {
        name
    }
}
```

You would do:

```java
GraphQLField countryByCode = new GraphQLField('countryByCode')
    .withField('name')
    .withArgument('code', 'code');

GraphQLQuery query = new GraphQLQuery(countryByCode)
    .defineVariable('code', 'CountryCode');

GraphQLRequest request = query.asRequest().withVariable('code', 'CODE_NL');   // <-- Here you can simply pass the enum value as a string
```

You can use a simple string value above because when the request is parsed it serializes key-value map into JSON.

On the other hand, if you would have to define a default value for a variable, you would again need to use the `GraphQLEnum` class:

```gql
query ($code: CountryCode = CODE_NL) {
    countryByCode(code: $code) {
        name
    }
}
```

Then during variable definition:

```java
// ...
GraphQLQuery query = new GraphQLQuery(countryByCode)
    .defineVariable(
        new GraphQLVariable('code', 'CountryCode')
            // Providing a default value as enum
            .withDefault(new GraphQLEnum('CODE_NL'))
    );

// Proceed with request creation and assigning a variable value...
```
