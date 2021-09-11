global class GraphQLFragmentNode extends GraphQLNodeBase {
    global final String type;

    global GraphQLFragmentNode(String name, String type) {
        this(name, type, new List<GraphQLNode>());
    }

    global GraphQLFragmentNode(String name, String type, List<GraphQLNode> nodes) {
        this(name, type, nodes, new List<String>());
    }

    global GraphQLFragmentNode(String name, String type, List<String> fields) {
        this(name, type, new List<GraphQLNode>(), fields);
    }

    global GraphQLFragmentNode(
        String name,
        String type,
        List<GraphQLNode> nodes,
        List<String> fields
    ) {
        super(name, nodes, fields);
        this.type = type;
    }

    global GraphQLFragmentNode withField(String field) {
        return withFields(new List<String>{ field });
    }

    global GraphQLFragmentNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    global GraphQLFragmentNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode>{ node });
    }

    global GraphQLFragmentNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    global GraphQLFragmentNode withFragment(String fragmentName) {
        return withFragments(new List<String>{ fragmentName });
    }

    global GraphQLFragmentNode withFragments(String[] fragmentNames) {
        addFragments(fragmentNames);
        return this;
    }

    global override IGraphQLParser getParser() {
        return new GraphQLFragmentNodeParser();
    }
}
