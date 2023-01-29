# Type Definitions

### Classes:

-   [GraphQLNode](#graphqlnode)
    -   [GraphQLField](#graphqlfield)
    -   [GraphQLFragment](#graphqlfragment)
    -   [GraphQLOperation](#graphqloperation)
        -   [GraphQLQuery](#graphqlquery)
        -   [GraphQLMutation](#graphqlmutation)
        -   [GraphQLSubscription](#graphqlsubscription)
-   [GraphQLArgument](#graphqlargument)
-   [GraphQLVariable](#graphqlvariable)
-   [GraphQLDirective](#graphqldirective)
-   [GraphQLRequest](#graphqlrequest)
-   [GraphQLResponse](#graphqlresponse)
-   [GraphQLResponseError](#graphqlresponseerror)
-   [GraphQLHttpClient](#graphqlhttpclient)

### Enums:

-   [GraphQLArgumentType](#graphqlargumenttype)
-   [GraphQLDirectiveType](#graphqldirectivetype)
-   [GraphQLOperationType](#graphqloperationtype)

### Interfaces:

-   [IGraphQLResponseCallback](#igraphqlresponsecallback)

---

## GraphQLNode

The abstract class that defines the base properties and methods for every GraphQL node (fields, fragments, operations).

### Fields & Properties

`String name` - The name of a node. Can be empty but cannot be `null`.

`List<GraphQLNode> nodes` - The list of child nodes of the current node. Includes fields and inline fragments. The node can either be `GraphQLField` or `GraphQLFragment`.

`List<GraphQLDirective> directives` - The list of node's directives. Read about [`GraphQLDirective` here](#graphqldirective).

### Methods

`Boolean isFieldNode()` - Returns true if the current node is an instance of `GraphQLField`. Otherwise returns false.

`Boolean isFragmentNode()` - Returns true if the current node is an instance of `GraphQLFragment`. Otherwise returns false.

`Boolean hasField(GraphQLField field)` - Returns true if there is a field node with the same name as the one's from the parameter. Otherwise returns false.

`Boolean hasNodes()` - Returns true if there is at least one child node in the current node. Otherwise returns false.

`String build()` - Builds a non-formatted string representation of the current node.

`String build(Boolean pretty)` - Builds a string representation of the current node. The result string can be formatted depending on the provided boolean flag `pretty`.

---

## GraphQLField

Extends `GraphQLNode`. This class can be used for building fields (nodes) for queries, mutations, fragments, etc.

### Constructors

`GraphQLField()` - Creates a new instance of the GraphQLField with an empty name.

`GraphQLField(String name)` - Creates a new instance of the GraphQLField with the provided name.

`GraphQLField(List<GraphQLField> fieldNodes)` - Creates a new instance of the GraphQLField with the provided child nodes and an empty name.

`GraphQLField(List<String> fields)` - Creates a new instance of the GraphQLField with the provided fields and an empty name.

`GraphQLField(String name, List<GraphQLField> fieldNodes)` - Creates a new instance of the GraphQLField with the provided name and child nodes.

`GraphQLField(String name, List<String> fields)` - Creates a new instance of the GraphQLField with the provided name and fields.

### Fields & Properties

`String alias` - Alias of the node. Null by default. You can read about node aliases [here](https://spec.graphql.org/June2018/#sec-Field-Alias).

`Map<String, GraphQLArgument> arguments` - The list of node's arguements mapped by their names.

### Methods

`Boolean hasArguments()` - Returns true if there is at least one argument in the current node. Otherwise returns false.

`GraphQLField byAlias(String alias)` - Adds an alias to the node, so, that the results in the GraphQL response can be accessed by that alias name. You can read about node aliases [here](https://spec.graphql.org/June2018/#sec-Field-Alias).

`GraphQLField withField(String field)` - Adds a new field to the current node. Returns the current node instance.

`GraphQLField withField(GraphQLField node)` - Adds a new child node to the current node. Returns the current node instance.

`GraphQLField withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

`GraphQLField withFields(GraphQLField[] nodes)` - Adds new child nodes to the current node. Returns the current node instance.

`GraphQLField withFragment(String fragmentName)` - Adds a reference to a fragment's fields. Accepts the fragment name.

`GraphQLField withFragments(String[] fragmentNames)` - Adds references to fragments' fields. Accepts the fragments' names.

`GraphQLField withInlineFragment(GraphQLFragment fragment)` - Adds a child fragment node with the set of fields for a particular type.

`GraphQLField withInlineFragments(GraphQLFragment[] fragments)` - Adds child fragment nodes with the set of fields for particular types.

`GraphQLField withArgument(String key, Object value)` - Adds a new argument for the current node. Accepts key and value as parameters. Value can be any type - it will be automatically converted to the appropriate GraphQL type. Returns the current node instance.

`GraphQLField withArgument(GraphQLArgument argument)` - Adds a new argument for the current node. Returns the current node instance.

`GraphQLField withArguments(GraphQLArgument[] arguments)` - Adds new arguments for the current node. Returns the current node instance.

`GraphQLField includeIf(Boolean condition)` - Adds a new `include` directive to the current node. Indicates whether the current node needs to be included in the response. Returns the current node instance.

`GraphQLField includeIf(String variable)` - Adds a new `include` directive to the current node. Accepts one parameter of type String that represents the query variable name (can be passed with or without the `$` sign). Indicates whether the current node needs to be included in the response. Returns the current node instance.

`GraphQLField skipIf(Boolean condition)` - Adds a new `skip` directive to the current node. Indicates whether the current node needs to be skipped in the response. Returns the current node instance.

`GraphQLField skipIf(String variable)` - Adds a new `skip` directive to the current node. Accepts one parameter of type String that represents the query variable name (can be passed with or without the `$` sign). Indicates whether the current node needs to be skipped in the response. Returns the current node instance.

`GraphQLQuery asQuery()` - Wraps the current node and returns a new instance of `GraphQLQuery` with the same node name and child nodes. Arguments and inline fragments are not passing to a new query node since they are not supported for the type `GraphQLQuery`.

`GraphQLMutation asMutation()` - Wraps the current node and returns a new instance of `GraphQLMutation` with the same node name and child nodes. Arguments and inline fragments are not passing to a new mutation node since they are not supported for the type `GraphQLMutation`.

`GraphQLSubscription asSubscription()` - Wraps the current node and returns a new instance of `GraphQLSubscription` with the same node name and child nodes. Arguments and inline fragments are not passing to a new query node since they are not supported for the type `GraphQLSubscription`.

---

## GraphQLFragment

Extends `GraphQLNode`. This class can be used for building fragments to make your queries look more efficient.

### Constructors

`GraphQLFragment()` - Create an instance of an _inline_ fragment not providing the type. Assuming the type is identical to the parent node's type

`GraphQLFragment(String type)` - Create an instance of an _inline_ fragment by the provided type.

`GraphQLFragment(String name, String type)` - Creates a new instance of the fragment definition with the provided name and type it's referring to.

`GraphQLFragment(String name, String type, List<GraphQLField> fieldNodes)` - Creates a new instance of the fragment definition with the provided name, type and its child nodes.

`GraphQLFragment(String name, String type, List<String> fields)` - Creates a new instance of the fragment definition with the provided name, type and fields.

`GraphQLFragment(String name, String type, List<GraphQLField> fieldNodes, List<String> fields)` - Creates a new instance of the fragment definition with the provided name, type, its child nodes and fields.

---

### Fields & Properties

`String type` - The name of the type the fragment describes fields for.

### Methods

`GraphQLFragment withField(String field)` - Adds a new field to the fragment.

`GraphQLFragment withField(GraphQLField node)` - Adds a new child node to the fragment.

`GraphQLFragment withFields(String[] fields)` - Adds new fields to the fragment.

`GraphQLFragment withFields(GraphQLField[] nodes)` - Adds new child nodes to the fragment.

`GraphQLFragment withFragment(String fragmentName)` - Adds a reference to another fragment's fields. Accepts the fragment name.

`GraphQLFragment withFragments(String[] fragmentNames)` - Adds reference to others fragments' fields. Accepts the fragments' names.

`GraphQLFragment withInlineFragment(GraphQLFragment fragment)` - Adds a child fragment node with the set of fields for a particular type.

`GraphQLFragment withInlineFragments(GraphQLFragment[] fragments)` - Adds child fragment nodes with the set of fields for particular types.

`GraphQLFragment includeIf(Boolean condition)` - Adds a new `include` directive to the current fragment. Indicates whether the current fragment needs to be included in the response.

`GraphQLFragment includeIf(String variable)` - Adds a new `include` directive to the current fragment. Accepts one parameter of type String that represents the query variable name (can be passed with or without the `$` sign). Indicates whether the current fragment needs to be included in the response.

`GraphQLFragment skipIf(Boolean condition)` - Adds a new `skip` directive to the current fragment. Indicates whether the current fragment needs to be skipped in the response.

`GraphQLFragment skipIf(String variable)` - Adds a new `skip` directive to the current fragment. Accepts one parameter of type String that represents the query variable name (can be passed with or without the `$` sign). Indicates whether the current fragment needs to be skipped in the response.

---

## GraphQLOperation

Extends `GraphQLNode`. The abstract class representing the GraphQL operation node, eathier Query, Mutation or Subscription.

### Fields & Properties

`List<GraphQLFragment> fragments` - The list of fragment node definitions.

`List<GraphQLVariable> variables` - The list of variable definitions added to the operation.

### Methods

`Boolean hasFragments()` - Returns true if there is at least one fragment definition in the current operation. Otherwise returns false.

`Boolean hasVariables()` - Returns true if there is at least one variable definition in the current operation. Otherwise returns false.

`GraphQLOperationType getOperation()` - Returns the instance of `GraphQLOperationType` for the current node.

`GraphQLRequest asRequest()` - Returns a new instace of type `GraphQLRequest` building it from the current node.

## GraphQLQuery

Extends GraphQLOperation. This class is used for building queries.

### Constructors

`GraphQLQuery()` - Creates a new instance of the GraphQLQuery.

`GraphQLQuery(String alias)` - Creates a new instance of the GraphQLQuery with the provided alias.

`GraphQLQuery(GraphQLField fieldNode)` - Creates a new instance of the GraphQLQuery with the provided child node.

`GraphQLQuery(List<GraphQLField> fieldNodes)` - Creates a new instance of the GraphQLQuery with the provided child nodes.

`GraphQLQuery(List<String> fields)` - Creates a new instance of the GraphQLQuery with the provided fields.

`GraphQLQuery(String alias, List<GraphQLField> fieldNodes)` - Creates a new instance of the GraphQLQuery with the provided alias and child nodes.

`GraphQLQuery(String alias, List<String> fields)` - Creates a new instance of the GraphQLQuery with the provided alias and fields.

### Methods

`GraphQLQuery withField(String field)` - Adds a new field to the current node. Returns the current node instance.

`GraphQLQuery withField(GraphQLField fieldNode)` - Adds a new child node to the current node. Returns the current node instance.

`GraphQLQuery withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

`GraphQLQuery withFields(GraphQLField[] fieldNodes)` - Adds new child nodes to the current node. Returns the current node instance.

`GraphQLQuery defineFragment(GraphQLFragment fragment)` - Defines a fragment for the query.

`GraphQLQuery defineFragments(GraphQLFragment[] fragments)` - Defines multiple fragments for the query.

`GraphQLQuery defineVariable(String name, String typeDefinition)` - Defines a new variable for the query with the name provided as the first parameter (name is specified without a dollar `$` sign). The second parameter contains type definition of the variable as a string.

`GraphQLQuery defineVariable(GraphQLVariable variable)` - Defines a new variable for the query.

---

## GraphQLMutation

Extends GraphQLOperation. This class is used for building mutations.

### Constructors

`GraphQLMutation()` - Creates a new instance of the GraphQLMutation.

`GraphQLMutation(String alias)` - Creates a new instance of the GraphQLMutation with the provided alias.

`GraphQLMutation(GraphQLField fieldNode)` - Creates a new instance of the GraphQLMutation with the provided child node.

`GraphQLMutation(List<GraphQLField> fieldNodes)` - Creates a new instance of the GraphQLMutation with the provided child nodes.

`GraphQLMutation(List<String> fields)` - Creates a new instance of the GraphQLMutation with the provided fields.

`GraphQLMutation(String alias, List<GraphQLField> fieldNodes)` - Creates a new instance of the GraphQLMutation with the provided alias and child nodes.

`GraphQLMutation(String alias, List<String> fields)` - Creates a new instance of the GraphQLMutation with the provided alias and fields.

### Methods

`GraphQLMutation withField(String field)` - Adds a new field to the current node. Returns the current node instance.

`GraphQLMutation withField(GraphQLField fieldNode)` - Adds a new child node to the current node. Returns the current node instance.

`GraphQLMutation withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

`GraphQLMutation withFields(GraphQLField[] fieldNodes)` - Adds new child nodes to the current node. Returns the current node instance.

`GraphQLMutation defineFragment(GraphQLFragment fragment)` - Defines a fragment for the mutation.

`GraphQLMutation defineFragments(GraphQLFragment[] fragments)` - Defines multiple fragments for the mutation.

`GraphQLMutation defineVariable(String name, String typeDefinition)` - Defines a new variable for the mutation with the name provided as the first parameter (name is specified without a dollar `$` sign). The second parameter contains type definition of the variable as a string.

`GraphQLMutation defineVariable(GraphQLVariable variable)` - Defines a new variable for the mutation.

---

## GraphQLSubscription

Extends GraphQLOperation. This class is used for building subscriptions. It's not possible yet to execute subscription requests due to Apex limitations (Apex doesn't support WebSocket protocol). However, you can build your subscription queries as strings and, for example, send it to LWC in order to execute that subscription from Java Script.

### Constructors

`GraphQLSubscription()` - Creates a new instance of the GraphQLSubscription.

`GraphQLSubscription(String alias)` - Creates a new instance of the GraphQLSubscription with the provided alias.

`GraphQLSubscription(GraphQLField fieldNode)` - Creates a new instance of the GraphQLSubscription with the provided child node.

`GraphQLSubscription(List<GraphQLField> fieldNodes)` - Creates a new instance of the GraphQLSubscription with the provided child nodes.

`GraphQLSubscription(List<String> fields)` - Creates a new instance of the GraphQLSubscription with the provided fields.

`GraphQLSubscription(String alias, List<GraphQLField> fieldNodes)` - Creates a new instance of the GraphQLSubscription with the provided alias and child nodes.

`GraphQLSubscription(String alias, List<String> fields)` - Creates a new instance of the GraphQLSubscription with the provided alias and fields.

### Methods

`GraphQLSubscription withField(String field)` - Adds a new field to the current node. Returns the current node instance.

`GraphQLSubscription withField(GraphQLField fieldNode)` - Adds a new child node to the current node. Returns the current node instance.

`GraphQLSubscription withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

`GraphQLSubscription withFields(GraphQLField[] fieldNodes)` - Adds new child nodes to the current node. Returns the current node instance.

`GraphQLSubscription defineFragment(GraphQLFragment fragment)` - Defines a fragment for the subscription.

`GraphQLSubscription defineFragments(GraphQLFragment[] fragments)` - Defines multiple fragments for the subscription.

`GraphQLSubscription defineVariable(String name, String typeDefinition)` - Defines a new variable for the mutation with the name provided as the first parameter (name is specified without a dollar `$` sign). The second parameter contains type definition of the variable as a string.

`GraphQLSubscription defineVariable(GraphQLVariable variable)` - Defines a new variable for the subscription.

---

## GraphQLArgument

This class is used for passing arguments to GraphQL nodes.

### Constructors

`GraphQLArgument(String key, Object value)` - Creates a new instance of the GraphQLArgument with provided key and value. Value type will be automatically identified.

### Fields & Properties

`String key` - Key by which the argument can be identified.

`Object value` - Exact value of the argument. Can be any type.

`GraphQLArgumentType type` - The enum instance with the GraphQL type of the argument. Will be automatically populated after the argument is created.

### Methods

`Boolean isVariable()` - Returns true if the value of the argument references a variable. Otherwise, returns false. The value is considered as a variable if it starts with the dollar `$` sign.

`GraphQLArgument asEnum()` - Represent the current argument as a GraphQL enum value.

---

## GraphQLVariable

This class is used for passing variable definitions to GraphQL operations.

### Constructors

`GraphQLVariable(String name, String type)` - Creates a variable definition by the provided name and type.

### Fields & Properties

`String name` - The variable definition name without the `$` sign.

`String type` - The variable definition type without the `!` sign. If it's non-null type, the `isNonNull` variable should be true.

`Boolean isNonNull` - Flag that shows if the variable value is non-null for the request.

`Object defaultValue` - The variable definition default value.

### Methods

`GraphQLVariable asNonNull()` - Marks the current variable definition as the non-null type.

`GraphQLVariable asNonNull(Boolean isNonNull)` - Marks the current variable definition as the non-null or optional type.

`GraphQLVariable withDefault(Object defaultValue)` - Adds a default value to the variable definition.

`GraphQLVariable asEnum()` - Represents the current variable default value as a GraphQL enum value.

---

## GraphQLDirective

This class is used for passing directives to GraphQL nodes.

### Constructors

`GraphQLDirective(GraphQLDirectiveType type, String ifArgumentValue)` - Creates a new instance of the GraphQLDirective with provided directive type and variable name.

`GraphQLDirective(GraphQLDirectiveType type, Boolean ifArgumentValue)` - Creates a new instance of the GraphQLDirective with provided directive type and if condition.

---

## GraphQLRequest

This is a wrapper for the GraphQL request. It's utilized for sending an HTTP request.

### Constructors

`GraphQLRequest(String stringNode)` - Creates a new instance of the GraphQLRequest using the provided string as a body for the request query. The Operation property of GraphQLRequest is dynamically recognized.

`GraphQLRequest(GraphQLOperation node)` - Creates a new instance of the GraphQLRequest with the provided operation node.

### Fields & Properties

`GraphQLOperationType operation` - The GraphQL operation type.

`Map<String, String> headers` - Map that contains additional headeres that will be passed to an HTTP request.

`Integer timeout` - The request timeout in milliseconds. The default timeout is 120000 ms (2 min).

### Methods

`GraphQLRequest withHeader(String key, String value)` - Adds a new custom header to the request. Returns the current instance.

`GraphQLRequest withHeaders(Map<String, String> headers)` - Adds multiple custom headers to the request. Returns the current instance.

`GraphQLRequest withTimeout(Integer timeout)` - Sets a timeout for the GraphQL request. Returns the current instance.

`GraphQLRequest withVariable(String name, Object value)` - Assigns a value to a variable from query/mutation by its name.

`GraphQLRequest withVariables(Map<String, Object> variables)` - Assigns multiple values to variables from query/mutation by a map with their names as keys.

`override String toString()` - Returns a GraphQL request as a JSON for an HTTP request.

---

## GraphQLResponse

This is a wrapper for the GraphQL response. It will be utilized for receiving errors and data from the GraphQL response.

### Methods

`Boolean hasErrors()` - Returns true if there are any errors in the response. Otherwise, returns false.

`Boolean hasData()` - Returns true if _data_ field is presented in the response. Otherwise, returns false.

`List<GraphQLResponseError> getErrors()` - Returns a list of errors of the `GraphQLResponseError` type. If there are no errors in the response an empty list will be returned.

`Map<String, Object> getData()` - Returns a data field from the response as a Map with generic object as a value.

`Object getDataAs(Type type)` - Returns a data field from the response as an object casted to the type provided in the parameter.

`Object getDataNode(String nodeName)` - Returns a specific data node as a generic object which can be casted to Map<String, Object> or List<Object> depending on what the response node is.

`Object getDataNodeAs(String nodeName, Type type)` - Returns a specific data field's node as an object casted to the type provided in the second parameter.

---

## GraphQLResponseError

This is a wrapper for GraphQL response errors.

### Fields & Properties

`String message` - The error's text message.

`List<Location> locations` - A list of locations of the error. The schema of the Location object is `{line: Int, column: Int}`.

`List<Object> path` - The error's path. Can contain String and Integer values;

`Map<String, Object> extensions` - Extensions for the error. Can contain any object type in it but its type would need to be converted manually.

### Methods

`Object getExtensionsAs(Type type)` - Converts and returns the extensions map as a particular Apex class type provided as a parameter.

---

## GraphQLHttpClient

This class is a GraphQL client that can send GraphQL requests to an endpoint.

### Constructors

`GraphQLHttpClient(String endpoint)` - Creates a new instance of the GraphQLHttpClient with the provided endpoint. This endpoint will be used for all requests executing from that instance.

### Methods

`GraphQLResponse send(GraphQLRequest request)` - Sends a synchronous HTTP request to the GraphQL endpoint.

`Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback)` - Sends an asynchronous HTTP request to the GraphQL endpoint. Runs in a Queuable job. Accepts `GraphQLRequest` as the first parameter and an instance of the `IGraphQLResponseCallback` interface as the second one (can be null). If the callback is provided it will be called right after the response is received. Returns the Id of the enqueued job.

---

## GraphQLArgumentType

This is an enum type representing available GraphQL scalar (and a couple of others the most popular) types.

### Values

`x_Integer` - Default scalar GraphQL Int type.  
`x_Float` - Default scalar GraphQL Float type.  
`x_String` - Default scalar GraphQL String type.  
`x_Boolean` - Default scalar GraphQL Boolean type.  
`x_DateTime` - Scalar GraphQL DateTime type.  
`x_Date` - Scalar GraphQL Date type.  
`x_Null` - Null GraphQL type.  
`x_Enum` - GraphQL enum value type.
`x_Object` - Any other type that needs to be passed to arguments (e.g. any custom type or input).

---

## GraphQLDirectiveType

This is an enum type representing standard GraphQL directives: include and skip.

### Values

`Include` - Defines if we need to include a node (field).  
`Skip` - Defines if we need to NOT include a node (field).

---

## GraphQLOperationType

This enum contains values for all available request operations in GraphQL.

### Values

`Query` - GraphQL query operation.  
`Mutation` - GraphQL mutation operation.  
`Subscription` - GraphQL subscription operation. This node builder is not yet implemented since it's currently impossible to work with WebSockets in Apex.

---

## IGraphQLResponseCallback

This interface represents a callback functionality for asynchronous GraphQL callouts.

`void received(GraphQLResponse response)` - The method that should be called when the asynchronous send call is done and the response is received.

---
