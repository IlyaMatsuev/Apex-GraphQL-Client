public class GraphQLQueryNode extends GraphQLNodeBase implements IGraphQLRequestBuilder {

    private static final GraphQLOperation Operation = GraphQLOperation.Query;

    public GraphQLQueryNode() {
        this(CommonConstants.EMPTY);
    }

    public GraphQLQueryNode(String alias) {
        this(alias, new List<String>());
    }

    public GraphQLQueryNode(List<String> fields) {
        this(null, fields);
    }

    public GraphQLQueryNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    public GraphQLQueryNode(String alias, List<String> fields) {
        super(getNodeName(Operation, alias), fields);
    }

    public GraphQLQueryNode(String alias, List<GraphQLNode> nodes) {
        super(getNodeName(Operation, alias), nodes);
    }


    public GraphQLQueryNode withField(String field) {
        return withFields(new String[] { field });
    }

    public GraphQLQueryNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    public GraphQLQueryNode withNode(GraphQLNode node) {
        return withNodes(new GraphQLNode[] { node });
    }

    public GraphQLQueryNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    public GraphQLRequest buildRequest() {
        return new GraphQLRequest(Operation, this);
    }


    private static String getNodeName(GraphQLOperation operation, String alias) {
        if (String.isBlank(alias)) {
            return operation.name().toLowerCase();
        }
        return operation.name().toLowerCase() + CommonConstants.SPACE + alias;
    }
}
