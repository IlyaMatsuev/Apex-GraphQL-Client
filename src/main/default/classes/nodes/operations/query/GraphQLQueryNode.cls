global class GraphQLQueryNode extends GraphQLOperationNode implements IGraphQLRequestBuilder {
    global GraphQLQueryNode() {
        this(GraphQLConstants.EMPTY);
    }

    global GraphQLQueryNode(String alias) {
        this(alias, new List<String>());
    }

    global GraphQLQueryNode(GraphQLNode node) {
        this(new List<GraphQLNode>{ node });
    }

    global GraphQLQueryNode(List<String> fields) {
        this(null, fields);
    }

    global GraphQLQueryNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    global GraphQLQueryNode(String alias, GraphQLNode node) {
        this(alias, new List<GraphQLNode>{ node });
    }

    global GraphQLQueryNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    global GraphQLQueryNode(String alias, List<GraphQLNode> nodes) {
        super(alias, nodes);
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

    global GraphQLQueryNode withFragment(GraphQLFragmentNode fragment) {
        return withFragments(new List<GraphQLFragmentNode>{ fragment });
    }

    global GraphQLQueryNode withFragments(GraphQLFragmentNode[] fragments) {
        addFragments(fragments);
        return this;
    }

    global GraphQLQueryNode withVariable(String name, String typeDefinition) {
        addVariable(name, typeDefinition);
        return this;
    }

    global GraphQLRequest buildRequest() {
        return asRequest();
    }

    global override GraphQLOperation getOperation() {
        return GraphQLOperation.Query;
    }
}
