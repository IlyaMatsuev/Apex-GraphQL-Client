global abstract class GraphQLBaseNode {
    global final String name;
    global final List<GraphQLNode> nodes = new List<GraphQLNode>();

    protected GraphQLBaseNode(String name, List<String> fields) {
        this(name, new List<GraphQLNode>(), fields);
    }

    protected GraphQLBaseNode(String name, List<GraphQLNode> nodes) {
        this(name, nodes, new List<String>());
    }

    protected GraphQLBaseNode(String name, List<GraphQLNode> nodes, List<String> fields) {
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

    protected virtual GraphQLBaseNode addFields(String[] fields) {
        List<GraphQLNode> nodes = new List<GraphQLNode>();
        for (String field : fields) {
            nodes.add(new GraphQLNode(field));
        }
        return addNodes(nodes);
    }

    protected virtual GraphQLBaseNode addNodes(GraphQLNode[] nodes) {
        for (GraphQLNode node : nodes) {
            if (!hasNode(node)) {
                this.nodes.add(node);
            }
        }
        return this;
    }

    protected virtual GraphQLBaseNode addFragments(String[] fragmentNames) {
        List<String> fields = new List<String>();
        for (String fragmentName : fragmentNames) {
            fields.add(GraphQLConstants.DOT.repeat(3) + fragmentName);
        }
        return addFields(fields);
    }

    global String build() {
        return build(false);
    }

    global String build(Boolean pretty) {
        return getParser().parse(this, pretty);
    }

    global abstract IGraphQLParser getParser();
}
