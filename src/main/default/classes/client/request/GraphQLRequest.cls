global class GraphQLRequest {
    global final GraphQLOperation operation;
    global final Map<String, String> customHeaders = new Map<String, String>();
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

    global GraphQLRequest withHeader(String key, String value) {
        return withHeaders(new Map<String, String>{ key => value });
    }

    global GraphQLRequest withHeaders(Map<String, String> headers) {
        customHeaders.putAll(headers);
        return this;
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
