# GraphQLArgument

Represents an entry of a GraphQL argument in a node

## Constructors

### `global GraphQLArgument(String key, Object value)`

Create an instance of an argument by the provided name and value

#### Parameters

| Param   | Description        |
| ------- | ------------------ |
| `key`   | The argument name  |
| `value` | The argument value |

---

## Fields

### `global key` → `String`

The argument name

### `global type` → `GraphQLArgumentType`

The argument GraphQL type

### `global value` → `Object`

The argument value

---

## Methods

### `global Boolean isVariable()`

Check if the current argument references a variable

#### Returns

| Type    | Description                                                             |
| ------- | ----------------------------------------------------------------------- |
| Boolean | `true` if the current argument references a variable. `false` otherwise |

---
