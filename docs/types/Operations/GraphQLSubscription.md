# GraphQLSubscription

The GraphQL subscription node

**Inheritance**

[GraphQLNode](/types/Query/GraphQLNode.md)
&gt;
[GraphQLOperation](/types/Operations/GraphQLOperation.md)
&gt;
GraphQLSubscription

**Group** Operations

## Constructors

### `global GraphQLSubscription()`

Create a new instance of the GraphQL subscription node

### `global GraphQLSubscription(String alias)`

Create a new instance of the GraphQL subscription node with the provided alias

#### Parameters

| Param   | Description            |
| ------- | ---------------------- |
| `alias` | The subscription alias |

### `global GraphQLSubscription(GraphQLField fieldNode)`

Create a new instance of the GraphQL subscription node with the provided child node

#### Parameters

| Param       | Description    |
| ----------- | -------------- |
| `fieldNode` | The child node |

### `global GraphQLSubscription(List<String> fields)`

Create a new instance of the GraphQL subscription node with the provided child fields

#### Parameters

| Param    | Description      |
| -------- | ---------------- |
| `fields` | The child fields |

### `global GraphQLSubscription(List<GraphQLField> fieldNodes)`

Create a new instance of the GraphQL subscription node with the provided child nodes

#### Parameters

| Param        | Description     |
| ------------ | --------------- |
| `fieldNodes` | The child nodes |

### `global GraphQLSubscription(String alias, GraphQLField fieldNode)`

Create a new instance of the GraphQL subscription node with the provided alias and child node

#### Parameters

| Param       | Description            |
| ----------- | ---------------------- |
| `alias`     | The subscription alias |
| `fieldNode` | The child node         |

### `global GraphQLSubscription(String alias, List<String> fields)`

Create a new instance of the GraphQL subscription node with the provided alias and child fields

#### Parameters

| Param    | Description            |
| -------- | ---------------------- |
| `alias`  | The subscription alias |
| `fields` | The child fields       |

### `global GraphQLSubscription(String alias, List<GraphQLField> fieldNodes)`

Create a new instance of the GraphQL subscription node with the provided alias and child nodes

#### Parameters

| Param        | Description            |
| ------------ | ---------------------- |
| `alias`      | The subscription alias |
| `fieldNodes` | The child nodes        |

---

## Fields

### `global directives` → `List<GraphQLDirective>`

_Inherited_

The list of directives attached to the node

### `global fragments` → `List<GraphQLFragment>`

_Inherited_

The list of fragment definitions added to the operation

### `global name` → `String`

_Inherited_

The GraphQL node name. Can be empty but cannot be `null`

### `global nodes` → `List<GraphQLNode>`

_Inherited_

The list of child nodes

### `global variables` → `List<GraphQLVariable>`

_Inherited_

The list of variable definitions added to the operation

---

## Methods

### `global GraphQLSubscription withField(String field)`

Add a child field to the current subscription node

#### Parameters

| Param   | Description      |
| ------- | ---------------- |
| `field` | The field to add |

#### Returns

| Type                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| GraphQLSubscription | The instance of the current [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) class |

### `global GraphQLSubscription withFields(String fields)`

Add multiple child fields to the current subscription node

#### Parameters

| Param    | Description               |
| -------- | ------------------------- |
| `fields` | The list of fields to add |

#### Returns

| Type                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| GraphQLSubscription | The instance of the current [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) class |

### `global GraphQLSubscription withField(GraphQLField fieldNode)`

Add a child node to the current subscription node

#### Parameters

| Param       | Description     |
| ----------- | --------------- |
| `fieldNode` | The node to add |

#### Returns

| Type                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| GraphQLSubscription | The instance of the current [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) class |

### `global GraphQLSubscription withFields(GraphQLField fieldNodes)`

Add multiple child nodes to the current subscription node

#### Parameters

| Param   | Description              |
| ------- | ------------------------ |
| `nodes` | The list of nodes to add |

#### Returns

| Type                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| GraphQLSubscription | The instance of the current [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) class |

### `global GraphQLSubscription withDirective(GraphQLDirective directive)`

Add a custom directive to the current subscription node

#### Parameters

| Param       | Description               |
| ----------- | ------------------------- |
| `directive` | The directive to be added |

#### Returns

| Type                | Description                                                                             |
| ------------------- | --------------------------------------------------------------------------------------- |
| GraphQLSubscription | The current instance of [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) |

### `global GraphQLSubscription defineFragment(GraphQLFragment fragment)`

Add a fragment definition for the current subscription node

#### Parameters

| Param      | Description                    |
| ---------- | ------------------------------ |
| `fragment` | The fragment definition to add |

#### Returns

