# GraphQLNode

Defines the base properties and methods for every GraphQL node

## Fields

### `global directives` → `List<GraphQLDirective>`

The list of directives attached to the node

### `global name` → `String`

The GraphQL node name. Can be empty but cannot be `null`

### `global nodes` → `List<GraphQLNode>`

The list of child nodes

---

## Methods

### `global Boolean isFieldNode()`

Check if the current node is an instance of [GraphQLField](/types/Query/GraphQLField.md)

#### Returns

| Type    | Description                                                                    |
| ------- | ------------------------------------------------------------------------------ |
| Boolean | `true` if the current instance is [GraphQLField](/types/Query/GraphQLField.md) |

### `global Boolean isFragmentNode()`

Check if the current node is an instance of [GraphQLFragment](/types/Query/GraphQLFragment.md)

#### Returns

| Type    | Description                                                                          |
| ------- | ------------------------------------------------------------------------------------ |
| Boolean | `true` if the current instance is [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global Boolean hasField(GraphQLField field)`

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

Check if there are any child nodes

#### Returns

| Type    | Description                                                    |
| ------- | -------------------------------------------------------------- |
| Boolean | `true` if the child nodes list is not empty. `false` otherwise |

### `global Boolean hasDirectives()`

Check if the current node contains any directives

#### Returns

| Type    | Description                                           |
| ------- | ----------------------------------------------------- |
| Boolean | `true` if there are any directives. `false` otherwise |

### `global String build()`

Parse the node as a string

#### Returns

| Type   | Description                       |
| ------ | --------------------------------- |
| String | String representation of the node |

### `global String build(Boolean pretty)`

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
