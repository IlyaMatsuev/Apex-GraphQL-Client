public interface IGraphQLRequestBuilderFactory {
    IGraphQLRequestBuilder create(GraphQLOperation operation, GraphQLNode rootNode);
}
