# GraphQLField

The GraphQL node that can be a part of a GraphQL operation

**Inheritance**

[GraphQLNode](/types/Query/GraphQLNode.md)
&gt;
GraphQLField

## Constructors

### `global GraphQLField()`

Create an instance of [GraphQLField](/types/Query/GraphQLField.md) with the empty name

### `global GraphQLField(String name)`

Create an instance of [GraphQLField](/types/Query/GraphQLField.md) with the provided name

#### Parameters

| Param  | Description         |
| ------ | ------------------- |
| `name` | The new node's name |

### `global GraphQLField(List<GraphQLField> fieldNodes)`

Create an instance of [GraphQLField](/types/Query/GraphQLField.md) with an empty name and child nodes

#### Parameters

| Param        | Description                 |
| ------------ | --------------------------- |
| `fieldNodes` | The list of the child nodes |

### `global GraphQLField(List<String> fields)`

Create an instance of [GraphQLField](/types/Query/GraphQLField.md) with an empty name and child fields

#### Parameters

| Param    | Description                  |
| -------- | ---------------------------- |
| `fields` | The list of the child fields |

### `global GraphQLField(String name, List<GraphQLField> fieldNodes)`

Create an instance of [GraphQLField](/types/Query/GraphQLField.md) with the provided name and child nodes

#### Parameters

| Param        | Description                 |
| ------------ | --------------------------- |
| `fieldNodes` | The list of the child nodes |

### `global GraphQLField(String name, List<String> fields)`

Create an instance of [GraphQLField](/types/Query/GraphQLField.md) with the provided name and child fields

#### Parameters

| Param    | Description                  |
| -------- | ---------------------------- |
| `fields` | The list of the child fields |

---

## Fields

### `global arguments` → `Map<String,GraphQLArgument>`

The Map of node arguments with the names as keys

### `global directives` → `List<GraphQLDirective>`

_Inherited_

The list of directives attached to the node

### `global name` → `String`

_Inherited_

The GraphQL node name. Can be empty but cannot be `null`

### `global nodes` → `List<GraphQLNode>`

_Inherited_

The list of child nodes

---

## Properties

### `global alias` → `String`

The alias of the GraphQL node. Can be null

---

## Methods

### `global Boolean hasArguments()`

Check if the current node contains any arguments

#### Returns

| Type    | Description                                          |
| ------- | ---------------------------------------------------- |
| Boolean | `true` if there are any arguments. `false` otherwise |

### `global GraphQLField byAlias(String alias)`

Add an alias to the current node

#### Parameters

| Param   | Description           |
| ------- | --------------------- |
| `alias` | The node's alias name |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withField(String field)`

Add a child field to the current node

#### Parameters

| Param   | Description                |
| ------- | -------------------------- |
| `field` | The field name to be added |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withFields(String fields)`

Add multiple child fields to the current node

#### Parameters

| Param    | Description                         |
| -------- | ----------------------------------- |
| `fields` | The list of field names to be added |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withField(GraphQLField fieldNode)`

Add a child node to the current node

#### Parameters

| Param       | Description                |
| ----------- | -------------------------- |
| `fieldNode` | The field node to be added |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withFields(GraphQLField fieldNodes)`

Add multiple child nodes to the current node

#### Parameters

| Param        | Description                 |
| ------------ | --------------------------- |
| `fieldNodes` | The field nodes to be added |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withFragment(String fragmentName)`

Add a fragment use to the current node

#### Parameters

| Param          | Description                         |
| -------------- | ----------------------------------- |
| `fragmentName` | The name of the fragment to be used |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withFragments(String fragmentNames)`

Add multiple fragment uses to the current node

#### Parameters

| Param           | Description                                   |
| --------------- | --------------------------------------------- |
| `fragmentNames` | The list of names of the fragments to be used |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withInlineFragment(GraphQLFragment fragment)`

Add an inline fragment to the current node

#### Parameters

