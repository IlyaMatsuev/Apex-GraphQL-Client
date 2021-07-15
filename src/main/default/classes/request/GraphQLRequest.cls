public class GraphQLRequest {

    public final GraphQLOperation operation;
    private GraphQLNodeBase root;

    public GraphQLRequest(GraphQLNodeBase root) {
        this(null, root);
    }

    public GraphQLRequest(GraphQLOperation operation, GraphQLNodeBase root) {
        this.operation = operation == null ? GraphQLOperation.Query : operation;
        this.root = root;

        if (!(root instanceof IGraphQLRequestBuilder)) {
            throw new GraphQLRequestException(Label.RequestNodeOfIncorrectTypeError);
        }
    }

    public override String toString() {
        return toString(false);
    }

    public String toString(Boolean pretty) {
        return root.build(pretty);
    }
}
