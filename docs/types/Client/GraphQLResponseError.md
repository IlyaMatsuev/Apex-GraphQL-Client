# GraphQLResponseError

Represents the GraphQL response error entry for the client

**Group** Client

## Fields

### `global extensions` → `Map<String,Object>`

The error extensions

### `global locations` → `List<Location>`

The error locations

### `global message` → `String`

Message from the error

### `global path` → `List<Object>`

The error path

---

## Methods

### `global Object getExtensionsAs(Type type)`

Get the error extension as the provided type

#### Parameters

| Param  | Description                                       |
| ------ | ------------------------------------------------- |
| `type` | The type of the error extension to deserialize to |

#### Returns

| Type   | Description                      |
| ------ | -------------------------------- |
| Object | The deserialized error extension |

---

## Classes

### Location

#### Fields

##### `global column` → `Integer`

##### `global line` → `Integer`

---

---
