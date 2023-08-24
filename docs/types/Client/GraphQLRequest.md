# GraphQLRequest

Represents the GraphQL request for the client

**Group** Client

## Constructors

### `global GraphQLRequest(String stringNode)`

Create an instance using the string GraphQL request

#### Parameters

| Param        | Description            |
| ------------ | ---------------------- |
| `stringNode` | String GraphQL request |

#### Throws

| Exception                 | Description                                                                |
| ------------------------- | -------------------------------------------------------------------------- |
| `GraphQLRequestException` | If the provided string is not a GraphQL request or if it is a subscription |

### `global GraphQLRequest(GraphQLOperation node)`

Create an instance using a GraphQL node for a specific GraphQL operation (Query or Mutation)

#### Parameters

| Param       | Description                                                                                                                                             |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operation` | The instance of the [GraphQLOperationType](/types/Operations/GraphQLOperationType.md) enum (`Query` or `Mutation`)                                      |
| `node`      | The instance of the Graph operation node ([GraphQLQuery](/types/Operations/GraphQLQuery.md) or [GraphQLMutation](/types/Operations/GraphQLMutation.md)) |

#### Throws

| Exception                 | Description                                                                                                  |
| ------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `GraphQLRequestException` | If the provided instance is neither [GraphQLQuery](/types/Operations/GraphQLQuery.md) nor <GraphQLMutation>> |

---

## Fields

### `global headers` → `Map<String,String>`

The request custom headers

### `global operation` → `GraphQLOperationType`

The request GraphQL operation: Query or Mutation

---

## Properties

### `global timeout` → `Integer`

The request timeout in milliseconds. Default is 120000 ms

---

## Methods

### `global GraphQLRequest withHeader(String key, String value)`

Add a custom header to the request. For example `Authorization`

#### Parameters

| Param   | Description             |
| ------- | ----------------------- |
| `key`   | The header key          |
| `value` | The header string value |

#### Returns

| Type           | Description                                                            |
| -------------- | ---------------------------------------------------------------------- |
| GraphQLRequest | The current [GraphQLRequest](/types/Client/GraphQLRequest.md) instance |

### `global GraphQLRequest withHeaders(Map<String,String> headers)`

Add multiple custom headers to the request. For example `Authorization`

#### Parameters

| Param     | Description        |
| --------- | ------------------ |
| `headers` | The Map of headers |

#### Returns

| Type           | Description                                                            |
| -------------- | ---------------------------------------------------------------------- |
| GraphQLRequest | The current [GraphQLRequest](/types/Client/GraphQLRequest.md) instance |

### `global GraphQLRequest withTimeout(Integer timeout)`

Set a timeout for the GraphQL request

#### Parameters

| Param     | Description                 |
| --------- | --------------------------- |
| `timeout` | The timeout in milliseconds |

#### Returns

| Type           | Description                                                            |
| -------------- | ---------------------------------------------------------------------- |
| GraphQLRequest | The current [GraphQLRequest](/types/Client/GraphQLRequest.md) instance |

### `global GraphQLRequest withVariable(String name, Object value)`

Add a variable definition value to the request

#### Parameters

| Param   | Description               |
| ------- | ------------------------- |
| `name`  | The varibale name         |
| `value` | The varibale actual value |

#### Returns

| Type           | Description                                                            |
| -------------- | ---------------------------------------------------------------------- |
| GraphQLRequest | The current [GraphQLRequest](/types/Client/GraphQLRequest.md) instance |

### `global GraphQLRequest withVariables(Map<String,Object> variables)`

Add multiple variable definition values to the request

#### Parameters

| Param       | Description          |
| ----------- | -------------------- |
| `variables` | The Map of varibales |

#### Returns

| Type           | Description                                                            |
| -------------- | ---------------------------------------------------------------------- |
| GraphQLRequest | The current [GraphQLRequest](/types/Client/GraphQLRequest.md) instance |

### `global override String toString()`

Serialize the request to JSON format

#### Returns

| Type   | Description                            |
| ------ | -------------------------------------- |
| String | The JSON representation of the request |

### `global String toString(Boolean pretty)`

Serialize the request to JSON format

#### Parameters

| Param    | Description                                       |
| -------- | ------------------------------------------------- |
| `pretty` | Flag that serializes the request pretty if `true` |

#### Returns

| Type   | Description                            |
| ------ | -------------------------------------- |
| String | The JSON representation of the request |

---
