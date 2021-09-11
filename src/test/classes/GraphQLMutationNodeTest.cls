@IsTest(IsParallel=true)
private class GraphQLMutationNodeTest {
    @IsTest
    private static void emptyMutationTest() {
        GraphQLMutationNode node = new GraphQLMutationNode();

        System.assert(String.isBlank(node.name));
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void namedMutationTest() {
        String nodeName = 'Test';

        GraphQLMutationNode node = new GraphQLMutationNode(nodeName);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithChildNodeTest() {
        GraphQLNode childNode = new GraphQLNode('node1');

        GraphQLMutationNode node = new GraphQLMutationNode(childNode);

        System.assert(String.isBlank(node.name));
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithChildNodesTest() {
        List<GraphQLNode> childNodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLMutationNode node = new GraphQLMutationNode(childNodes);

        System.assert(String.isBlank(node.name));
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLMutationNode node = new GraphQLMutationNode(nodeName, new GraphQLNode('node1'));

        System.assertEquals(nodeName, node.name);
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLNode> childNodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLMutationNode node = new GraphQLMutationNode(nodeName, childNodes);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithFieldsTest() {
        List<String> fields = new List<String>{ 'field1', 'field2' };

        GraphQLMutationNode node = new GraphQLMutationNode(fields);

        System.assert(String.isBlank(node.name));
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String>{ 'field1', 'field2' };

        GraphQLMutationNode node = new GraphQLMutationNode(nodeName, fields);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
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
    private static void mutationWithFragmentTest() {
        GraphQLFragmentNode fragment = new GraphQLFragmentNode('fragment1', 'Type1');

        GraphQLMutationNode node = new GraphQLMutationNode().withFragment(fragment);

        System.assert(node.hasFragments());
        System.assertEquals(1, node.fragments.size());
        System.assertEquals(fragment.name, node.fragments.get(0).name);
    }

    @IsTest
    private static void mutationWithFragmentsTest() {
        List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode>{
            new GraphQLFragmentNode('fragment1', 'Type1'),
            new GraphQLFragmentNode('fragment2', 'Type2')
        };

        GraphQLMutationNode node = new GraphQLMutationNode().withFragments(fragments);

        System.assert(node.hasFragments());
        System.assertEquals(fragments.size(), node.fragments.size());
        System.assertEquals('fragment1', node.fragments.get(0).name);
        System.assertEquals('fragment2', node.fragments.get(1).name);
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
    private static void mutationWithVariableTest() {
        GraphQLMutationNode node = new GraphQLMutationNode()
            .withNode(new GraphQLNode('node'))
            .withVariable('var', '[String!]');

        System.assertEquals(1, node.variables.size());
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
        System.assert(String.isBlank(mutation.name));
        System.assertEquals(nodes.size() + fields.size(), mutation.nodes.size());
        System.assertEquals('mutation{field1,field2,field3,field4}', mutation.build());
        System.assertEquals(
            'mutation {\n  field1\n  field2\n  field3\n  field4\n}',
            mutation.build(true)
        );
    }

    @IsTest
    private static void buildMutationWithVariablePositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };
        List<String> fields = new List<String>{ 'field3', 'field4' };

        GraphQLMutationNode mutation = new GraphQLMutationNode()
            .withNodes(nodes)
            .withFields(fields)
            .withVariable('model', 'InputType!');

        System.assert(mutation != null);
        System.assert(String.isBlank(mutation.name));
        System.assertEquals(nodes.size() + fields.size(), mutation.nodes.size());
        System.assertEquals(
            'mutation($model:InputType!){node1,node2,field3,field4}',
            mutation.build()
        );
        System.assertEquals(
            'mutation ($model: InputType!) {\n  node1\n  node2\n  field3\n  field4\n}',
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
        System.assertEquals('TestMutation', mutation.name);
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
