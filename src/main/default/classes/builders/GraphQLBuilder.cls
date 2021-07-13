public virtual class GraphQLBuilder extends GraphQLNode implements IGraphQLBuilder {

    private IGraphQLRequestBuilderFactory requestBuilderFactory {
        get {
            if (requestBuilderFactory == null) {
                requestBuilderFactory = new GraphQLRequestBuilderFactory();
            }
            return requestBuilderFactory;
        }
        set;
    }

    public GraphQLBuilder(String name) {
        this(name, new List<GraphQLNode>());
    }

    public GraphQLBuilder(String name, List<GraphQLNode> nodes) {
        super(name, nodes);
    }


    public virtual GraphQLBuilder withField(String field) {
        return withFields(new String[] { field });
    }

    public virtual GraphQLBuilder withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    public virtual GraphQLBuilder withNode(GraphQLNode node) {
        return withNodes(new GraphQLNode[] { node });
    }

    public virtual GraphQLBuilder withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    public virtual GraphQLBuilder withArgument(String key, Object value) {
        return withArgument(new GraphQLArgument(key, value));
    }

    public virtual GraphQLBuilder withArgument(GraphQLArgument argument) {
        return withArguments(new GraphQLArgument[] { argument });
    }

    public virtual GraphQLBuilder withArguments(GraphQLArgument[] arguments) {
        addArguments(arguments);
        return this;
    }

    public GraphQLQueryBuilder asQuery() {
        if (this instanceof GraphQLQueryBuilder) {
            return (GraphQLQueryBuilder) this;
        }
        return (GraphQLQueryBuilder) requestBuilderFactory.create(GraphQLOperation.Query, this);
    }

    public GraphQLMutationBuilder asMutation() {
        if (this instanceof GraphQLMutationBuilder) {
            return (GraphQLMutationBuilder) this;
        }
        return (GraphQLMutationBuilder) requestBuilderFactory.create(GraphQLOperation.Mutation, this);
    }

    public GraphQLNode buildNode() {
        return this;
    }
}
