# Type Definitions

This unit describes the Apex classes of the package that can be used for working with GraphQL API.

### Content:

-   [GraphQLNode](#graphqlnode)
-   [GraphQLQueryNode](#graphqlquerynode)
-   [GraphQLMutationNode](#graphqlmutationnode)
-   [GraphQLArgument](#graphqlargument)
-   [GraphQLArgumentType (enum)](#graphqlargumenttype)
-   [GraphQLRequest](#graphqlrequest)
-   [GraphQLOperation (enum)](#graphqloperation)

## GraphQLNode

This class can be used for building nodes (method calls) for queries, mutations, fragments, etc.

### Constructors

`GraphQLNode()` - Creates a new instance of the GraphQLNode with an empty name.

---

`GraphQLNode(String name)` - Creates a new instance of the GraphQLNode with the provided name.

---

`GraphQLNode(List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLNode with the provided child nodes and an empty name.

---

`GraphQLNode(List<String> fields)` - Creates a new instance of the GraphQLNode with the provided fields and an empty name.

---

`GraphQLNode(String name, List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLNode with the provided name and child nodes.

---

`GraphQLNode(String name, List<String> fields)` - Creates a new instance of the GraphQLNode with the provided name and fields.

---

### Properties

`String name` - The name of a node. It can be empty but in that case, when you build the node you'll get an output like:

`{ ... }`

So, basically, in that case, this node can be used for a query request but the better recommendation would be to utilize [`GraphQLQueryNode`](#graphqlquerynode) for that purpose.

---

`List<GraphQLNode> nodes` - The list of child nodes (or fields) of the current node. If a node has no child nodes it'll be built as a field. Therefore, this property is optional.

---

`Map<String, GraphQLArgument> arguments` - The list of node's arguements mapped by their names. Read about [`GraphQLArgument` here](#graphqlargument). Arguments are optional.

---

### Methods

`Boolean hasNode(GraphQLNode node)` - Returns true if there is a node with the same name from the parameter. Otherwise returns false.

---

`Boolean hasNodes(GraphQLNode[] nodes)` - Returns true if there is at least one node from the provided array. Otherwise returns false.

---

`Boolean hasNodes()` - Returns true if there is at least one child node in the current node. Otherwise returns false.

---

`Boolean hasArguments()` - Returns true if there is at least one argument in the current node. Otherwise returns false.

---

`GraphQLNode withField(String field)` - Adds a new field to the current node. Returns the current node instance.

---

`GraphQLNode withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

---

`GraphQLNode withNode(GraphQLNode node)` - Adds a new child node to the current node. Accepts one parameter of type [`GraphQLNode`](#graphqlnode). Returns the current node instance.

---

`GraphQLNode withNodes(GraphQLNode[] nodes)` - Adds new child nodes to the current node. Accepts one parameter of type [`GraphQLNode[]`](#graphqlnode) (list can also be implicitly converted to the array). Returns the current node instance.

---

`GraphQLNode withArgument(String key, Object value)` - Adds a new argument for the current node. Accepts key and value as parameters. Value can be any type - it will be automatically converted to the appropriate GraphQL type. Returns the current node instance.

---

`GraphQLNode withArgument(GraphQLArgument argument)` - Adds a new argument for the current node. Accepts one parameter of type [`GraphQLArgument`](#graphqlargument). Returns the current node instance.

---

`GraphQLNode withArguments(GraphQLArgument[] arguments)` - Adds new arguments for the current node. Accepts one parameter of type [`GraphQLArgument[]`](#graphqlargument) (list can also be implicitly converted to the array). Returns the current node instance.

---

`String build()` - Builds a non-formatted string representation of the current node.

---

`String build(Boolean pretty)` - Builds a string representation of the current node. The result string can be formatted depending on the provided boolean flag `pretty`.

---

## GraphQLQueryNode

This class is only used for building queries.

### Constructors

`GraphQLQueryNode()` - Creates a new instance of the GraphQLQueryNode.

---

`GraphQLQueryNode(String alias)` - Creates a new instance of the GraphQLQueryNode with the provided alias.

---

`GraphQLQueryNode(List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLQueryNode with the provided child nodes.

---

`GraphQLQueryNode(List<String> fields)` - Creates a new instance of the GraphQLQueryNode with the provided fields.

---

`GraphQLQueryNode(String alias, List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLQueryNode with the provided alias and child nodes.

---

`GraphQLQueryNode(String alias, List<String> fields)` - Creates a new instance of the GraphQLQueryNode with the provided alias and fields.

---

### Properties

GraphQLQueryNode has the same properties as the [`GraphQLNode`](#graphqlnode) class.

---

### Methods

`Boolean hasNode(GraphQLNode node)` - Returns true if there is a node with the same name from the parameter. Otherwise returns false.

---

`Boolean hasNodes(GraphQLNode[] nodes)` - Returns true if there is at least one node from the provided array. Otherwise returns false.

---

`Boolean hasNodes()` - Returns true if there is at least one child node in the current node. Otherwise returns false.

---

`Boolean hasArguments()` - Returns true if there is at least one argument in the current node. Otherwise returns false.

---

`GraphQLQueryNode withField(String field)` - Adds a new field to the current node. Returns the current node instance.

---

`GraphQLQueryNode withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

---

`GraphQLQueryNode withNode(GraphQLNode node)` - Adds a new child node to the current node. Accepts one parameter of type [`GraphQLNode`](#graphqlnode). Returns the current node instance.

---

`GraphQLQueryNode withNodes(GraphQLNode[] nodes)` - Adds new child nodes to the current node. Accepts one parameter of type [`GraphQLNode[]`](#graphqlnode) (list can also be implicitly converted to the array). Returns the current node instance.

---

`GraphQLRequest buildRequest()` - Returns a new instace of type [`GraphQLRequest`](#graphqlrequest) building it from the current node.

---

`String build()` - Builds a non-formatted string representation of the current node.

---

`String build(Boolean pretty)` - Builds a string representation of the current node. The result string can be formatted depending on the provided boolean flag `pretty`.

---

## GraphQLMutationNode

This class is only used for building mutations.

### Constructors

`GraphQLMutationNode()` - Creates a new instance of the GraphQLMutationNode.

---

`GraphQLMutationNode(String alias)` - Creates a new instance of the GraphQLMutationNode with the provided alias.

---

`GraphQLMutationNode(List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLMutationNode with the provided child nodes.

---

`GraphQLMutationNode(List<String> fields)` - Creates a new instance of the GraphQLMutationNode with the provided fields.

---

`GraphQLMutationNode(String alias, List<GraphQLNode> nodes)` - Creates a new instance of the GraphQLMutationNode with the provided alias and child nodes.

---

`GraphQLMutationNode(String alias, List<String> fields)` - Creates a new instance of the GraphQLMutationNode with the provided alias and fields.

---

### Properties

GraphQLMutationNode has the same properties as the [`GraphQLNode`](#graphqlnode) class.

---

### Methods

`Boolean hasNode(GraphQLNode node)` - Returns true if there is a node with the same name from the parameter. Otherwise returns false.

---

`Boolean hasNodes(GraphQLNode[] nodes)` - Returns true if there is at least one node from the provided array. Otherwise returns false.

---

`Boolean hasNodes()` - Returns true if there is at least one child node in the current node. Otherwise returns false.

---

`Boolean hasArguments()` - Returns true if there is at least one argument in the current node. Otherwise returns false.

---

`GraphQLMutationNode withField(String field)` - Adds a new field to the current node. Returns the current node instance.

---

`GraphQLMutationNode withFields(String[] fields)` - Adds new fields to the current node. Returns the current node instance.

---

`GraphQLMutationNode withNode(GraphQLNode node)` - Adds a new child node to the current node. Accepts one parameter of type [`GraphQLNode`](#graphqlnode). Returns the current node instance.

---

`GraphQLMutationNode withNodes(GraphQLNode[] nodes)` - Adds new child nodes to the current node. Accepts one parameter of type [`GraphQLNode[]`](#graphqlnode) (list can also be implicitly converted to the array). Returns the current node instance.

---

`GraphQLRequest buildRequest()` - Returns a new instace of type [`GraphQLRequest`](#graphqlrequest) building it from the current node.

---

`String build()` - Builds a non-formatted string representation of the current node.

---

`String build(Boolean pretty)` - Builds a string representation of the current node. The result string can be formatted depending on the provided boolean flag `pretty`.

---

## GraphQLArgument

This class is used for passing arguments to GraphQL nodes.

### Constructors

`GraphQLArgument(String key, Object value)` - Creates a new instance of the GraphQLArgument with provided key and value. Value type will be automatically identified.

---

### Properties

`String key` - Key by which the argument can be identified.

---

`Object value` - Exact value of the argument. Can be any type.

---

`GraphQLArgumentType type` - The enum instance with the GraphQL type of the argument. Will be automatically populated after the argument is created.

---

### Methods

`override String toString()` - Returns a string equivalent of the argument according to its value's type. For example, if the value is an instance of a class it will be serialized with JSON.

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

## GraphQLRequest

This is a wrapper for the GraphQL request. It will be utilized for sending an HTTP request.

### Constructors

`GraphQLRequest(GraphQLNodeBase root)` - Creates a new instance of the GraphQLRequest with the provided root node. `GraphQLNodeBase` is the base implementation for nodes functionality. It's required from `root` to be an instance of GraphQLQueryNode or GraphQLMutationNode. Otherwise, an exception will be thrown.

---

### Properties

`GraphQLOperation operation` - The GraphQL operation type. Read about the [`GraphQLOperation` enum here](#graphqloperation).

---

### Methods

`override String toString()` - Returns the root node as a non-formatted string.

---

## GraphQLOperation

This enum contains values for all available request operations in GraphQL.

### Values

`Query` - GraphQL query operation.  
`Mutation` - GraphQL mutation operation.  
`Subscription` - GraphQL subscription operation. This node builder is not yet implemented since it's currently impossible to work with WebSockets in Apex.

---
