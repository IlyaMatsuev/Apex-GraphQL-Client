# GraphQLFragment

Represents a GraphQL fragment node definition. Can be used for regular and inline fragments

**Inheritance**

[GraphQLNode](/types/Query/GraphQLNode.md)
&gt;
GraphQLFragment

## Constructors

### `global GraphQLFragment()`

Create an instance of an inline fragment not providing the type. Assuming the type is identical to the parent node's type

### `global GraphQLFragment(String type)`

Create an instance of an inline fragment by the provided type

#### Parameters

| Param  | Description                   |
| ------ | ----------------------------- |
| `type` | The fragment referencing type |

### `global GraphQLFragment(String name, String type)`

Create an instance of a fragment by the provided name and type

#### Parameters

| Param  | Description                   |
| ------ | ----------------------------- |
| `name` | The fragment name             |
| `type` | The fragment referencing type |

### `global GraphQLFragment(String name, String type, List<GraphQLField> fieldNodes)`

Create an instance of a fragment by the provided name, type and nodes

#### Parameters

| Param        | Description                                 |
| ------------ | ------------------------------------------- |
| `name`       | The fragment name                           |
| `type`       | The fragment referencing type               |
| `fieldNodes` | The child nodes to be added to the fragment |

### `global GraphQLFragment(String name, String type, List<String> fields)`

Create an instance of a fragment by the provided name, type and fields

#### Parameters

| Param    | Description                                  |
| -------- | -------------------------------------------- |
| `name`   | The fragment name                            |
| `type`   | The fragment referencing type                |
| `fields` | The child fields to be added to the fragment |

### `global GraphQLFragment(String name, String type, List<GraphQLField> fieldNodes, List<String> fields)`

Create an instance of a fragment by the provided name, type, nodes and fields

#### Parameters

| Param        | Description                                  |
| ------------ | -------------------------------------------- |
| `name`       | The fragment name                            |
| `type`       | The fragment referencing type                |
| `fieldNodes` | The child nodes to be added to the fragment  |
| `fields`     | The child fields to be added to the fragment |

---

## Fields

### `global directives` → `List<GraphQLDirective>`

_Inherited_

The list of directives attached to the node

### `global name` → `String`

_Inherited_

The GraphQL node name. Can be empty but cannot be `null`

### `global nodes` → `List<GraphQLNode>`

_Inherited_

The list of child nodes

### `global type` → `String`

The referencing fragment type

---

## Methods

### `global Boolean isInline()`

Check if the current fragment is an inline fragment

#### Returns

| Type    | Description                                         |
| ------- | --------------------------------------------------- |
| Boolean | `true` if the fragment is inline. `false` otherwise |

### `global GraphQLFragment withField(String field)`

Add a field to the current fragment

#### Parameters

| Param   | Description                |
| ------- | -------------------------- |
| `field` | The field name to be added |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment withFields(String fields)`

Add multiple fields to the current fragment

#### Parameters

| Param    | Description                             |
| -------- | --------------------------------------- |
| `fields` | The list of the field names to be added |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment withField(GraphQLField fieldNode)`

Add a node to the current fragment

#### Parameters

| Param       | Description                         |
| ----------- | ----------------------------------- |
| `fieldNode` | The field node instance to be added |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment withFields(GraphQLField fieldNodes)`

Add multiple nodes to the current fragment

#### Parameters

| Param        | Description                            |
| ------------ | -------------------------------------- |
| `fieldNodes` | The list of node instances to be added |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment withFragment(String fragmentName)`

Add another fragment reference to the current fragment

#### Parameters

| Param          | Description                  |
| -------------- | ---------------------------- |
| `fragmentName` | The fragment name to be used |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment withFragments(String fragmentNames)`

Add other fragment references to the current fragment

#### Parameters

| Param           | Description                           |
| --------------- | ------------------------------------- |
| `fragmentNames` | The list of fragment names to be used |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment withInlineFragment(GraphQLFragment fragment)`

Add an inline fragment to the current fragment

#### Parameters

| Param      | Description                                                                                                      |
| ---------- | ---------------------------------------------------------------------------------------------------------------- |
| `fragment` | The instance of the [GraphQLFragment](/types/Query/GraphQLFragment.md). Should be inline fragment without a name |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

#### Throws

| Exception              | Description                          |
| ---------------------- | ------------------------------------ |
| `GraphQLNodeException` | If the passed fragment is not inline |

### `global GraphQLFragment withInlineFragments(GraphQLFragment fragments)`

Add inline fragments to the current fragment

#### Parameters

| Param      | Description                                                                                                       |
| ---------- | ----------------------------------------------------------------------------------------------------------------- |
| `fragment` | The instances of the [GraphQLFragment](/types/Query/GraphQLFragment.md). Should be inline fragments without names |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

#### Throws

| Exception              | Description                                    |
| ---------------------- | ---------------------------------------------- |
| `GraphQLNodeException` | If some of the passed fragments are not inline |

### `global GraphQLFragment withDirective(GraphQLDirective directive)`

Add a custom directive to the current fragment

#### Parameters

| Param       | Description               |
| ----------- | ------------------------- |
| `directive` | The directive to be added |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment includeIf(Boolean condition)`

Add the standard `includeIf` directive to the current fragment

#### Parameters

| Param       | Description                             |
| ----------- | --------------------------------------- |
| `condition` | The boolean condition for the directive |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment includeIf(String variable)`

Add the standard `includeIf` directive to the current fragment

#### Parameters

| Param      | Description                                                            |
| ---------- | ---------------------------------------------------------------------- |
| `variable` | The variable reference for the directive. The `$` sign is not required |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment skipIf(Boolean condition)`

Add the standard `skipIf` directive to the current fragment

#### Parameters

| Param       | Description                             |
| ----------- | --------------------------------------- |
| `condition` | The boolean condition for the directive |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

### `global GraphQLFragment skipIf(String variable)`

Add the standard `skipIf` directive to the current fragment

#### Parameters

| Param      | Description                                                            |
| ---------- | ---------------------------------------------------------------------- |
| `variable` | The variable reference for the directive. The `$` sign is not required |

#### Returns

| Type            | Description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| GraphQLFragment | The current instance of [GraphQLFragment](/types/Query/GraphQLFragment.md) |

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
