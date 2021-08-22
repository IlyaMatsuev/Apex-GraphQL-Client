global class GraphQLNode extends GraphQLNodeBase {
    global String alias { get; private set; }
    global final Map<String, GraphQLArgument> arguments = new Map<String, GraphQLArgument>();

    global GraphQLNode() {
        this(CommonConstants.EMPTY);
    }

    global GraphQLNode(String name) {
        this(name, new List<String>());
    }

    global GraphQLNode(List<GraphQLNode> nodes) {
        this(CommonConstants.EMPTY, nodes);
    }

    global GraphQLNode(List<String> fields) {
        this(CommonConstants.EMPTY, fields);
    }

    global GraphQLNode(String name, List<GraphQLNode> nodes) {
        super(name, nodes);
    }

    global GraphQLNode(String name, List<String> fields) {
        super(name, fields);
    }

    global Boolean hasArguments() {
        return !arguments.isEmpty();
    }

    global GraphQLNode byAlias(String alias) {
        this.alias = alias;
        return this;
    }

    global GraphQLNode withField(String field) {
        return withFields(new List<String>{ field });
    }

    global GraphQLNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    global GraphQLNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode>{ node });
    }

    global GraphQLNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    global GraphQLNode withArgument(String key, Object value) {
        return withArgument(new GraphQLArgument(key, value));
    }

    global GraphQLNode withArgument(GraphQLArgument argument) {
        return withArguments(new List<GraphQLArgument>{ argument });
    }

    global GraphQLNode withArguments(GraphQLArgument[] arguments) {
        for (GraphQLArgument argument : arguments) {
            this.arguments.put(argument.key, argument);
        }
        return this;
    }

    global GraphQLQueryNode asQuery() {
        return new GraphQLQueryNode(this.name, this.nodes);
    }

    global GraphQLMutationNode asMutation() {
        return new GraphQLMutationNode(this.name, this.nodes);
    }

    global GraphQLSubscriptionNode asSubscription() {
        return new GraphQLSubscriptionNode(this.name, this.nodes);
    }
}
