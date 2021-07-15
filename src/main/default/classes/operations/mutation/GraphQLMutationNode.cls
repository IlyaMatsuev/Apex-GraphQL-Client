public class GraphQLMutationNode extends GraphQLNodeBase implements IGraphQLRequestBuilder {

    private static final GraphQLOperation Operation = GraphQLOperation.Mutation;

    public GraphQLMutationNode() {
        this(CommonConstants.EMPTY);
    }

    public GraphQLMutationNode(String alias) {
        this(alias, new List<String>());
    }

    public GraphQLMutationNode(List<String> fields) {
        this(null, fields);
    }

    public GraphQLMutationNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    public GraphQLMutationNode(String alias, List<String> fields) {
        super(getNodeName(Operation, alias), fields);
    }

    public GraphQLMutationNode(String alias, List<GraphQLNode> nodes) {
        super(getNodeName(Operation, alias), nodes);
    }


    public GraphQLMutationNode withField(String field) {
        return withFields(new String[] { field });
    }

    public GraphQLMutationNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    public GraphQLMutationNode withNode(GraphQLNode node) {
        return withNodes(new GraphQLNode[] { node });
    }

    public GraphQLMutationNode withNodes(GraphQLNode[] nodes) {
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
