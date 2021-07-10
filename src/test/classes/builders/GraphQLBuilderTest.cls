@IsTest
public class GraphQLBuilderTest {

    /**
     * GraphQL Query tests below
     */

    @IsTest
    public static void simpleQueryPositiveRequestTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> { new GraphQLNode('field1'), new GraphQLNode('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLRequest requet = new GraphQLQueryBuilder()
            .withNodes(nodes)
            .withFields(fields)
            .withField('field3')
            .build();

        System.assert(requet != null);
        System.assertEquals(GraphQLRequestType.Query, requet.type);
        System.assertEquals(nodes.size() + fields.size(), requet.asNode().asList().size());
        System.assertEquals('query{field1,field2,field3,field4}', requet.asString());
        System.assertEquals(
            'query {\n  field1\n  field2\n  field3\n  field4\n}',
            requet.asString(true)
        );
    }

    @IsTest
    public static void queryWithNestingPositiveRequestTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('field1'),
            new GraphQLNode('field2', new List<GraphQLNode> { new GraphQLNode('field21'), new GraphQLNode('field22') }),
            new GraphQLNode('field3')
        };

        GraphQLRequest requet = new GraphQLQueryBuilder()
            .withNodes(nodes)
            .withField('field1')
            .build();

        System.assert(requet != null);
        System.assertEquals(GraphQLRequestType.Query, requet.type);
        System.assertEquals(nodes.size(), requet.asNode().asList().size());
        System.assertEquals(
            'query{field1,field2{field21,field22},field3}',
            requet.asString()
        );
        System.assertEquals(
            'query {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            requet.asString(true)
        );
    }

    /**
     * GraphQL Mutation tests below
     */

    @IsTest
    public static void simpleMutationPositiveRequestTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> { new GraphQLNode('field1'), new GraphQLNode('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLRequest requet = new GraphQLMutationBuilder()
            .withNodes(nodes)
            .withField(fields.get(0))
            .withField(fields.get(1))
            .withField('field3')
            .build();

        System.assert(requet != null);
        System.assertEquals(GraphQLRequestType.Mutation, requet.type);
        System.assertEquals(nodes.size() + fields.size(), requet.asNode().asList().size());
        System.assertEquals('mutation{field1,field2,field3,field4}', requet.asString());
        System.assertEquals(
            'mutation {\n  field1\n  field2\n  field3\n  field4\n}',
            requet.asString(true)
        );
    }

    @IsTest
    public static void mutationWithNestingPositiveRequestTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('field1'),
            new GraphQLNode('field2', new List<GraphQLNode> { new GraphQLNode('field21'), new GraphQLNode('field22') }),
            new GraphQLNode('field3')
        };

        GraphQLRequest requet = new GraphQLMutationBuilder()
            .withNodes(nodes)
            .withField('field1')
            .build();

        System.assert(requet != null);
        System.assertEquals(GraphQLRequestType.Mutation, requet.type);
        System.assertEquals(nodes.size(), requet.asNode().asList().size());
        System.assertEquals(
            'mutation{field1,field2{field21,field22},field3}',
            requet.asString()
        );
        System.assertEquals(
            'mutation {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            requet.asString(true)
        );
    }
}
