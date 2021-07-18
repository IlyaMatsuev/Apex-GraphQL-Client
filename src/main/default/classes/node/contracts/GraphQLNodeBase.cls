global abstract class GraphQLNodeBase {

    global final String name;
    global final List<GraphQLNode> nodes = new List<GraphQLNode>();
    global final Map<String, GraphQLArgument> arguments = new Map<String, GraphQLArgument>();

    private IGraphQLNodeParser parser {
        get {
            if (parser == null) {
                parser = new GraphQLNodeParser(this);
            }
            return parser;
        }
        set;
    }

    protected GraphQLNodeBase() {
        this(CommonConstants.EMPTY);
    }

    protected GraphQLNodeBase(String name) {
        this(name, new List<GraphQLNode>());
    }

    protected GraphQLNodeBase(String name, List<String> fields) {
        this(name, new List<GraphQLNode>(), fields, new Map<String, GraphQLArgument>());
    }

    protected GraphQLNodeBase(String name, List<GraphQLNode> nodes) {
        this(name, nodes, new Map<String, GraphQLArgument>());
    }

    protected GraphQLNodeBase(String name, List<String> fields, Map<String, GraphQLArgument> arguments) {
        this(name, new List<GraphQLNode>(), fields, arguments);
    }

    protected GraphQLNodeBase(String name, List<GraphQLNode> nodes, Map<String, GraphQLArgument> arguments) {
        this(name, nodes, new List<String>(), arguments);
    }

    protected GraphQLNodeBase(
        String name,
        List<GraphQLNode> nodes,
        List<String> fields,
        Map<String, GraphQLArgument> arguments
    ) {
        this.name = name;
        this.nodes.addAll(nodes);
        this.arguments.putAll(arguments);

        if (!fields.isEmpty()) {
            addFields(fields);
        }
    }

    global virtual Boolean hasNode(GraphQLNode node) {
        return hasNodes(new GraphQLNode[] { node });
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

    global virtual Boolean hasNodes() {
        return !nodes.isEmpty();
    }

    global virtual Boolean hasArguments() {
        return !arguments.isEmpty();
    }

    protected virtual GraphQLNodeBase addField(String field) {
        return addFields(new String[] { field });
    }

    protected virtual GraphQLNodeBase addFields(String[] fields) {
        List<GraphQLNode> nodes = new List<GraphQLNode>();
        for (String field : fields) {
            nodes.add(new GraphQLNode(field));
        }
        return addNodes(nodes);
    }

    protected virtual GraphQLNodeBase addNode(GraphQLNode node) {
        return addNodes(new GraphQLNode[] { node });
    }

    protected virtual GraphQLNodeBase addNodes(GraphQLNode[] nodes) {
        for (GraphQLNode node : nodes) {
            if (!hasNode(node)) {
                this.nodes.add(node);
            }
        }
        return this;
    }

    protected virtual GraphQLNodeBase addArgument(String key, Object value) {
        return addArgument(new GraphQLArgument(key, value));
    }

    protected virtual GraphQLNodeBase addArgument(GraphQLArgument argument) {
        return addArguments(new GraphQLArgument[] { argument });
    }

    protected virtual GraphQLNodeBase addArguments(GraphQLArgument[] arguments) {
        for (GraphQLArgument argument : arguments) {
            this.arguments.put(argument.key, argument);
        }
        return this;
    }

    global String build() {
        return build(false);
    }

    global String build(Boolean pretty) {
        return parser.toString(pretty);
    }
}
