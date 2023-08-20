# GraphQLOperation

The GraphQL operation node, eathier Query, Mutation or Subscription

**Inheritance**

[GraphQLNode](/types/Query/GraphQLNode.md)
&gt;
GraphQLOperation

**Group** Operations

## Fields

### `global directives` → `List<GraphQLDirective>`

_Inherited_

The list of directives attached to the node

### `global fragments` → `List<GraphQLFragment>`

The list of fragment definitions added to the operation

### `global name` → `String`

_Inherited_

The GraphQL node name. Can be empty but cannot be `null`

### `global nodes` → `List<GraphQLNode>`

_Inherited_

The list of child nodes

### `global variables` → `List<GraphQLVariable>`

The list of variable definitions added to the operation

---

## Methods

### `global Boolean hasVariables()`

Check the current operation node has any defined variables

#### Returns

| Type    | Description                                                     |
| ------- | --------------------------------------------------------------- |
| Boolean | `true` if there are any variable definitions. `false` otherwise |

### `global Boolean hasFragments()`

Check the current operation node has any defined fragments

#### Returns

| Type    | Description                                                     |
| ------- | --------------------------------------------------------------- |
| Boolean | `true` if there are any fragment definitions. `false` otherwise |

### `global GraphQLRequest asRequest()`

Create a GraphQL request from the current operation node

#### Returns

| Type           | Description                                |
| -------------- | ------------------------------------------ |
| GraphQLRequest | The instance of the `GraphQLRequest` class |

### `global GraphQLOperationType getOperation()`

Get the GraphQL operation type of the current node

#### Returns

| Type                 | Description                                     |
| -------------------- | ----------------------------------------------- |
| GraphQLOperationType | The instance of the `GraphQLOperationType` enum |

### `global Boolean isFieldNode()`

_Inherited_

Check if the current node is an instance of `GraphQLField`

#### Returns

| Type    | Description                                      |
| ------- | ------------------------------------------------ |
| Boolean | `true` if the current instance is `GraphQLField` |

### `global Boolean isFragmentNode()`

_Inherited_

Check if the current node is an instance of `GraphQLFragment`

#### Returns

| Type    | Description                                         |
| ------- | --------------------------------------------------- |
| Boolean | `true` if the current instance is `GraphQLFragment` |

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
