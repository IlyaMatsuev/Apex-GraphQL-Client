public class GraphQLQueryBuilder extends GraphQLBuilder {

    public GraphQLQueryBuilder() {
        this(new List<GraphQLNode>());
    }

    public GraphQLQueryBuilder(List<GraphQLNode> nodes) {
        super(GraphQLRequestType.Query, nodes);
    }
}
