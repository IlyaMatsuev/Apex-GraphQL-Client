public virtual class GraphQLNode {

    public String name { get; private set; }
    public List<GraphQLNode> nodes { get; private set; }
    public Map<String, GraphQLArgument> arguments { get; private set; }

    public GraphQLNode(String name) {
        this(name, new List<GraphQLNode>());
    }

    public GraphQLNode(String name, GraphQLNode node) {
        this(name, new List<GraphQLNode> { node });
    }

    public GraphQLNode(String name, List<GraphQLNode> nodes) {
        this(name, nodes, new Map<String, GraphQLArgument>());
    }

    public GraphQLNode(String name, List<String> fields) {
        this(name, new List<GraphQLNode>(), fields, new Map<String, GraphQLArgument>());
    }

    public GraphQLNode(String name, List<GraphQLNode> nodes, Map<String, GraphQLArgument> arguments) {
        this(name, nodes, new List<String>(), arguments);
    }
    
    public GraphQLNode(
        String name,
        List<GraphQLNode> nodes,
        List<String> fields,
        Map<String, GraphQLArgument> arguments
    ) {
        this.name = name;
        this.nodes = nodes;
        this.arguments = arguments;

        if (!fields.isEmpty()) {
            addFields(fields);
        }
    }

    public Boolean hasNode(GraphQLNode node) {
        return hasNodes(new GraphQLNode[] { node });
    }

    public Boolean hasNodes(GraphQLNode[] nodes) {
        for (GraphQLNode existingNode : this.nodes) {
            for (GraphQLNode node : nodes) {
                if (existingNode.name == node.name) {
                    return true;
                }
            }
        }
        return false;
    }

    public Boolean hasNodes() {
        return !this.nodes.isEmpty();
    }

    public Boolean hasArguments() {
        return !this.arguments.isEmpty();
    }

    protected GraphQLNode addField(String field) {
        return addFields(new String[] { field });
    }

    protected GraphQLNode addFields(String[] fields) {
        List<GraphQLNode> nodes = new List<GraphQLNode>();
        for (String field : fields) {
            nodes.add(new GraphQLNode(field));
        }
        return addNodes(nodes);
    }

    protected GraphQLNode addNode(GraphQLNode node) {
        return addNodes(new GraphQLNode[] { node });
    }

    protected GraphQLNode addNodes(GraphQLNode[] nodes) {
        for (GraphQLNode node : nodes) {
            if (!hasNode(node)) {
                this.nodes.add(node);
            }
        }
        return this;
    }

    protected GraphQLNode addArgument(GraphQLArgument argument) {
        return addArguments(new GraphQLArgument[] { argument });
    }

    protected GraphQLNode addArguments(GraphQLArgument[] arguments) {
        for (GraphQLArgument argument : arguments) {
            this.arguments.put(argument.key, argument);
        }
        return this;
    }
}
