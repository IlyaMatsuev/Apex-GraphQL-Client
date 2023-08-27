# GraphQLVariable

Represents a GraphQL variable definition

**Group** Client

## Constructors

### `global GraphQLVariable(String name, String type)`

Creates a variable definition by the provided name and type

#### Parameters

| Param  | Description                                                 |
| ------ | ----------------------------------------------------------- |
| `name` | The variable name with or without the `$` sign              |
| `type` | The variable type. E.g. `Int`, `String` or some custom type |

---

## Properties

### `global defaultValue` → `Object`

The variable definition default value

### `global isNonNull` → `Boolean`

### `global name` → `String`

The variable definition name without the `$` sign

### `global type` → `String`

The variable definition type without the `!` sign. If it's non-null type, the `isNonNull` variable should be `true`

---

## Methods

### `global GraphQLVariable asNonNull()`

Marks the current variable definition as the non-null type

#### Returns

| Type            | Description                                     |
| --------------- | ----------------------------------------------- |
| GraphQLVariable | The current instance of the variable definition |

### `global GraphQLVariable asNonNull(Boolean isNonNull)`

Marks the current variable definition as the non-null or optional type

#### Parameters

| Param       | Description                                                    |
| ----------- | -------------------------------------------------------------- |
| `isNonNull` | Flag that defines if the variable type is non-null or optional |

#### Returns

| Type            | Description                                     |
| --------------- | ----------------------------------------------- |
| GraphQLVariable | The current instance of the variable definition |

### `global GraphQLVariable withDefault(Object defaultValue)`

Adds a default value to the variable definition

#### Parameters

| Param          | Description                        |
| -------------- | ---------------------------------- |
| `defaultValue` | The default value for the variable |

#### Returns

| Type            | Description                                     |
| --------------- | ----------------------------------------------- |
| GraphQLVariable | The current instance of the variable definition |

---
