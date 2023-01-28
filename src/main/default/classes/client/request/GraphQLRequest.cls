/**
 * @description Represents the GraphQL request for the client
 */
global class GraphQLRequest {
    @TestVisible
    private static final Integer DEFAULT_REQUEST_TIMEOUT = 120000;

    /**
     * @description The request GraphQL operation: Query or Mutation
     */
    global final GraphQLOperationType operation;

    /**
     * @description The request custom headers
     */
    global final Map<String, String> headers = new Map<String, String>();

    /**
     * @description The request timeout in milliseconds. Default is 120000 ms
     */
    global Integer timeout {
        get {
            if (timeout == null) {
                timeout = DEFAULT_REQUEST_TIMEOUT;
            }
            return timeout;
        }
        private set;
    }

    private final GraphQLOperation node;
    private String stringNode;
    private Map<String, Object> variables;

    /**
     * @description Create an instance using the string GraphQL request
     * @param stringNode String GraphQL request
     * @throws GraphQLRequestException If the provided string is not a GraphQL request or if it is a subscription
     */
    global GraphQLRequest(String stringNode) {
        this.stringNode = stringNode;
        this.operation = recognizeOperation(stringNode);
    }

    /**
     * @description Create an instance using a GraphQL node for a specific GraphQL operation (Query or Mutation)
     * @param operation The instance of the `GraphQLOperationType` enum (`Query` or `Mutation`)
     * @param node The instance of the Graph operation node (`GraphQLQuery` or `GraphQLMutation`)
     * @throws GraphQLRequestException If the provided instance is neither `GraphQLQuery` nor `GraphQLMutation`
     */
    global GraphQLRequest(GraphQLOperation node) {
        this.operation = node.getOperation();
        this.node = node;

        if (this.operation == GraphQLOperationType.Subscription) {
            throw new GraphQLRequestException('The request node should be an either a Query or Mutation node');
        }
    }

    /**
     * @description Add a custom header to the request. For example `Authorization`
     * @param key The header key
     * @param value The header string value
     * @return The current `GraphQLRequest` instance
     */
    global GraphQLRequest withHeader(String key, String value) {
        return withHeaders(new Map<String, String> { key => value });
    }

    /**
     * @description Add multiple custom headers to the request. For example `Authorization`
     * @param headers The Map of headers
     * @return The current `GraphQLRequest` instance
     */
    global GraphQLRequest withHeaders(Map<String, String> headers) {
        this.headers.putAll(headers);
        return this;
    }

    /**
     * @description Set a timeout for the GraphQL request
     * @param timeout The timeout in milliseconds
     * @return The current `GraphQLRequest` instance
     */
    global GraphQLRequest withTimeout(Integer timeout) {
        this.timeout = timeout;
        return this;
    }

    /**
     * @description Add a variable definition value to the request
     * @param name The varibale name
     * @param value The varibale actual value
     * @return The current `GraphQLRequest` instance
     */
    global GraphQLRequest withVariable(String name, Object value) {
        return withVariables(new Map<String, Object> { name => value });
    }

    /**
     * @description Add multiple variable definition values to the request
     * @param variables The Map of varibales
     * @return The current `GraphQLRequest` instance
     */
    global GraphQLRequest withVariables(Map<String, Object> variables) {
        if (this.variables == null) {
            this.variables = new Map<String, Object>();
        }
        this.variables.putAll(variables);
        return this;
    }

    /**
     * @description Serialize the request to JSON format
     * @return The JSON representation of the request
     */
    global override String toString() {
        return toString(false);
    }

    /**
     * @description Serialize the request to JSON format
     * @param pretty Flag that serializes the request pretty if `true`
     * @return The JSON representation of the request
     */
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

    private GraphQLOperationType recognizeOperation(String stringNode) {
        List<String> tokens = stringNode?.split('\\W');
        if (tokens == null || tokens.isEmpty()) {
            throw new GraphQLRequestException('The provided string node is empty or in invalid format');
        }

        String operationName = tokens.get(GraphQLConstants.FIRST_ELEMENT);
        if (operationName == GraphQLOperationType.Mutation.name().toLowerCase()) {
            return GraphQLOperationType.Mutation;
        } else if (operationName == GraphQLOperationType.Subscription.name().toLowerCase()) {
            throw new GraphQLRequestException('This operation is not allowed for GraphQL request');
        } else {
            return GraphQLOperationType.Query;
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

    private class GraphQLRequestException extends Exception {}
}
