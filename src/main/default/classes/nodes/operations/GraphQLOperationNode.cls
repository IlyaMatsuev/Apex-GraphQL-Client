global abstract class GraphQLOperationNode extends GraphQLBaseNode {
    global final Map<String, String> variables = new Map<String, String>();
    global final List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode>();

    protected GraphQLOperationNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    protected GraphQLOperationNode(String alias, List<GraphQLNode> nodes) {
        super(alias, nodes);
    }

    global Boolean hasVariables() {
        return !variables.isEmpty();
    }

    global Boolean hasFragments() {
        return !fragments.isEmpty();
    }

    global override IGraphQLParser getParser() {
        return new GraphQLOperationNodeParser();
    }

    global abstract GraphQLOperation getOperation();

    protected GraphQLOperationNode addFragments(List<GraphQLFragmentNode> fragments) {
        this.fragments.addAll(fragments);
        return this;
    }

    protected GraphQLRequest asRequest() {
        return new GraphQLRequest(getOperation(), this);
    }

    protected virtual GraphQLOperationNode addVariable(String name, String typeDefinition) {
        this.variables.put(name, typeDefinition);
        return this;
    }
}
