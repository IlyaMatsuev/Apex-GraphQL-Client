global class GraphQLMutationNode extends GraphQLOperationNode implements IGraphQLRequestBuilder {
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

    global GraphQLMutationNode(String alias, GraphQLNode node) {
        this(alias, new List<GraphQLNode>{ node });
    }

    global GraphQLMutationNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    global GraphQLMutationNode(String alias, List<GraphQLNode> nodes) {
        super(alias, nodes);
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

    global GraphQLMutationNode withFragment(GraphQLFragmentNode fragment) {
        return withFragments(new List<GraphQLFragmentNode>{ fragment });
    }

    global GraphQLMutationNode withFragments(GraphQLFragmentNode[] fragments) {
        addFragments(fragments);
        return this;
    }

    global GraphQLMutationNode withVariable(String name, String typeDefinition) {
        addVariable(name, typeDefinition);
        return this;
    }

    global GraphQLRequest buildRequest() {
        return asRequest();
    }

    global override GraphQLOperation getOperation() {
        return GraphQLOperation.Mutation;
    }
}
