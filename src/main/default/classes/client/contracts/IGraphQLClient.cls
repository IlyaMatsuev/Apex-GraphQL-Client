global interface IGraphQLClient {
    GraphQLResponse send(GraphQLRequest request);
    Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback);
}
