# Type Definitions

This unit describes the Apex classes of the package that can be used for working with GraphQL API.

### Classes:

-   [GraphQLNode](#graphqlnode)
-   [GraphQLQueryNode](#graphqlquerynode)
-   [GraphQLMutationNode](#graphqlmutationnode)
-   [GraphQLSubscriptionNode](#graphqlsubscriptionnode)
-   [GraphQLArgument](#graphqlargument)
-   [GraphQLRequest](#graphqlrequest)
-   [GraphQLResponse](#graphqlresponse)
-   [GraphQLResponseError](#graphqlresponseerror)
-   [GraphQLHttpClient](#graphqlhttpclient)

### Enums:

-   [GraphQLArgumentType](#graphqlargumenttype)
-   [GraphQLOperation](#graphqloperation)

### Interfaces:

-   [IGraphQLNodeParser](#igraphqlnodeparser)
-   [IGraphQLClient](#igraphqlclient)
-   [IGraphQLResponseCallback](#igraphqlresponsecallback)

---

## GraphQLNode

This class can be used for building nodes (method calls) for queries, mutations, fragments, etc.

### Constructors

`GraphQLNode()` - Creates a new instance of the GraphQLNode with an empty name.

`GraphQLNode(String name)` - Creates a new instance of the GraphQLNode with the provided name.

`GraphQLNode(List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLNode with the provided child nodes and an empty name.

`GraphQLNode(List<String> fields)` - Creates a new instance of the GraphQLNode with the provided fields and an empty name.

`GraphQLNode(String name, List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLNode with the provided name and child nodes.

`GraphQLNode(String name, List<String> fields)` - Creates a new instance of the GraphQLNode with the provided name and fields.

---

### Properties

`String name` - The name of a node. It can be empty but in that case, when you build the node you'll get an output like:

`{ ... }`

So, basically, in that case, this node can be used for a query request but the better recommendation would be to utilize [`GraphQLQueryNode`](#graphqlquerynode) for that purpose.

`List<GraphQLNode> nodes` - The list of child nodes (or fields) of the current node. If a node has no child nodes it'll be built as a field. Therefore, this property is optional.

`Map<String, GraphQLArgument> arguments` - The list of node's arguements mapped by their names. Read about [`GraphQLArgument` here](#graphqlargument). Arguments are optional.

---

### Methods

`Boolean hasNode(GraphQLNode node)` - Returns true if there is a node with the same name from the parameter. Otherwise returns false.

`Boolean hasNodes(GraphQLNode[] nodes)` - Returns true if there is at least one node from the provided array. Otherwise returns false.

`Boolean hasNodes()` - Returns true if there is at least one child node in the current node. Otherwise returns false.

`Boolean hasArguments()` - Returns true if there is at least one argument in the current node. Otherwise returns false.

`GraphQLNode byAlias(String alias)` - Adds an alias to the node, so, that the results in the GraphQL response can be accessed by that alias name. You can read about node aliases [here](https://spec.graphql.org/June2018/#sec-Field-Alias).

`GraphQLNode withField(String field)` - Adds a new field to the current node. Returns the current node instance.

`GraphQLNode withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

`GraphQLNode withNode(GraphQLNode node)` - Adds a new child node to the current node. Accepts one parameter of type [`GraphQLNode`](#graphqlnode). Returns the current node instance.

`GraphQLNode withNodes(GraphQLNode[] nodes)` - Adds new child nodes to the current node. Accepts one parameter of type [`GraphQLNode[]`](#graphqlnode) (list can also be implicitly converted to the array). Returns the current node instance.

`GraphQLNode withArgument(String key, Object value)` - Adds a new argument for the current node. Accepts key and value as parameters. Value can be any type - it will be automatically converted to the appropriate GraphQL type. Returns the current node instance.

`GraphQLNode withArgument(GraphQLArgument argument)` - Adds a new argument for the current node. Accepts one parameter of type [`GraphQLArgument`](#graphqlargument). Returns the current node instance.

`GraphQLNode withArguments(GraphQLArgument[] arguments)` - Adds new arguments for the current node. Accepts one parameter of type [`GraphQLArgument[]`](#graphqlargument) (list can also be implicitly converted to the array). Returns the current node instance.

`String build()` - Builds a non-formatted string representation of the current node.

`String build(Boolean pretty)` - Builds a string representation of the current node. The result string can be formatted depending on the provided boolean flag `pretty`.

`GraphQLQueryNode asQuery()` - Wraps the current node and returns a new instance of [`GraphQLQueryNode`](#graphqlquerynode) with the same node name and child nodes. Arguments are not passing to a new query node since they are not supported for the type [`GraphQLQueryNode`](#graphqlquerynode).

`GraphQLMutationNode asMutation()` - Wraps the current node and returns a new instance of [`GraphQLMutationNode`](#graphqlmutationnode) with the same node name and child nodes. Arguments are not passing to a new mutation node since they are not supported for the type [`GraphQLMutationNode`](#graphqlmutationnode).

`GraphQLSubscriptionNode asSubscription()` - Wraps the current node and returns a new instance of [`GraphQLSubscriptionNode`](#graphqlsubscriptionnode) with the same node name and child nodes. Arguments are not passing to a new query node since they are not supported for the type [`GraphQLSubscriptionNode`](#graphqlsubscriptionnode).

---

## GraphQLQueryNode

This class is only used for building queries.

### Constructors

`GraphQLQueryNode()` - Creates a new instance of the GraphQLQueryNode.

`GraphQLQueryNode(String alias)` - Creates a new instance of the GraphQLQueryNode with the provided alias.

`GraphQLQueryNode(GraphQLNode node)` - Creates a new instance of the GraphQLQueryNode with the provided child node.

`GraphQLQueryNode(List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLQueryNode with the provided child nodes.

`GraphQLQueryNode(List<String> fields)` - Creates a new instance of the GraphQLQueryNode with the provided fields.

`GraphQLQueryNode(String alias, List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLQueryNode with the provided alias and child nodes.

`GraphQLQueryNode(String alias, List<String> fields)` - Creates a new instance of the GraphQLQueryNode with the provided alias and fields.

---

### Properties

GraphQLQueryNode has the same properties as the [`GraphQLNode`](#graphqlnode) class.

`Map<String, String> variables` - Variable names mapped to their type definitions. E.g. `(varName: Int! = 1)`.

---

### Methods

`Boolean hasNode(GraphQLNode node)` - Returns true if there is a node with the same name from the parameter. Otherwise returns false.

`Boolean hasNodes(GraphQLNode[] nodes)` - Returns true if there is at least one node from the provided array. Otherwise returns false.

`Boolean hasNodes()` - Returns true if there is at least one child node in the current node. Otherwise returns false.

`Boolean hasArguments()` - Returns true if there is at least one argument in the current node. Otherwise returns false.

`GraphQLQueryNode withField(String field)` - Adds a new field to the current node. Returns the current node instance.

`GraphQLQueryNode withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

`GraphQLQueryNode withNode(GraphQLNode node)` - Adds a new child node to the current node. Accepts one parameter of type [`GraphQLNode`](#graphqlnode). Returns the current node instance.

`GraphQLQueryNode withNodes(GraphQLNode[] nodes)` - Adds new child nodes to the current node. Accepts one parameter of type [`GraphQLNode[]`](#graphqlnode) (list can also be implicitly converted to the array). Returns the current node instance.

`GraphQLQueryNode withVariable(String name, String typeDefinition)` - Defines a new variable for the query with the name provided as the first parameter (name is specified without a dollar `$` sign). The second parameter contains type definition of the variable as a string.

`GraphQLRequest buildRequest()` - Returns a new instace of type [`GraphQLRequest`](#graphqlrequest) building it from the current node.

`String build()` - Builds a non-formatted string representation of the current node.

`String build(Boolean pretty)` - Builds a string representation of the current node. The result string can be formatted depending on the provided boolean flag `pretty`.

---

## GraphQLMutationNode

This class is only used for building mutations.

### Constructors

`GraphQLMutationNode()` - Creates a new instance of the GraphQLMutationNode.

`GraphQLMutationNode(String alias)` - Creates a new instance of the GraphQLMutationNode with the provided alias.

`GraphQLMutationNode(GraphQLNode node)` - Creates a new instance of the GraphQLMutationNode with the provided child node.

`GraphQLMutationNode(List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLMutationNode with the provided child nodes.

`GraphQLMutationNode(List<String> fields)` - Creates a new instance of the GraphQLMutationNode with the provided fields.

`GraphQLMutationNode(String alias, List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLMutationNode with the provided alias and child nodes.

`GraphQLMutationNode(String alias, List<String> fields)` - Creates a new instance of the GraphQLMutationNode with the provided alias and fields.

---

### Properties

GraphQLMutationNode has the same properties as the [`GraphQLNode`](#graphqlnode) class.

`Map<String, String> variables` - Variable names mapped to their type definitions. E.g. `(varName: Int! = 1)`.

---

### Methods

`Boolean hasNode(GraphQLNode node)` - Returns true if there is a node with the same name from the parameter. Otherwise returns false.

`Boolean hasNodes(GraphQLNode[] nodes)` - Returns true if there is at least one node from the provided array. Otherwise returns false.

`Boolean hasNodes()` - Returns true if there is at least one child node in the current node. Otherwise returns false.

`Boolean hasArguments()` - Returns true if there is at least one argument in the current node. Otherwise returns false.

`GraphQLMutationNode withField(String field)` - Adds a new field to the current node. Returns the current node instance.

`GraphQLMutationNode withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

`GraphQLMutationNode withNode(GraphQLNode node)` - Adds a new child node to the current node. Accepts one parameter of type [`GraphQLNode`](#graphqlnode). Returns the current node instance.

`GraphQLMutationNode withNodes(GraphQLNode[] nodes)` - Adds new child nodes to the current node. Accepts one parameter of type [`GraphQLNode[]`](#graphqlnode) (list can also be implicitly converted to the array). Returns the current node instance.

`GraphQLMutationNode withVariable(String name, String typeDefinition)` - Defines a new variable for the mutation with the name provided as the first parameter (name is specified without a dollar `$` sign). The second parameter contains type definition of the variable as a string.

`GraphQLRequest buildRequest()` - Returns a new instace of type [`GraphQLRequest`](#graphqlrequest) building it from the current node.

`String build()` - Builds a non-formatted string representation of the current node.

`String build(Boolean pretty)` - Builds a string representation of the current node. The result string can be formatted depending on the provided boolean flag `pretty`.

---

## GraphQLSubscriptionNode

This class is only used for building subscriptions. It's not possible yet to execute subscription requests due to Apex limitations (Apex doesn't support WebSocket protocol). However, you can build your subscription queries as strings and, for example, send it to LWC in order to execute that subscription from Java Script.

### Constructors

`GraphQLSubscriptionNode()` - Creates a new instance of the GraphQLSubscriptionNode.

`GraphQLSubscriptionNode(String alias)` - Creates a new instance of the GraphQLSubscriptionNode with the provided alias.

`GraphQLSubscriptionNode(GraphQLNode node)` - Creates a new instance of the GraphQLSubscriptionNode with the provided child node.

`GraphQLSubscriptionNode(List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLSubscriptionNode with the provided child nodes.

`GraphQLSubscriptionNode(List<String> fields)` - Creates a new instance of the GraphQLSubscriptionNode with the provided fields.

`GraphQLSubscriptionNode(String alias, List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLSubscriptionNode with the provided alias and child nodes.

`GraphQLSubscriptionNode(String alias, List<String> fields)` - Creates a new instance of the GraphQLSubscriptionNode with the provided alias and fields.

---

### Properties

GraphQLSubscriptionNode has the same properties as the [`GraphQLNode`](#graphqlnode) class.

`Map<String, String> variables` - Variable names mapped to their type definitions. E.g. `(varName: Int! = 1)`.

---

### Methods

`Boolean hasNode(GraphQLNode node)` - Returns true if there is a node with the same name from the parameter. Otherwise returns false.

`Boolean hasNodes(GraphQLNode[] nodes)` - Returns true if there is at least one node from the provided array. Otherwise returns false.

`Boolean hasNodes()` - Returns true if there is at least one child node in the current node. Otherwise returns false.

`Boolean hasArguments()` - Returns true if there is at least one argument in the current node. Otherwise returns false.

`GraphQLSubscriptionNode withField(String field)` - Adds a new field to the current node. Returns the current node instance.

`GraphQLSubscriptionNode withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

`GraphQLSubscriptionNode withNode(GraphQLNode node)` - Adds a new child node to the current node. Accepts one parameter of type [`GraphQLNode`](#graphqlnode). Returns the current node instance.

`GraphQLSubscriptionNode withNodes(GraphQLNode[] nodes)` - Adds new child nodes to the current node. Accepts one parameter of type [`GraphQLNode[]`](#graphqlnode) (list can also be implicitly converted to the array). Returns the current node instance.

`GraphQLSubscriptionNode withVariable(String name, String typeDefinition)` - Defines a new variable for the mutation with the name provided as the first parameter (name is specified without a dollar `$` sign). The second parameter contains type definition of the variable as a string.

`String build()` - Builds a non-formatted string representation of the current node.

`String build(Boolean pretty)` - Builds a string representation of the current node. The result string can be formatted depending on the provided boolean flag `pretty`.

---

## GraphQLArgument

This class is used for passing arguments to GraphQL nodes.

### Constructors

`GraphQLArgument(String key, Object value)` - Creates a new instance of the GraphQLArgument with provided key and value. Value type will be automatically identified.

---

### Properties

`String key` - Key by which the argument can be identified.

`Object value` - Exact value of the argument. Can be any type.

`GraphQLArgumentType type` - The enum instance with the GraphQL type of the argument. Will be automatically populated after the argument is created.

---

### Methods

`override String toString()` - Returns a string equivalent of the argument according to its value's type. For example, if the value is an instance of a class it will be serialized with JSON.

`Boolean isVariable()` - Returns true if the value of the argument references a variable. Otherwise, returns false. The value is considered as a variable if it starts with the dollar `$` sign.

---

## GraphQLRequest

This is a wrapper for the GraphQL request. It will be utilized for sending an HTTP request.

### Constructors

`GraphQLRequest(GraphQLNodeBase root)` - Creates a new instance of the GraphQLRequest with the provided root node and sets its operation as Query. `GraphQLNodeBase` is the base implementation for nodes functionality. It's required from `root` to be an instance of GraphQLQueryNode or GraphQLMutationNode. Otherwise, an exception will be thrown.

`GraphQLRequest(GraphQLOperation operation, GraphQLNodeBase root)` - Creates a new instance of the GraphQLRequest with the provided operation and root node.

---

### Properties

`GraphQLOperation operation` - The GraphQL operation type. Read about the [`GraphQLOperation` enum here](#graphqloperation).

`Map<String, String> customHeaders` - Map that contains additional headeres that will be passed to an HTTP request.

---

### Methods

`GraphQLRequest withHeader(String key, String value)` - Adds a new custom header to the request. Returns the current instance.

`GraphQLRequest withHeaders(Map<String, String> headers)` - Adds multiple custom headers to the request. Returns the current instance.

`GraphQLRequest withVariable(String name, Object value)` - Assigns a value to a variable from query/mutation by its name.

`GraphQLRequest withVariables(Map<String, Object> variables)` - Assigns multiple values to variables from query/mutation by a map with their names as keys.

`override String toString()` - Returns a GraphQL request as a JSON for an HTTP request.

---

## GraphQLResponse

This is a wrapper for the GraphQL response. It will be utilized for receiving errors and data from the GraphQL response.

### Methods

`Boolean hasErrors()` - Returns true if there are any errors in the response. Otherwise, returns false.

`Boolean hasData()` - Returns true if _data_ field is presented in the response. Otherwise, returns false.

`List<GraphQLResponseError> getErrors()` - Returns a list of errors of the [`GraphQLResponseError`](#graphqlresponseerror) type. If there are no errors in the response an empty list will be returned.

`Map<String, Object> getData()` - Returns a data field from the response as a Map with generic object as a value.

`Object getDataAs(Type type)` - Returns a data field from the response as an object casted to the type provided in the parameter.

`Object getDataNode(String nodeName)` - Returns a specific data node as a generic object which can be casted to Map<String, Object> or List<Object> depending on what the response node is.

`Object getDataNodeAs(String nodeName, Type type)` - Returns a specific data field's node as an object casted to the type provided in the second parameter.

---

## GraphQLResponseError

This is a wrapper for GraphQL response errors.

### Properties

`String message` - The error's text message.
`List<Location> locations` - A list of locations of the error. The schema of the Location object is `{line: Int, column: Int}`.
`List<String> path` - The error's path. For now this field accepts strings only.
`Map<String, String> extensions` - Extensions for the error. In GraphQL specification this field can contain a map with values of any type but due to Apex limitations This field accepts strings only yet.

---

## GraphQLHttpClient

This class is a GraphQL client that can send GraphQL requests to an endpoint.

### Constructors

`GraphQLHttpClient(String endpoint)` - Creates a new instance of the GraphQLHttpClient with the provided endpoint. This endpoint will be used for all requests executing from that instance.

---

### Methods

`GraphQLResponse send(GraphQLRequest request)` - Sends a synchronous HTTP request to the GraphQL endpoint. Accepts [`GraphQLRequest`](#graphqlrequest) as the parameter. Returns an instance of the [`GraphQLResponse`](#graphqlresponse).

`Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback)` - Sends an asynchronous HTTP request to the GraphQL endpoint. Runs in a Queuable job. Accepts [`GraphQLRequest`](#graphqlrequest) as the first parameter and an instance of the [`IGraphQLResponseCallback`](#igraphqlresponsecallback) interface as the second one (can be null). If the callback is provided it will be called right after the response is received. Returns the Id of the enqueued job.

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
`x_Object` - Any other type that needs to be passed to arguments (e.g. any custom type or input).

---

## GraphQLOperation

This enum contains values for all available request operations in GraphQL.

### Values

`Query` - GraphQL query operation.  
`Mutation` - GraphQL mutation operation.  
`Subscription` - GraphQL subscription operation. This node builder is not yet implemented since it's currently impossible to work with WebSockets in Apex.

---

## IGraphQLNodeParser

This interface is needed for parsing a GraphQL node to the string (well formatted or not). For now, it's not allowed to inject your own implementation of the IGraphQLNodeParser but this should be possible in prospective.

`String toString(GraphQLNodeBase node, Boolean pretty)` - Returns a string parsing the provided node. If `pretty` is true the string should be well-formatted.

---

## IGraphQLClient

This interface is needed for providing a GraphQL client to be able to send GraphQL requests and receive response from the GraphQL endpoint.

`GraphQLResponse send(GraphQLRequest request)` - Sends the [`GraphQLRequest`](#graphqlrequest) instance provided as the parameter to a GraphQL endpoint. Returns [`GraphQLResponse`](#graphqlresponse) instance.

`Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback)` - Sends the [`GraphQLRequest`](#graphqlrequest) instance provided as the first parameter to a GraphQL endpoint asynchronously. Accepts an [`IGraphQLResponseCallback`](#igraphqlresponsecallback) instance as the second parameter. Should call the callback when the response is received. Returns an Id of the asynchronous job.

---

## IGraphQLResponseCallback

This interface represents a callback functionality for asynchronous GraphQL callouts.

`void received(GraphQLResponse response)` - The method that should be called when the asynchronous send call is done and the response is received. [`GraphQLResponse`](#graphqlresponse) should be passed as the parameter.

---
