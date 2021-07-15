public class GraphQLNode extends GraphQLNodeBase {

    public GraphQLNode() {
        this(CommonConstants.EMPTY);
    }

    public GraphQLNode(String name) {
        this(name, new List<String>());
    }

    public GraphQLNode(List<GraphQLNode> nodes) {
        this(CommonConstants.EMPTY, nodes);
    }

    public GraphQLNode(List<String> fields) {
        this(CommonConstants.EMPTY, fields);
    }

    public GraphQLNode(String name, List<GraphQLNode> nodes) {
        super(name, nodes);
    }

    public GraphQLNode(String name, List<String> fields) {
        super(name, fields);
    }


    public GraphQLNode withField(String field) {
        return withFields(new String[] { field });
    }

    public GraphQLNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    public GraphQLNode withNode(GraphQLNode node) {
        return withNodes(new GraphQLNode[] { node });
    }

    public GraphQLNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    public GraphQLNode withArgument(String key, Object value) {
        return withArgument(new GraphQLArgument(key, value));
    }

    public GraphQLNode withArgument(GraphQLArgument argument) {
        return withArguments(new GraphQLArgument[] { argument });
    }

    public GraphQLNode withArguments(GraphQLArgument[] arguments) {
        addArguments(arguments);
        return this;
    }
}
