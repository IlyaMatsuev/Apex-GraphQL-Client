public abstract class GraphQLBuilder extends GraphQLNode implements IGraphQLBuilder {

    public GraphQLRequestType requestType { get; private set; }

    public GraphQLBuilder() {
        this(GraphQLRequestType.Query);
    }

    public GraphQLBuilder(List<GraphQLNode> nodes) {
        this(GraphQLRequestType.Query, nodes);
    }

    protected GraphQLBuilder(GraphQLRequestType requestType) {
        this(requestType, new List<GraphQLNode>());
    }

    protected GraphQLBuilder(GraphQLRequestType requestType, List<GraphQLNode> nodes) {
        super(requestType.name().toLowerCase(), nodes);
        this.requestType = requestType;
    }

    public virtual GraphQLBuilder withField(String field) {
        return withNode(new GraphQLNode(field));
    }

    public virtual GraphQLBuilder withFields(String[] fields) {
        List<GraphQLNode> nodes = new List<GraphQLNode>();
        for (String field : fields) {
            nodes.add(new GraphQLNode(field));
        }
        return withNodes(nodes);
    }

    public virtual GraphQLBuilder withNode(GraphQLNode node) {
        return withNodes(new GraphQLNode[] { node });
    }

    public virtual GraphQLBuilder withNodes(GraphQLNode[] nodes) {
        add(nodes);
        return this;
    }

    public GraphQLRequest build() {
        return new GraphQLRequest(requestType, this);
    }
}
