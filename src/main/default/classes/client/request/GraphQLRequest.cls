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
        RequestJsonWrapper wrapper = new RequestJsonWrapper(root.build(pretty));
        if (pretty) {
            return JSON.serializePretty(wrapper);
        }
        return JSON.serialize(wrapper);
    }

    private class RequestJsonWrapper {
        private final String query;

        // TODO: Add variables support
        public RequestJsonWrapper(String query) {
            this.query = query;
        }
    }

    private class GraphQLRequestException extends Exception {
    }
}
