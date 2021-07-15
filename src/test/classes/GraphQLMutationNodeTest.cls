@IsTest(IsParallel = true)
public class GraphQLMutationNodeTest {

    @IsTest
    public static void buildMutationPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> { new GraphQLNode('field1'), new GraphQLNode('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLMutationNode mutation = new GraphQLMutationNode()
            .withNode(nodes.get(0))
            .withNode(nodes.get(1))
            .withField(fields.get(0))
            .withField(fields.get(1));

        System.assert(mutation != null);
        System.assertEquals('mutation', mutation.name);
        System.assertEquals(nodes.size() + fields.size(), mutation.nodes.size());
        System.assertEquals('mutation{field1,field2,field3,field4}', mutation.build());
        System.assertEquals(
            'mutation {\n  field1\n  field2\n  field3\n  field4\n}',
            mutation.build(true)
        );
    }

    @IsTest
    public static void buildMutationWithChildNodesPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('field1'),
            new GraphQLNode('field2', new List<GraphQLNode> { new GraphQLNode('field21'), new GraphQLNode('field22') }),
            new GraphQLNode('field3')
        };

        GraphQLMutationNode mutation = new GraphQLMutationNode('TestMutation', nodes);

        System.assert(mutation != null);
        System.assertEquals('mutation TestMutation', mutation.name);
        System.assertEquals(nodes.size(), mutation.nodes.size());
        System.assertEquals(
            'mutation TestMutation{field1,field2{field21,field22},field3}',
            mutation.build()
        );
        System.assertEquals(
            'mutation TestMutation {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            mutation.build(true)
        );
    }
}
