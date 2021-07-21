global class GraphQLQueryNode extends GraphQLNodeBase implements IGraphQLRequestBuilder {
    private static final GraphQLOperation Operation = GraphQLOperation.Query;

    global GraphQLQueryNode() {
        this(CommonConstants.EMPTY);
    }

    global GraphQLQueryNode(String alias) {
        this(alias, new List<String>());
    }

    global GraphQLQueryNode(List<String> fields) {
        this(null, fields);
    }

    global GraphQLQueryNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    global GraphQLQueryNode(String alias, List<String> fields) {
        super(getNodeName(Operation, alias), fields);
    }

    global GraphQLQueryNode(String alias, List<GraphQLNode> nodes) {
        super(getNodeName(Operation, alias), nodes);
    }

    global GraphQLQueryNode withField(String field) {
        return withFields(new List<String>{ field });
    }

    global GraphQLQueryNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    global GraphQLQueryNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode>{ node });
    }

    global GraphQLQueryNode withNodes(GraphQLNode[] nodes) {
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