| Param      | Description                                                                                                      |
| ---------- | ---------------------------------------------------------------------------------------------------------------- |
| `fragment` | The instance of the [GraphQLFragment](/types/Query/GraphQLFragment.md). Should be inline fragment without a name |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

#### Throws

| Exception              | Description                          |
| ---------------------- | ------------------------------------ |
| `GraphQLNodeException` | If the passed fragment is not inline |

### `global GraphQLField withInlineFragments(GraphQLFragment fragments)`

Add inline fragments to the current node

#### Parameters

| Param      | Description                                                                                                       |
| ---------- | ----------------------------------------------------------------------------------------------------------------- |
| `fragment` | The instances of the [GraphQLFragment](/types/Query/GraphQLFragment.md). Should be inline fragments without names |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

#### Throws

| Exception              | Description                                    |
| ---------------------- | ---------------------------------------------- |
| `GraphQLNodeException` | If some of the passed fragments are not inline |

### `global GraphQLField withArgument(String key, Object value)`

Add an argument to the current node

#### Parameters

| Param   | Description                                                               |
| ------- | ------------------------------------------------------------------------- |
| `key`   | The argument name                                                         |
| `value` | The argument value. Use string with the `$` sign for variable referencing |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withArgument(GraphQLArgument argument)`

Add an argument to the current node

#### Parameters

| Param      | Description              |
| ---------- | ------------------------ |
| `argument` | The argument to be added |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withArguments(GraphQLArgument arguments)`

Add multiple arguments to the current node

#### Parameters

| Param       | Description                       |
| ----------- | --------------------------------- |
| `arguments` | The list of arguments to be added |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField withDirective(GraphQLDirective directive)`

Add a custom directive to the current node

#### Parameters

| Param       | Description               |
| ----------- | ------------------------- |
| `directive` | The directive to be added |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField includeIf(Boolean condition)`

Add the standard `includeIf` directive to the current node

#### Parameters

| Param       | Description                             |
| ----------- | --------------------------------------- |
| `condition` | The boolean condition for the directive |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField includeIf(String variable)`

Add the standard `includeIf` directive to the current node

#### Parameters

| Param      | Description                                                            |
| ---------- | ---------------------------------------------------------------------- |
| `variable` | The variable reference for the directive. The `$` sign is not required |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField skipIf(Boolean condition)`

Add the standard `skipIf` directive to the current node

#### Parameters

| Param       | Description                             |
| ----------- | --------------------------------------- |
| `condition` | The boolean condition for the directive |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLField skipIf(String variable)`

Add the standard `skipIf` directive to the current node

#### Parameters

| Param      | Description                                                            |
| ---------- | ---------------------------------------------------------------------- |
| `variable` | The variable reference for the directive. The `$` sign is not required |

#### Returns

| Type         | Description                                                          |
| ------------ | -------------------------------------------------------------------- |
| GraphQLField | The current instance of [GraphQLField](/types/Query/GraphQLField.md) |

### `global GraphQLQuery asQuery()`

Convert the current node to the Query node. The arguments and directives are not transferred to the new node

#### Returns

| Type         | Description                                                        |
| ------------ | ------------------------------------------------------------------ |
| GraphQLQuery | The new [GraphQLQuery](/types/Operations/GraphQLQuery.md) instance |

### `global GraphQLMutation asMutation()`

Convert the current node to the Mutation node. The arguments and directives are not transferred to the new node

#### Returns

| Type            | Description                                                              |
| --------------- | ------------------------------------------------------------------------ |
| GraphQLMutation | The new [GraphQLMutation](/types/Operations/GraphQLMutation.md) instance |

### `global GraphQLSubscription asSubscription()`

Convert the current node to the Subscription node. The arguments and directives are not transferred to the new node

#### Returns

| Type                | Description                                                                      |
| ------------------- | -------------------------------------------------------------------------------- |
| GraphQLSubscription | The new [GraphQLSubscription](/types/Operations/GraphQLSubscription.md) instance |

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
