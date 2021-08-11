global class GraphQLRequest {
    global final GraphQLOperation operation;
    global final Map<String, String> customHeaders = new Map<String, String>();
    private final GraphQLNodeBase root;
    private Map<String, Object> variables;

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

    global GraphQLRequest withVariable(String name, Object value) {
        return withVariables(new Map<String, Object>{ name => value });
    }

    global GraphQLRequest withVariables(Map<String, Object> variables) {
        if (this.variables == null) {
            this.variables = new Map<String, Object>();
        }
        this.variables.putAll(variables);
        return this;
    }

    global override String toString() {
        return toString(false);
    }

    global String toString(Boolean pretty) {
        RequestJsonWrapper wrapper = new RequestJsonWrapper(root.build(pretty), variables);
        if (pretty) {
            return JSON.serializePretty(wrapper, true);
        }
        return JSON.serialize(wrapper, true);
    }

    private class RequestJsonWrapper {
        public final String query;
        public final Map<String, Object> variables;

        public RequestJsonWrapper(String query, Map<String, Object> variables) {
            this.query = query;
            this.variables = variables;
        }
    }

    private class GraphQLRequestException extends Exception {
    }
}
