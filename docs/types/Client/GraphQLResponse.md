# GraphQLResponse

Represents the GraphQL response for the client

**Group** Client

## Methods

### `global Boolean hasErrors()`

Show if the response contains any errors

#### Returns

| Type    | Description                                                       |
| ------- | ----------------------------------------------------------------- |
| Boolean | `true` if there are any errors in the response. `false` otherwise |

### `global Boolean hasData()`

Show if the response contains the data

#### Returns

| Type    | Description                                                        |
| ------- | ------------------------------------------------------------------ |
| Boolean | `true` if there is a data field in the response. `false` otherwise |

### `global List getErrors()`

Get the list of errors in the response

#### Returns

| Type                       | Description                                                                                           |
| -------------------------- | ----------------------------------------------------------------------------------------------------- |
| List<GraphQLResponseError> | The list of `GraphQLResponseError` instances if there are any errors. Returns an empty list otherwise |

### `global Map getData()`

Get the parsed data from the response as a Map

#### Returns

| Type               | Description                        |
| ------------------ | ---------------------------------- |
| Map<String,Object> | The data field deserialized as Map |

### `global Object getDataAs(Type type)`

Get the parsed data from the response as the provided type

#### Parameters

| Param  | Description         |
| ------ | ------------------- |
| `type` | The data field type |

#### Returns

| Type   | Description                                      |
| ------ | ------------------------------------------------ |
| Object | The data field deserialized as the provided type |

### `global Object getDataNode(String nodeName)`

Get a certain field from the parsed data in the response

#### Parameters

| Param      | Description                       |
| ---------- | --------------------------------- |
| `nodeName` | The name of the data field to get |

#### Returns

| Type   | Description                                                                     |
| ------ | ------------------------------------------------------------------------------- |
| Object | The value of the field from the data. Returns `null` if the field was not found |

### `global Object getDataNodeAs(String nodeName, Type type)`

Get a certain field from the parsed data in the response as the provided type

#### Parameters

| Param      | Description                       |
| ---------- | --------------------------------- |
| `nodeName` | The name of the data field to get |
| `type`     | The field type                    |

#### Returns

| Type   | Description                                                            |
| ------ | ---------------------------------------------------------------------- |
| Object | The value of the field from the data deserialized as the provided type |

---
