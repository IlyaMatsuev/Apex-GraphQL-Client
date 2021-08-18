@IsTest(IsParallel=true)
private class GraphQLRequestTest {
    @IsTest
    private static void requestWithoutOperationTest() {
        GraphQLQueryNode node = new GraphQLQueryNode(new List<String>{ 'field1', 'field2' });

        GraphQLRequest request = new GraphQLRequest(node);

        System.assertEquals(GraphQLOperation.Query, request.operation);
        System.assertEquals('{"query":"query{field1,field2}"}', request.toString());
        System.assertEquals(
            '{\n  "query" : "query {\\n  field1\\n  field2\\n}"\n}',
            request.toString(true)
        );
    }

    @IsTest
    private static void requestWithIncorrectRootNodeTypeNegativeTest() {
        Exception error;
        try {
            new GraphQLRequest(new GraphQLNode());
        } catch (Exception err) {
            error = err;
        }

        System.assert(error != null);
        System.assertEquals(Label.RequestNodeOfIncorrectTypeError, error.getMessage());
    }

    @IsTest
    private static void requestWithOperationTest() {
        GraphQLOperation operation = GraphQLOperation.Mutation;
        GraphQLMutationNode node = new GraphQLMutationNode(new List<String>{ 'field1', 'field2' });

        GraphQLRequest request = new GraphQLRequest(operation, node);

        System.assertEquals(operation, request.operation);
        System.assertEquals('{"query":"mutation{field1,field2}"}', request.toString());
        System.assertEquals(
            '{\n  "query" : "mutation {\\n  field1\\n  field2\\n}"\n}',
            request.toString(true)
        );
    }

    @IsTest
    private static void requestWithHeaderTest() {
        GraphQLOperation operation = GraphQLOperation.Mutation;
        GraphQLMutationNode node = new GraphQLMutationNode(new List<String>{ 'field1', 'field2' });

        GraphQLRequest request = new GraphQLRequest(node).withHeader('Authorization', 'token');

        System.assertEquals(1, request.customHeaders.size());
        System.assertEquals('token', request.customHeaders.get('Authorization'));
    }

    @IsTest
    private static void requestWithVariableTest() {
        GraphQLOperation operation = GraphQLOperation.Mutation;
        GraphQLMutationNode node = new GraphQLMutationNode(new List<String>{ 'field1', 'field2' });

        GraphQLRequest request = new GraphQLRequest(node).withVariable('param', 'value');

        System.assertEquals(
            '{"variables":{"param":"value"},"query":"mutation{field1,field2}"}',
            request.toString()
        );
    }
}
