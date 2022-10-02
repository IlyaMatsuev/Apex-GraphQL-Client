/**
 * @description Defines the GraphQL client interface
 */
global interface IGraphQLClient {
    /**
     * @description Send GraphQL request (Query or Mutation) and wait for the response
     * @param request The instance of request to be send
     * @return The `GraphQLResponse` instance containing parsed GraphQL response
     */
    GraphQLResponse send(GraphQLRequest request);

    /**
     * @description Send GraphQL request (Query or Mutation) without awaiting the response or passing the callback that will be executed when the response is received
     * @param request The instance of request to be send
     * @param callback The instance of `IGraphQLResponseCallback` implementing the callback method. Can be null
     * @return The id of the `Queueable` Apex job
     */
    Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback);
}
