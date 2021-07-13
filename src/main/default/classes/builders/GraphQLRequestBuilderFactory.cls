public class GraphQLRequestBuilderFactory implements IGraphQLRequestBuilderFactory {

    public IGraphQLRequestBuilder create(GraphQLOperation operation, GraphQLNode rootNode) {
        IGraphQLRequestBuilder requestBuilder; 
        switch on operation {
            when Query {
                requestBuilder = new GraphQLQueryBuilder(rootNode);
            }
            when Mutation {
                requestBuilder = new GraphQLMutationBuilder(rootNode);
            }
            when else {
                throw new GraphQLFactoryException(
                    Label.NoRequestBuilderImplError.replace('{0}', operation.name())
                );
            }
        }
        return requestBuilder;
    }
}
