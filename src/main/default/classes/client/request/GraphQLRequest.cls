/**
 * @description Represents the GraphQL request for the client
 */
global class GraphQLRequest {
    /**
     * @description The request GraphQL operation: Query or Mutation
     */
    global final GraphQLOperation operation;

    /**
     * @description The request custom headers
     */
    global final Map<String, String> customHeaders = new Map<String, String>();

    private final GraphQLOperationNode node;
    private String stringNode;
    private Map<String, Object> variables;

    /**
     * @description Create an instance using the string GraphQL request
     * @param stringNode String GraphQL request
     * @throws GraphQLRequestException If the provided string is not a GraphQL request
     */
    global GraphQLRequest(String stringNode) {
        this.stringNode = stringNode;
        this.operation = recognizeOperation(stringNode);
    }

    /**
     * @description Create an instance using a GraphQL node
     * @param node The instance of the Graph operation node (`GraphQLQueryNode` or `GraphQLMutationNode`)
     * @throws GraphQLRequestException If the provided instance is neither `GraphQLQueryNode` nor `GraphQLMutationNode`
     */
    global GraphQLRequest(GraphQLOperationNode node) {
        this(null, node);
    }

    /**
     * @description Create an instance using a GraphQL node for a specific GraphQL operation (Query or Mutation)
     * @param operation The instance of the `GraphQLOperation` enum (`Query` or `Mutation`)
     * @param node The instance of the Graph operation node (`GraphQLQueryNode` or `GraphQLMutationNode`)
     * @throws GraphQLRequestException If the provided instance is neither `GraphQLQueryNode` nor `GraphQLMutationNode`
     */
    global GraphQLRequest(GraphQLOperation operation, GraphQLOperationNode node) {
        this.operation = operation == null ? GraphQLOperation.Query : operation;
        this.node = node;

        if (!(node instanceof IGraphQLRequestBuilder)) {
            throw new GraphQLRequestException('The request node should be an instance of IGraphQLRequestBuilder');
        }
    }

    /**
     * @description Add a custom header to the request. For example `Authorization`
     * @param key The header key
     * @param value The header string value
     * @return The current `GraphQLRequest` instance
     */
    global GraphQLRequest withHeader(String key, String value) {
        return withHeaders(new Map<String, String>{ key => value });
    }

    /**
     * @description Add multiple custom headers to the request. For example `Authorization`
     * @param headers The Map of headers
     * @return The current `GraphQLRequest` instance
     */
    global GraphQLRequest withHeaders(Map<String, String> headers) {
        customHeaders.putAll(headers);
        return this;
    }

    /**
     * @description Add a variable definition value to the request
     * @param name The varibale name
     * @param value The varibale actual value
     * @return The current `GraphQLRequest` instance
     */
    global GraphQLRequest withVariable(String name, Object value) {
        return withVariables(new Map<String, Object>{ name => value });
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

    private GraphQLOperation recognizeOperation(String stringNode) {
        List<String> tokens = stringNode?.split('\\W');
        if (tokens == null || tokens.isEmpty()) {
            throw new GraphQLRequestException('The provided string node is empty or in invalid format');
        }

        String operationName = tokens.get(GraphQLConstants.FIRST_ELEMENT);
        if (operationName == GraphQLOperation.Mutation.name().toLowerCase()) {
            return GraphQLOperation.Mutation;
        } else if (operationName == GraphQLOperation.Subscription.name().toLowerCase()) {
            throw new GraphQLRequestException('This operation is not allowed for GraphQL request');
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
