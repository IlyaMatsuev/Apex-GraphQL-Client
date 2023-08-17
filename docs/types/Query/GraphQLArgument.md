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

### `global value` → `Object`

The argument value

---

## Properties

### `global type` → `GraphQLArgumentType`

The argument GraphQL type

---

## Methods

### `global Boolean isVariable()`

Check if the current argument references a variable

#### Returns

| Type    | Description                                                             |
| ------- | ----------------------------------------------------------------------- |
| Boolean | `true` if the current argument references a variable. `false` otherwise |

### `global GraphQLArgument asEnum()`

Represents the current argument as a GraphQL enum value

#### Returns

| Type            | Description                               |
| --------------- | ----------------------------------------- |
| GraphQLArgument | The current instance of `GraphQLArgument` |

#### Throws

| Exception                  | Description                                                                 |
| -------------------------- | --------------------------------------------------------------------------- |
| `GraphQLArgumentException` | If the current argument value is not String or if it's a variable reference |

---
