# GraphQLDirective

Represents a GraphQL directive

## Constructors

### `global GraphQLDirective(String name)`

Creates an instance of a directive by the provided name

#### Parameters

| Param  | Description                                    |
| ------ | ---------------------------------------------- |
| `name` | The directive's name. E.g. `include` or `skip` |

---

## Fields

### `global arguments` → `List<GraphQLArgument>`

The list of arguments added to the directive

### `global name` → `String`

The directive's name followed after the `@` sign

---

## Methods

### `global Boolean hasArguments()`

Check if the directive contains any arguments

#### Returns

| Type    | Description                                          |
| ------- | ---------------------------------------------------- |
| Boolean | `true` if there are any arguments. `false` otherwise |

### `global GraphQLDirective withArgument(String key, Object value)`

Add an argument to the current directive

#### Parameters

| Param   | Description                                                               |
| ------- | ------------------------------------------------------------------------- |
| `key`   | The argument name                                                         |
| `value` | The argument value. Use string with the `$` sign for variable referencing |

#### Returns

| Type             | Description                                                                  |
| ---------------- | ---------------------------------------------------------------------------- |
| GraphQLDirective | The current instance of [GraphQLDirective](/types/Query/GraphQLDirective.md) |

### `global GraphQLDirective withArgument(GraphQLArgument argument)`

Add an argument to the current directive

#### Parameters

| Param      | Description              |
| ---------- | ------------------------ |
| `argument` | The argument to be added |

#### Returns

| Type             | Description                                                                  |
| ---------------- | ---------------------------------------------------------------------------- |
| GraphQLDirective | The current instance of [GraphQLDirective](/types/Query/GraphQLDirective.md) |

---
