global class GraphQLMutationNode extends GraphQLNodeBase implements IGraphQLRequestBuilder {
    private static final GraphQLOperation Operation = GraphQLOperation.Mutation;

    global GraphQLMutationNode() {
        this(CommonConstants.EMPTY);
    }

    global GraphQLMutationNode(String alias) {
        this(alias, new List<String>());
    }

    global GraphQLMutationNode(GraphQLNode node) {
        this(new List<GraphQLNode>{ node });
    }

    global GraphQLMutationNode(List<String> fields) {
        this(null, fields);
    }

    global GraphQLMutationNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    global GraphQLMutationNode(String alias, List<String> fields) {
        super(getNodeName(Operation, alias), fields);
    }

    global GraphQLMutationNode(String alias, List<GraphQLNode> nodes) {
        super(getNodeName(Operation, alias), nodes);
    }

    global GraphQLMutationNode withField(String field) {
        return withFields(new List<String>{ field });
    }

    global GraphQLMutationNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    global GraphQLMutationNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode>{ node });
    }

    global GraphQLMutationNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    global GraphQLRequest buildRequest() {
        return new GraphQLRequest(Operation, this);
    }

    private static String getNodeName(GraphQLOperation operation, String alias) {
        if (String.isBlank(alias)) {
            return operation.name().toLowerCase();
        }
        return operation.name().toLowerCase() + CommonConstants.SPACE + alias;
    }
}
