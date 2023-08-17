# GraphQLHttpClient

The client that can be used to send and receive GraphQL requests and responses

**Group** Client

## Constructors

### `global GraphQLHttpClient(String endpoint)`

Create an instance of the client passing the GraphQL endpoint

#### Parameters

| Param      | Description          |
| ---------- | -------------------- |
| `endpoint` | The GraphQL endpoint |

#### Throws

| Exception                    | Description                                   |
| ---------------------------- | --------------------------------------------- |
| `GraphQLHttpClientException` | If the the provided endpoint is null or empty |

---

## Methods

### `global GraphQLResponse send(GraphQLRequest request)`

Send GraphQL request (Query or Mutation) and wait for the response

#### Parameters

| Param     | Description                        |
| --------- | ---------------------------------- |
| `request` | The instance of request to be send |

#### Returns

| Type            | Description                                                       |
| --------------- | ----------------------------------------------------------------- |
| GraphQLResponse | The `GraphQLResponse` instance containing parsed GraphQL response |

### `global Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback)`

Send GraphQL request (Query or Mutation) without awaiting the response or passing the callback that will be executed when the response is received

#### Parameters

| Param      | Description                                                                              |
| ---------- | ---------------------------------------------------------------------------------------- |
| `request`  | The instance of request to be send                                                       |
| `callback` | The instance of `IGraphQLResponseCallback` implementing the callback method. Can be null |

#### Returns

| Type | Description                        |
| ---- | ---------------------------------- |
| Id   | The id of the `Queueable` Apex job |

---