| Type                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| GraphQLSubscription | The instance of the current [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) class |

#### Throws

| Exception                   | Description                        |
| --------------------------- | ---------------------------------- |
| `GraphQLOperationException` | If the provided fragment is inline |

### `global GraphQLSubscription defineFragments(GraphQLFragment fragments)`

Add multiple fragment definitions for the current subscription node

#### Parameters

| Param       | Description                             |
| ----------- | --------------------------------------- |
| `fragments` | The list of fragment definitions to add |

#### Returns

| Type                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| GraphQLSubscription | The instance of the current [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) class |

#### Throws

| Exception                   | Description                                  |
| --------------------------- | -------------------------------------------- |
| `GraphQLOperationException` | If some of the provided fragments are inline |

### `global GraphQLSubscription defineVariable(String name, String typeDefinition)`

Add a variable definition for the current subscription node

#### Parameters

| Param            | Description                  |
| ---------------- | ---------------------------- |
| `name`           | The variable name            |
| `typeDefinition` | The variable type definition |

#### Returns

| Type                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| GraphQLSubscription | The instance of the current [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) class |

### `global GraphQLSubscription defineVariable(GraphQLVariable variable)`

Add a variable definition for the current subscription node

#### Parameters

| Param      | Description                    |
| ---------- | ------------------------------ |
| `variable` | The variable definition to add |

#### Returns

| Type                | Description                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| GraphQLSubscription | The instance of the current [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) class |

### `global override GraphQLRequest asRequest()`

Create a GraphQL request from the current subscription node

#### Returns

| Type           | Description                                |
| -------------- | ------------------------------------------ |
| GraphQLRequest | The instance of the `GraphQLRequest` class |

#### Throws

| Exception                   | Description                                     |
| --------------------------- | ----------------------------------------------- |
| `GraphQLOperationException` | The subscription requests are not supported yet |

### `global override GraphQLOperationType getOperation()`

Get the current node's operation type

#### Returns

| Type                 | Description                                    |
| -------------------- | ---------------------------------------------- |
| GraphQLOperationType | `GraphQLOperationType.Subscription` enum value |

### `global Boolean hasVariables()`

_Inherited_

Check the current operation node has any defined variables

#### Returns

| Type    | Description                                                     |
| ------- | --------------------------------------------------------------- |
| Boolean | `true` if there are any variable definitions. `false` otherwise |

### `global Boolean hasFragments()`

_Inherited_

Check the current operation node has any defined fragments

#### Returns

| Type    | Description                                                     |
| ------- | --------------------------------------------------------------- |
| Boolean | `true` if there are any fragment definitions. `false` otherwise |

### `global Boolean isFieldNode()`

_Inherited_

Check if the current node is an instance of [GraphQLField](/types/Query/GraphQLField.md)

#### Returns

| Type    | Description                                                                    |
| ------- | ------------------------------------------------------------------------------ |
| Boolean | `true` if the current instance is [GraphQLField](/types/Query/GraphQLField.md) |

### `global Boolean isFragmentNode()`

_Inherited_

Check if the current node is an instance of [GraphQLFragment](/types/Query/GraphQLFragment.md)

#### Returns

| Type    | Description                                                                          |
| ------- | ------------------------------------------------------------------------------------ |
| Boolean | `true` if the current instance is [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global Boolean hasField(GraphQLField field)`

_Inherited_

Check if the provided field node exists in the child nodes. Searches by the field's name

#### Parameters

| Param   | Description                                 |
| ------- | ------------------------------------------- |
| `field` | The target GraphQL field node to search for |

#### Returns

| Type    | Description                                                                      |
| ------- | -------------------------------------------------------------------------------- |
| Boolean | `true` if the node with the same name is found in child nodes. `false` otherwise |

### `global Boolean hasNodes()`

_Inherited_

Check if there are any child nodes

#### Returns

| Type    | Description                                                    |
| ------- | -------------------------------------------------------------- |
| Boolean | `true` if the child nodes list is not empty. `false` otherwise |

### `global Boolean hasDirectives()`

_Inherited_

Check if the current node contains any directives

#### Returns

| Type    | Description                                           |
| ------- | ----------------------------------------------------- |
| Boolean | `true` if there are any directives. `false` otherwise |

### `global String build()`

_Inherited_

Parse the node as a string

#### Returns

| Type   | Description                       |
| ------ | --------------------------------- |
| String | String representation of the node |

### `global String build(Boolean pretty)`

_Inherited_

Parse the node as a string

#### Parameters

| Param    | Description                                |
| -------- | ------------------------------------------ |
| `pretty` | Prettify the output if the value is `true` |

#### Returns

| Type   | Description                       |
| ------ | --------------------------------- |
| String | String representation of the node |

---
