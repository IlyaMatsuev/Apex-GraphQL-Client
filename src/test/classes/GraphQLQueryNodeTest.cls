@IsTest(IsParallel = true)
public class GraphQLQueryNodeTest {

    @IsTest
    public static void buildQueryPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> { new GraphQLNode('field1'), new GraphQLNode('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLQueryNode query = new GraphQLQueryNode()
            .withNode(nodes.get(0))
            .withNode(nodes.get(1))
            .withFields(fields)
            .withField('field3');

        System.assert(query != null);
        System.assertEquals('query', query.name);
        System.assertEquals(nodes.size() + fields.size(), query.nodes.size());
        System.assertEquals('query{field1,field2,field3,field4}', query.build());
        System.assertEquals(
            'query {\n  field1\n  field2\n  field3\n  field4\n}',
            query.build(true)
        );
    }

    @IsTest
    public static void buildQueryWithChildNodesPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('field1'),
            new GraphQLNode('field2', new List<GraphQLNode> { new GraphQLNode('field21'), new GraphQLNode('field22') }),
            new GraphQLNode('field3')
        };

        GraphQLQueryNode query = new GraphQLQueryNode('TestQuery', nodes).withField('field1');

        System.assert(query != null);
        System.assertEquals('query TestQuery', query.name);
        System.assertEquals(nodes.size(), query.nodes.size());
        System.assertEquals(
            'query TestQuery{field1,field2{field21,field22},field3}',
            query.build()
        );
        System.assertEquals(
            'query TestQuery {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            query.build(true)
        );
    }
}
