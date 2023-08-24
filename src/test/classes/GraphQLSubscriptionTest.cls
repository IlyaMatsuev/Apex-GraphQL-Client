@IsTest(isParallel = true)
private class GraphQLSubscriptionTest {
    @IsTest
    private static void emptySubscriptionTest() {
        GraphQLSubscription node = new GraphQLSubscription();

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(0, node.nodes.size());
    }

    @IsTest
    private static void namedSubscriptionTest() {
        String nodeName = 'Test';

        GraphQLSubscription node = new GraphQLSubscription(nodeName);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(0, node.nodes.size());
    }

    @IsTest
    private static void emptySubscriptionWithChildNodeTest() {
        GraphQLField childNode = new GraphQLField('node1');

        GraphQLSubscription node = new GraphQLSubscription(childNode);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(1, node.nodes.size());
    }

    @IsTest
    private static void emptySubscriptionWithChildNodesTest() {
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLSubscription node = new GraphQLSubscription(childNodes);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void namedSubscriptionWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLSubscription node = new GraphQLSubscription(nodeName, new GraphQLField('node1'));

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(1, node.nodes.size());
    }

    @IsTest
    private static void namedSubscriptionWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLSubscription node = new GraphQLSubscription(nodeName, childNodes);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void emptySubscriptionWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLSubscription node = new GraphQLSubscription(fields);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void namedSubscriptionWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLSubscription node = new GraphQLSubscription(nodeName, fields);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void subscriptionWithFieldTest() {
        String fieldName = 'field1';

        GraphQLSubscription node = new GraphQLSubscription().withField(fieldName);

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void subscriptionWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLSubscription node = new GraphQLSubscription().withFields(fields);

        Assert.areEqual(fields.size(), node.nodes.size());
        Assert.areEqual('field1', node.nodes.get(0).name);
        Assert.areEqual('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void subscriptionWithFragmentDefinitionTest() {
        GraphQLFragment fragment = new GraphQLFragment('fragment1', 'Type1');

        GraphQLSubscription node = new GraphQLSubscription().defineFragment(fragment);

        Assert.isTrue(node.hasFragments());
        Assert.areEqual(1, node.fragments.size());
        Assert.areEqual(fragment.name, node.fragments.get(0).name);
    }

    @IsTest
    private static void subscriptionWithFragmentDefinitionsTest() {
        List<GraphQLFragment> fragments = new List<GraphQLFragment> {
            new GraphQLFragment('fragment1', 'Type1'),
            new GraphQLFragment('fragment2', 'Type2')
        };

        GraphQLSubscription node = new GraphQLSubscription().defineFragments(fragments);

        Assert.isTrue(node.hasFragments());
        Assert.areEqual(fragments.size(), node.fragments.size());
        Assert.areEqual('fragment1', node.fragments.get(0).name);
        Assert.areEqual('fragment2', node.fragments.get(1).name);
    }

    @IsTest
    private static void subscriptionWithDirectiveTest() {
        GraphQLSubscription subscription = new GraphQLSubscription()
            .withDirective(new GraphQLDirective('test'))
            .withField('field');

        Assert.areEqual(1, subscription.directives.size());
        Assert.areEqual('subscription@test{field}', subscription.build());
        Assert.areEqual('subscription @test {\n  field\n}', subscription.build(true));
    }

    @IsTest
    private static void subscriptionWithFieldNodeTest() {
        String nodeName = 'node1';

        GraphQLSubscription node = new GraphQLSubscription().withField(new GraphQLField(nodeName));

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void subscriptionWithFieldNodesTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLSubscription node = new GraphQLSubscription().withFields(nodes);

        Assert.areEqual(nodes.size(), node.nodes.size());
        Assert.areEqual('node1', node.nodes.get(0).name);
        Assert.areEqual('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void subscriptionWithVariableDefinitionTest() {
        GraphQLSubscription node = new GraphQLSubscription()
            .withField(new GraphQLField('node'))
            .defineVariable('newVariable', '[Int]! = 0');

        Assert.areEqual(1, node.variables.size());
    }

    @IsTest
    private static void subscriptionBuildRequestTest() {
        Exception error;
        try {
            new GraphQLSubscription(new List<String> { 'field1' }).asRequest();
        } catch (Exception ex) {
            error = ex;
        }

        Assert.isNotNull(error);
        Assert.isInstanceOfType(error, GraphQLOperation.GraphQLOperationException.class);
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildSubscriptionPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('field1'), new GraphQLField('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLSubscription subscription = new GraphQLSubscription()
            .withField(nodes.get(0))
            .withField(nodes.get(1))
            .withFields(fields)
            .withField('field3');

        Assert.isTrue(String.isBlank(subscription.name));
        Assert.areEqual(nodes.size() + fields.size(), subscription.nodes.size());
        Assert.areEqual('subscription{field1,field2,field3,field4}', subscription.build());
        Assert.areEqual('subscription {\n  field1\n  field2\n  field3\n  field4\n}', subscription.build(true));
    }

    @IsTest
    private static void buildSubscriptionWithVariableDefinitionsPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('node1').withArgument('arg', '$param1'),
            new GraphQLField('node2')
        };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLSubscription subscription = new GraphQLSubscription()
            .withFields(nodes)
            .withFields(fields)
            .defineVariable('param1', 'Int!')
            .defineVariable('param2', 'String');

        Assert.isTrue(String.isBlank(subscription.name));
        Assert.areEqual(nodes.size() + fields.size(), subscription.nodes.size());
        Assert.areEqual(
            'subscription($param1:Int!,$param2:String){node1(arg:$param1),node2,field3,field4}',
            subscription.build()
        );
        Assert.areEqual(
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

        GraphQLSubscription subscription = new GraphQLSubscription('TestSubscription', nodes).withField('field1');

        Assert.areEqual('TestSubscription', subscription.name);
        Assert.areEqual(nodes.size(), subscription.nodes.size());
        Assert.areEqual('subscription TestSubscription{field1,field2{field21,field22},field3}', subscription.build());
        Assert.areEqual(
            'subscription TestSubscription {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            subscription.build(true)
        );
    }
}
