@IsTest(IsParallel = true)
private class GraphQLRequestTest {
    
    @IsTest
    private static void requestWithoutOperationTest() {
        GraphQLQueryNode node = new GraphQLQueryNode(new List<String> { 'field1', 'field2' });

        GraphQLRequest request = new GraphQLRequest(node);

        System.assertEquals(GraphQLOperation.Query, request.operation);
        System.assertEquals('query{field1,field2}', request.toString());
        System.assertEquals('query {\n  field1\n  field2\n}', request.toString(true));
    }

    @IsTest
    private static void requestWithIncorrectRootNodeTypeNegativeTest() {
        Exception error;
        try {
            new GraphQLRequest(new GraphQLNode());
        } catch(Exception err) {
            error = err;
        }

        System.assert(error != null);
        System.assertEquals(Label.RequestNodeOfIncorrectTypeError, error.getMessage());
    }

    @IsTest
    private static void requestWithOperationTest() {
        GraphQLOperation operation = GraphQLOperation.Mutation;
        GraphQLMutationNode node = new GraphQLMutationNode(new List<String> { 'field1', 'field2' });

        GraphQLRequest request = new GraphQLRequest(operation, node);

        System.assertEquals(operation, request.operation);
        System.assertEquals('mutation{field1,field2}', request.toString());
        System.assertEquals('mutation {\n  field1\n  field2\n}', request.toString(true));
    }
}
