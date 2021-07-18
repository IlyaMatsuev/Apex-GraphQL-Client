global class GraphQLRequest {

    global final GraphQLOperation operation;
    private GraphQLNodeBase root;

    global GraphQLRequest(GraphQLNodeBase root) {
        this(null, root);
    }

    global GraphQLRequest(GraphQLOperation operation, GraphQLNodeBase root) {
        this.operation = operation == null ? GraphQLOperation.Query : operation;
        this.root = root;

        if (!(root instanceof IGraphQLRequestBuilder)) {
            throw new GraphQLRequestException(Label.RequestNodeOfIncorrectTypeError);
        }
    }

    global override String toString() {
        return toString(false);
    }

    global String toString(Boolean pretty) {
        return root.build(pretty);
    }

    private class GraphQLRequestException extends Exception {}
}
