global class GraphQLRequest {
    global final GraphQLOperation operation;
    global final Map<String, String> customHeaders = new Map<String, String>();
    private final GraphQLNodeBase node;
    private String stringNode;
    private Map<String, Object> variables;

    global GraphQLRequest(String stringNode) {
        this.stringNode = stringNode;
        this.operation = recognizeOperation(stringNode);
    }

    global GraphQLRequest(GraphQLNodeBase node) {
        this(null, node);
    }

    global GraphQLRequest(GraphQLOperation operation, GraphQLNodeBase node) {
        this.operation = operation == null ? GraphQLOperation.Query : operation;
        this.node = node;

        if (!(node instanceof IGraphQLRequestBuilder)) {
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
        RequestJsonWrapper wrapper = new RequestJsonWrapper(getStringNode(pretty), variables);
        if (pretty) {
            return JSON.serializePretty(wrapper, true);
        }
        return JSON.serialize(wrapper, true);
    }

    private String getStringNode(Boolean pretty) {
        if (stringNode == null) {
            return node.build(pretty);
        }
        return stringNode;
    }

    private GraphQLOperation recognizeOperation(String stringNode) {
        List<String> tokens = stringNode?.split('\\W');
        if (tokens == null || tokens.isEmpty()) {
            throw new GraphQLRequestException(Label.InvalidRequestStringNodeError);
        }

        String operationName = tokens.get(GraphQLConstants.FIRST_ELEMENT);
        if (operationName == GraphQLOperation.Mutation.name().toLowerCase()) {
            return GraphQLOperation.Mutation;
        } else if (operationName == GraphQLOperation.Subscription.name().toLowerCase()) {
            throw new GraphQLRequestException(Label.NotAllowedRequestOperationError);
        } else {
            return GraphQLOperation.Query;
        }
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
