public class GraphQLMutationBuilder extends GraphQLBuilder implements IGraphQLRequestBuilder {

    public GraphQLMutationBuilder(GraphQLNode rootNode) {
        super(
            GraphQLOperation.Mutation.name().toLowerCase() + CommonConstants.SPACE + rootNode.name,
            rootNode.nodes
        );
    }

    public GraphQLRequest buildRequest() {
        return new GraphQLRequest(GraphQLOperation.Mutation, this);
    }
}
