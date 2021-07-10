public class GraphQLMutationBuilder extends GraphQLBuilder {

    public GraphQLMutationBuilder() {
        this(new List<GraphQLNode>());
    }

    public GraphQLMutationBuilder(List<GraphQLNode> nodes) {
        super(GraphQLRequestType.Mutation, nodes);
    }
}
