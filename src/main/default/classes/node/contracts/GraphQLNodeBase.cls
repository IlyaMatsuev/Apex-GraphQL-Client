global abstract class GraphQLNodeBase {
    global final String name;
    global final List<GraphQLNode> nodes = new List<GraphQLNode>();

    private IGraphQLNodeParser parser {
        get {
            if (parser == null) {
                String parserImplTypeName = GraphQLConfigurationManager.getConfiguration(
                    GraphQLConfiguration.NodeParserImplementation
                );
                parser = (IGraphQLNodeParser) Type.forName(parserImplTypeName)?.newInstance();
            }
            return parser;
        }
        set;
    }

    protected GraphQLNodeBase(String name, List<String> fields) {
        this(name, new List<GraphQLNode>(), fields);
    }

    protected GraphQLNodeBase(String name, List<GraphQLNode> nodes) {
        this(name, nodes, new List<String>());
    }

    protected GraphQLNodeBase(String name, List<GraphQLNode> nodes, List<String> fields) {
        this.name = name;
        this.nodes.addAll(nodes);

        if (!fields.isEmpty()) {
            addFields(fields);
        }
    }

    global virtual Boolean hasNode(GraphQLNode node) {
        return hasNodes(new List<GraphQLNode>{ node });
    }

    global virtual Boolean hasNodes(GraphQLNode[] nodes) {
        for (GraphQLNode existingNode : this.nodes) {
            for (GraphQLNode node : nodes) {
                if (existingNode.name == node.name) {
                    return true;
                }
            }
        }
        return false;
    }

    global Boolean hasNodes() {
        return !nodes.isEmpty();
    }

    protected virtual GraphQLNodeBase addFields(String[] fields) {
        List<GraphQLNode> nodes = new List<GraphQLNode>();
        for (String field : fields) {
            nodes.add(new GraphQLNode(field));
        }
        return addNodes(nodes);
    }

    protected virtual GraphQLNodeBase addNodes(GraphQLNode[] nodes) {
        for (GraphQLNode node : nodes) {
            if (!hasNode(node)) {
                this.nodes.add(node);
            }
        }
        return this;
    }

    protected virtual GraphQLNodeBase addFragments(String[] fragmentNames) {
        List<String> fields = new List<String>();
        for (String fragmentName : fragmentNames) {
            fields.add(CommonConstants.DOT.repeat(3) + fragmentName);
        }
        return addFields(fields);
    }

    global String build() {
        return build(false);
    }

    global String build(Boolean pretty) {
        return parser.toString(this, pretty);
    }

    private class GraphQLNodeBaseException extends Exception {
    }
}
