global abstract class GraphQLOperationNode extends GraphQLNodeBase {
    global final Map<String, String> variables = new Map<String, String>();

    protected GraphQLOperationNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    protected GraphQLOperationNode(String alias, List<GraphQLNode> nodes) {
        super(alias, nodes);
    }

    global Boolean hasVariables() {
        return !variables.isEmpty();
    }

    protected GraphQLRequest asRequest() {
        return new GraphQLRequest(getOperation(), this);
    }

    protected virtual GraphQLOperationNode addVariable(String name, String typeDefinition) {
        this.variables.put(name, typeDefinition);
        return this;
    }

    global abstract GraphQLOperation getOperation();
}
