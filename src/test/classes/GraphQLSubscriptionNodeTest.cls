@IsTest(IsParallel = true)
private class GraphQLSubscriptionNodeTest {
    @IsTest
    private static void emptySubscriptionTest() {
        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode();

        System.assert(String.isBlank(node.name));
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void namedSubscriptionTest() {
        String nodeName = 'Test';

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode(nodeName);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void emptySubscriptionWithChildNodeTest() {
        GraphQLField childNode = new GraphQLField('node1');

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode(childNode);

        System.assert(String.isBlank(node.name));
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void emptySubscriptionWithChildNodesTest() {
        List<GraphQLField> childNodes = new List<GraphQLField> {
            new GraphQLField('node1'),
            new GraphQLField('node2')
        };

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode(childNodes);

        System.assert(String.isBlank(node.name));
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void namedSubscriptionWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode(nodeName, new GraphQLField('node1'));

        System.assertEquals(nodeName, node.name);
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void namedSubscriptionWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLField> childNodes = new List<GraphQLField> {
            new GraphQLField('node1'),
            new GraphQLField('node2')
        };

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode(nodeName, childNodes);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void emptySubscriptionWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode(fields);

        System.assert(String.isBlank(node.name));
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void namedSubscriptionWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode(nodeName, fields);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void subscriptionWithFieldTest() {
        String fieldName = 'field1';

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode().withField(fieldName);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void subscriptionWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode().withFields(fields);

        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('field1', node.nodes.get(0).name);
        System.assertEquals('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void subscriptionWithFragmentDefinitionTest() {
        GraphQLFragmentNode fragment = new GraphQLFragmentNode('fragment1', 'Type1');

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode().defineFragment(fragment);

        System.assert(node.hasFragments());
        System.assertEquals(1, node.fragments.size());
        System.assertEquals(fragment.name, node.fragments.get(0).name);
    }

    @IsTest
    private static void subscriptionWithFragmentDefinitionsTest() {
        List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode> {
            new GraphQLFragmentNode('fragment1', 'Type1'),
            new GraphQLFragmentNode('fragment2', 'Type2')
        };

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode().defineFragments(fragments);

        System.assert(node.hasFragments());
        System.assertEquals(fragments.size(), node.fragments.size());
        System.assertEquals('fragment1', node.fragments.get(0).name);
        System.assertEquals('fragment2', node.fragments.get(1).name);
    }

    @IsTest
    private static void subscriptionWithNodeTest() {
        String nodeName = 'node1';

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode().withNode(new GraphQLField(nodeName));

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void subscriptionWithNodesTest() {
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('node1'),
            new GraphQLField('node2')
        };

        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode().withNodes(nodes);

        System.assertEquals(nodes.size(), node.nodes.size());
        System.assertEquals('node1', node.nodes.get(0).name);
        System.assertEquals('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void subscriptionWithVariableDefinitionTest() {
        GraphQLSubscriptionNode node = new GraphQLSubscriptionNode()
            .withNode(new GraphQLField('node'))
            .defineVariable('newVariable', '[Int]! = 0');

        System.assertEquals(1, node.variables.size());
    }

    @IsTest
    private static void subscriptionBuildRequestTest() {
        Exception error;
        try {
            new GraphQLSubscriptionNode(new List<String> { 'field1' }).asRequest();
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error instanceof GraphQLOperationNode.GraphQLOperationNodeException);
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildSubscriptionPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('field1'),
            new GraphQLField('field2')
        };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLSubscriptionNode subscription = new GraphQLSubscriptionNode()
            .withNode(nodes.get(0))
            .withNode(nodes.get(1))
            .withFields(fields)
            .withField('field3');

        System.assert(subscription != null);
        System.assert(String.isBlank(subscription.name));
        System.assertEquals(nodes.size() + fields.size(), subscription.nodes.size());
        System.assertEquals('subscription{field1,field2,field3,field4}', subscription.build());
        System.assertEquals('subscription {\n  field1\n  field2\n  field3\n  field4\n}', subscription.build(true));
    }

    @IsTest
    private static void buildSubscriptionWithVariableDefinitionsPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('node1').withArgument('arg', '$param1'),
            new GraphQLField('node2')
        };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLSubscriptionNode subscription = new GraphQLSubscriptionNode()
            .withNodes(nodes)
            .withFields(fields)
            .defineVariable('param1', 'Int!')
            .defineVariable('param2', 'String');

        System.assert(subscription != null);
        System.assert(String.isBlank(subscription.name));
        System.assertEquals(nodes.size() + fields.size(), subscription.nodes.size());
        System.assertEquals(
            'subscription($param1:Int!,$param2:String){node1(arg:$param1),node2,field3,field4}',
            subscription.build()
        );
        System.assertEquals(
            'subscription ($param1: Int!, $param2: String) {\n  node1(arg: $param1)\n  node2\n  field3\n  field4\n}',
            subscription.build(true)
        );
    }

    @IsTest
    private static void buildSubscriptionWithChildNodesPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('field1'),
            new GraphQLField(
                'field2',
                new List<GraphQLField> { new GraphQLField('field21'), new GraphQLField('field22') }
            ),
            new GraphQLField('field3')
        };

        GraphQLSubscriptionNode subscription = new GraphQLSubscriptionNode('TestSubscription', nodes)
            .withField('field1');

        System.assert(Subscription != null);
        System.assertEquals('TestSubscription', subscription.name);
        System.assertEquals(nodes.size(), subscription.nodes.size());
        System.assertEquals(
            'subscription TestSubscription{field1,field2{field21,field22},field3}',
            subscription.build()
        );
        System.assertEquals(
            'subscription TestSubscription {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            subscription.build(true)
        );
    }
}
