@IsTest(IsParallel=true)
private class GraphQLMutationNodeTest {
    @IsTest
    private static void emptyMutationTest() {
        GraphQLMutationNode node = new GraphQLMutationNode();

        System.assertEquals(GraphQLOperation.Mutation.name().toLowerCase(), node.name);
        System.assertEquals(0, node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void namedMutationTest() {
        String nodeName = 'Test';

        GraphQLMutationNode node = new GraphQLMutationNode(nodeName);

        System.assertEquals(
            GraphQLOperation.Mutation.name().toLowerCase() +
            CommonConstants.SPACE +
            nodeName,
            node.name
        );
        System.assertEquals(0, node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void emptyMutationWithChildNodeTest() {
        GraphQLNode childNode = new GraphQLNode('node1');

        GraphQLMutationNode node = new GraphQLMutationNode(childNode);

        System.assertEquals(GraphQLOperation.Mutation.name().toLowerCase(), node.name);
        System.assertEquals(1, node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void emptyMutationWithChildNodesTest() {
        List<GraphQLNode> childNodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLMutationNode node = new GraphQLMutationNode(childNodes);

        System.assertEquals(GraphQLOperation.Mutation.name().toLowerCase(), node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void namedMutationWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLMutationNode node = new GraphQLMutationNode(nodeName, new GraphQLNode('node1'));

        System.assertEquals(
            GraphQLOperation.Mutation.name().toLowerCase() +
            CommonConstants.SPACE +
            nodeName,
            node.name
        );
        System.assertEquals(1, node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void namedMutationWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLNode> childNodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLMutationNode node = new GraphQLMutationNode(nodeName, childNodes);

        System.assertEquals(
            GraphQLOperation.Mutation.name().toLowerCase() +
            CommonConstants.SPACE +
            nodeName,
            node.name
        );
        System.assertEquals(childNodes.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void emptyMutationWithFieldsTest() {
        List<String> fields = new List<String>{ 'field1', 'field2' };

        GraphQLMutationNode node = new GraphQLMutationNode(fields);

        System.assertEquals(GraphQLOperation.Mutation.name().toLowerCase(), node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void namedMutationWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String>{ 'field1', 'field2' };

        GraphQLMutationNode node = new GraphQLMutationNode(nodeName, fields);

        System.assertEquals(
            GraphQLOperation.Mutation.name().toLowerCase() +
            CommonConstants.SPACE +
            nodeName,
            node.name
        );
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void mutationWithFieldTest() {
        String fieldName = 'field1';

        GraphQLMutationNode node = new GraphQLMutationNode().withField(fieldName);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void mutationWithFieldsTest() {
        List<String> fields = new List<String>{ 'field1', 'field2' };

        GraphQLMutationNode node = new GraphQLMutationNode().withFields(fields);

        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('field1', node.nodes.get(0).name);
        System.assertEquals('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void mutationWithNodeTest() {
        String nodeName = 'node1';

        GraphQLMutationNode node = new GraphQLMutationNode().withNode(new GraphQLNode(nodeName));

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void mutationWithNodesTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLMutationNode node = new GraphQLMutationNode().withNodes(nodes);

        System.assertEquals(nodes.size(), node.nodes.size());
        System.assertEquals('node1', node.nodes.get(0).name);
        System.assertEquals('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void mutationBuildRequestTest() {
        GraphQLRequest request = new GraphQLMutationNode(new List<String>{ 'field1' })
            .buildRequest();

        System.assertEquals(GraphQLOperation.Mutation, request.operation);
        System.assertEquals('{"query":"mutation{field1}"}', request.toString());
        System.assertEquals(
            '{\n  "query" : "mutation {\\n  field1\\n}"\n}',
            request.toString(true)
        );
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildMutationPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode>{
            new GraphQLNode('field1'),
            new GraphQLNode('field2')
        };
        List<String> fields = new List<String>{ 'field3', 'field4' };

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
    private static void buildMutationWithChildNodesPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode>{
            new GraphQLNode('field1'),
            new GraphQLNode(
                'field2',
                new List<GraphQLNode>{ new GraphQLNode('field21'), new GraphQLNode('field22') }
            ),
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
