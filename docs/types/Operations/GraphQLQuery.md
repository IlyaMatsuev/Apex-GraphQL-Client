# GraphQLQuery

The GraphQL query node

**Inheritance**

[GraphQLNode](/types/Query/GraphQLNode.md)
&gt;
[GraphQLOperation](/types/Operations/GraphQLOperation.md)
&gt;
GraphQLQuery

**Group** Operations

## Constructors

### `global GraphQLQuery()`

Create a new instance of the GraphQL query node

### `global GraphQLQuery(String alias)`

Create a new instance of the GraphQL query node with the provided alias

#### Parameters

| Param   | Description     |
| ------- | --------------- |
| `alias` | The query alias |

### `global GraphQLQuery(GraphQLField fieldNode)`

Create a new instance of the GraphQL query node with the provided child node

#### Parameters

| Param       | Description    |
| ----------- | -------------- |
| `fieldNode` | The child node |

### `global GraphQLQuery(List<String> fields)`

Create a new instance of the GraphQL query node with the provided child fields

#### Parameters

| Param    | Description      |
| -------- | ---------------- |
| `fields` | The child fields |

### `global GraphQLQuery(List<GraphQLField> fieldNodes)`

Create a new instance of the GraphQL query node with the provided child nodes

#### Parameters

| Param        | Description     |
| ------------ | --------------- |
| `fieldNodes` | The child nodes |

### `global GraphQLQuery(String alias, GraphQLField fieldNode)`

Create a new instance of the GraphQL query node with the provided alias and child node

#### Parameters

| Param       | Description     |
| ----------- | --------------- |
| `alias`     | The query alias |
| `fieldNode` | The child node  |

### `global GraphQLQuery(String alias, List<String> fields)`

Create a new instance of the GraphQL query node with the provided alias and child fields

#### Parameters

| Param    | Description      |
| -------- | ---------------- |
| `alias`  | The query alias  |
| `fields` | The child fields |

### `global GraphQLQuery(String alias, List<GraphQLField> fieldNodes)`

Create a new instance of the GraphQL query node with the provided alias and child nodes

#### Parameters

| Param        | Description     |
| ------------ | --------------- |
| `alias`      | The query alias |
| `fieldNodes` | The child nodes |

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

### `global GraphQLQuery withField(String field)`

Add a child field to the current query node

#### Parameters

| Param   | Description      |
| ------- | ---------------- |
| `field` | The field to add |

#### Returns

| Type         | Description                                      |
| ------------ | ------------------------------------------------ |
| GraphQLQuery | The instance of the current `GraphQLQuery` class |

### `global GraphQLQuery withFields(String fields)`

Add multiple child fields to the current query node

#### Parameters

| Param    | Description               |
| -------- | ------------------------- |
| `fields` | The list of fields to add |

#### Returns

| Type         | Description                                      |
| ------------ | ------------------------------------------------ |
| GraphQLQuery | The instance of the current `GraphQLQuery` class |

### `global GraphQLQuery withField(GraphQLField fieldNode)`

Add a child node to the current query node

#### Parameters

| Param       | Description     |
| ----------- | --------------- |
| `fieldNode` | The node to add |

#### Returns

| Type         | Description                                      |
| ------------ | ------------------------------------------------ |
| GraphQLQuery | The instance of the current `GraphQLQuery` class |

### `global GraphQLQuery withFields(GraphQLField fieldNodes)`

Add multiple child nodes to the current query node

#### Parameters

| Param        | Description              |
| ------------ | ------------------------ |
| `fieldNodes` | The list of nodes to add |

#### Returns

| Type         | Description                                      |
| ------------ | ------------------------------------------------ |
| GraphQLQuery | The instance of the current `GraphQLQuery` class |

### `global GraphQLQuery withDirective(GraphQLDirective directive)`

Add a custom directive to the current query node

#### Parameters

| Param       | Description               |
| ----------- | ------------------------- |
| `directive` | The directive to be added |

#### Returns

| Type         | Description                            |
| ------------ | -------------------------------------- |
| GraphQLQuery | The current instance of `GraphQLQuery` |

### `global GraphQLQuery defineFragment(GraphQLFragment fragment)`

Add a fragment definition for the current query node

#### Parameters

| Param      | Description                    |
| ---------- | ------------------------------ |
| `fragment` | The fragment definition to add |

#### Returns

| Type         | Description                                      |
| ------------ | ------------------------------------------------ |
| GraphQLQuery | The instance of the current `GraphQLQuery` class |

#### Throws

| Exception                   | Description                        |
| --------------------------- | ---------------------------------- |
| `GraphQLOperationException` | If the provided fragment is inline |

### `global GraphQLQuery defineFragments(GraphQLFragment fragments)`

Add multiple fragment definitions for the current query node

#### Parameters

| Param       | Description                             |
| ----------- | --------------------------------------- |
| `fragments` | The list of fragment definitions to add |

#### Returns

| Type         | Description                                      |
| ------------ | ------------------------------------------------ |
| GraphQLQuery | The instance of the current `GraphQLQuery` class |

#### Throws

| Exception                   | Description                                  |
| --------------------------- | -------------------------------------------- |
| `GraphQLOperationException` | If some of the provided fragments are inline |

### `global GraphQLQuery defineVariable(String name, String typeDefinition)`

Add a variable definition for the current query node

#### Parameters

| Param            | Description                  |
| ---------------- | ---------------------------- |
| `name`           | The variable name            |
| `typeDefinition` | The variable type definition |

#### Returns

| Type         | Description                                      |
| ------------ | ------------------------------------------------ |
| GraphQLQuery | The instance of the current `GraphQLQuery` class |

### `global GraphQLQuery defineVariable(GraphQLVariable variable)`

Add a variable definition for the current query node

#### Parameters

| Param      | Description                    |
| ---------- | ------------------------------ |
| `variable` | The variable definition to add |

#### Returns

| Type         | Description                                      |
| ------------ | ------------------------------------------------ |
| GraphQLQuery | The instance of the current `GraphQLQuery` class |

### `global override GraphQLOperationType getOperation()`

Get the current node's operation type

#### Returns

| Type                 | Description                             |
| -------------------- | --------------------------------------- |
| GraphQLOperationType | `GraphQLOperationType.Query` enum value |

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

### `global GraphQLRequest asRequest()`

_Inherited_

Create a GraphQL request from the current operation node

#### Returns

| Type           | Description                                |
| -------------- | ------------------------------------------ |
| GraphQLRequest | The instance of the `GraphQLRequest` class |

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
