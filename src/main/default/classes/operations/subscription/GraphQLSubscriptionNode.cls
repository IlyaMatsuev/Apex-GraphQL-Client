global class GraphQLSubscriptionNode extends GraphQLOperationNode {
    global GraphQLSubscriptionNode() {
        this(CommonConstants.EMPTY);
    }

    global GraphQLSubscriptionNode(String alias) {
        this(alias, new List<String>());
    }

    global GraphQLSubscriptionNode(GraphQLNode node) {
        this(new List<GraphQLNode>{ node });
    }

    global GraphQLSubscriptionNode(List<String> fields) {
        this(null, fields);
    }

    global GraphQLSubscriptionNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    global GraphQLSubscriptionNode(String alias, GraphQLNode node) {
        this(alias, new List<GraphQLNode>{ node });
    }

    global GraphQLSubscriptionNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    global GraphQLSubscriptionNode(String alias, List<GraphQLNode> nodes) {
        super(alias, nodes);
    }

    global GraphQLSubscriptionNode withField(String field) {
        return withFields(new List<String>{ field });
    }

    global GraphQLSubscriptionNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    global GraphQLSubscriptionNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode>{ node });
    }

    global GraphQLSubscriptionNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    global GraphQLSubscriptionNode withVariable(String name, String typeDefinition) {
        addVariable(name, typeDefinition);
        return this;
    }

    global override GraphQLOperation getOperation() {
        return GraphQLOperation.Subscription;
    }
}
