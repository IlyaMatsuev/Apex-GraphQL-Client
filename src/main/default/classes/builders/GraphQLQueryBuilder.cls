public class GraphQLQueryBuilder extends GraphQLBuilder implements IGraphQLRequestBuilder {

    public GraphQLQueryBuilder(GraphQLNode rootNode) {
        super(
            GraphQLOperation.Query.name().toLowerCase() + CommonConstants.SPACE + rootNode.name,
            rootNode.nodes
        );
    }

    public GraphQLRequest buildRequest() {
        return new GraphQLRequest(GraphQLOperation.Query, this);
    }
}
