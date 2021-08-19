@IsTest(IsParallel=true)
private class GraphQLNodeTest {
    @IsTest
    private static void emptyNodeTest() {
        GraphQLNode node = new GraphQLNode();

        System.assertEquals(CommonConstants.EMPTY, node.name);
        System.assertEquals(0, node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void namedNodeTest() {
        String nodeName = 'node';

        GraphQLNode node = new GraphQLNode(nodeName);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(0, node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void emptyNodeWithChildNodesTest() {
        List<GraphQLNode> childNodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLNode node = new GraphQLNode(childNodes);

        System.assertEquals(CommonConstants.EMPTY, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
        System.assert(node.hasNode(childNodes.get(0)));
        System.assert(!node.hasNode(new GraphQLNode('node3')));
    }

    @IsTest
    private static void namedNodeWithChildNodesTest() {
        String nodeName = 'node';
        List<GraphQLNode> childNodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLNode node = new GraphQLNode(nodeName, childNodes);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void emptyNodeWithFieldsTest() {
        List<String> fields = new List<String>{ 'field1', 'field2' };

        GraphQLNode node = new GraphQLNode(fields);

        System.assertEquals(CommonConstants.EMPTY, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void namedNodeWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String>{ 'field1', 'field2' };

        GraphQLNode node = new GraphQLNode(nodeName, fields);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void nodeWithFieldTest() {
        String fieldName = 'field1';

        GraphQLNode node = new GraphQLNode().withField(fieldName);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void nodeWithFieldsTest() {
        List<String> fields = new List<String>{ 'field1', 'field2' };

        GraphQLNode node = new GraphQLNode().withFields(fields);

        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('field1', node.nodes.get(0).name);
        System.assertEquals('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void nodeWithNodeTest() {
        String nodeName = 'node1';

        GraphQLNode node = new GraphQLNode().withNode(new GraphQLNode(nodeName));

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void nodeWithNodesTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLNode node = new GraphQLNode().withNodes(nodes);

        System.assertEquals(nodes.size(), node.nodes.size());
        System.assertEquals('node1', node.nodes.get(0).name);
        System.assertEquals('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void nodeWithArgumentTest() {
        GraphQLNode node = new GraphQLNode().withArgument('key', 'value');

        System.assertEquals(1, node.arguments.size());
        System.assertEquals('value', node.arguments.get('key').value);
    }

    @IsTest
    private static void nodeWithArgumentsTest() {
        List<GraphQLArgument> arguments = new List<GraphQLArgument>{
            new GraphQLArgument('key1', 'value1'),
            new GraphQLArgument('key2', 'value2')
        };

        GraphQLNode node = new GraphQLNode().withArguments(arguments);

        System.assertEquals(arguments.size(), node.arguments.size());
        System.assertEquals('value1', node.arguments.get('key1').value);
        System.assertEquals('value2', node.arguments.get('key2').value);
    }

    @IsTest
    private static void nodeAsQueryTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLQueryNode query = new GraphQLNode('Test', nodes).asQuery();

        System.assertEquals('query Test', query.name);
        System.assertEquals(nodes.size(), query.nodes.size());
        System.assertEquals(0, query.arguments.size());
        System.assertEquals(0, query.variables.size());
        System.assertEquals('query Test{node1,node2}', query.build());
    }

    @IsTest
    private static void nodeAsMutationTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLMutationNode mutation = new GraphQLNode('Test', nodes).asMutation();

        System.assertEquals('mutation Test', mutation.name);
        System.assertEquals(nodes.size(), mutation.nodes.size());
        System.assertEquals(0, mutation.arguments.size());
        System.assertEquals(0, mutation.variables.size());
        System.assertEquals('mutation Test{node1,node2}', mutation.build());
    }

    @IsTest
    private static void nodeAsSubscriptionTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode>{
            new GraphQLNode('node1'),
            new GraphQLNode('node2')
        };

        GraphQLSubscriptionNode subscription = new GraphQLNode('Test', nodes).asSubscription();

        System.assertEquals('subscription Test', subscription.name);
        System.assertEquals(nodes.size(), subscription.nodes.size());
        System.assertEquals(0, subscription.arguments.size());
        System.assertEquals(0, subscription.variables.size());
        System.assertEquals('subscription Test{node1,node2}', subscription.build());
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildNodeWithAliasPositiveTest() {
        GraphQLNode childNode = new GraphQLNode('countries', new List<String>{ 'name', 'code' })
            .byAlias('ctrs');

        GraphQLNode node = new GraphQLNode(new List<GraphQLNode>{ childNode });

        System.assert(node != null);
        System.assertEquals('{ctrs:countries{name,code}}', node.build());
        System.assertEquals('{\n  ctrs: countries {\n    name\n    code\n  }\n}', node.build(true));
    }

    @IsTest
    private static void buildNodePositiveTest() {
        List<String> fields = new List<String>{ 'field1', 'field2', 'field3' };

        GraphQLNode node = new GraphQLNode().withFields(fields);

        System.assert(node != null);
        System.assertEquals(CommonConstants.EMPTY, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('{field1,field2,field3}', node.build());
        System.assertEquals('{\n  field1\n  field2\n  field3\n}', node.build(true));
    }

    @IsTest
    private static void buildNodeAsQueryPositiveTest() {
        List<String> fields = new List<String>{ 'field1', 'field2', 'field3' };

        GraphQLQueryNode query = new GraphQLNode()
            .withFields(fields)
            .withArgument('arg', 'value')
            .asQuery();

        System.assert(query != null);
        System.assertEquals(GraphQLOperation.Query.name().toLowerCase(), query.name);
        System.assertEquals(fields.size(), query.nodes.size());
        System.assertEquals(0, query.arguments.size());
        System.assertEquals('query{field1,field2,field3}', query.build());
        System.assertEquals('query {\n  field1\n  field2\n  field3\n}', query.build(true));
    }

    @IsTest
    private static void buildNodeAsMutationPositiveTest() {
        List<String> fields = new List<String>{ 'field1', 'field2', 'field3' };

        GraphQLMutationNode mutation = new GraphQLNode()
            .withFields(fields)
            .withArgument('arg', 'value')
            .asMutation();

        System.assert(mutation != null);
        System.assertEquals(GraphQLOperation.Mutation.name().toLowerCase(), mutation.name);
        System.assertEquals(fields.size(), mutation.nodes.size());
        System.assertEquals(0, mutation.arguments.size());
        System.assertEquals('mutation{field1,field2,field3}', mutation.build());
        System.assertEquals('mutation {\n  field1\n  field2\n  field3\n}', mutation.build(true));
    }

    @IsTest
    private static void buildNodeAsSubscriptionPositiveTest() {
        List<String> fields = new List<String>{ 'field1', 'field2', 'field3' };

        GraphQLSubscriptionNode subscription = new GraphQLNode()
            .withFields(fields)
            .withArgument('arg', 'value')
            .asSubscription();

        System.assert(subscription != null);
        System.assertEquals(GraphQLOperation.Subscription.name().toLowerCase(), subscription.name);
        System.assertEquals(fields.size(), subscription.nodes.size());
        System.assertEquals(0, subscription.arguments.size());
        System.assertEquals('subscription{field1,field2,field3}', subscription.build());
        System.assertEquals(
            'subscription {\n  field1\n  field2\n  field3\n}',
            subscription.build(true)
        );
    }

    @IsTest
    private static void buildNodeWithChildrenPositiveTest() {
        String firstMethodName = 'testMethod1';
        String secondMethodName = 'testMethod2';
        List<String> firstMethodFields = new List<String>{ 'field1', 'field2' };
        List<String> secondMethodFields = new List<String>{ 'field3', 'field4' };
        List<String> childrenNodeFields = new List<String>{ 'field11', 'field22' };

        GraphQLNode firstNode = new GraphQLNode(firstMethodName, firstMethodFields);

        GraphQLNode secondNode = new GraphQLNode(secondMethodName)
            .withNode(new GraphQLNode('field3', childrenNodeFields))
            .withField('field4');

        List<GraphQLNode> childrenNodes = new List<GraphQLNode>{ firstNode, secondNode };

        GraphQLNode rootNode = new GraphQLNode(childrenNodes);

        System.assert(firstNode != null);
        System.assert(secondNode != null);
        System.assert(rootNode != null);
        System.assertEquals(firstMethodName, firstNode.name);
        System.assertEquals(secondMethodName, secondNode.name);
        System.assertEquals(CommonConstants.EMPTY, rootNode.name);
        System.assertEquals(firstMethodFields.size(), firstNode.nodes.size());
        System.assertEquals(secondMethodFields.size(), secondNode.nodes.size());
        System.assertEquals(childrenNodes.size(), rootNode.nodes.size());
        System.assertEquals(
            '{testMethod1{field1,field2},testMethod2{field3{field11,field22},field4}}',
            rootNode.build()
        );
        System.assertEquals(
            '{\n  testMethod1 {\n    field1\n    field2\n  }\n  testMethod2 {\n    field3 {\n      field11\n      field22\n    }\n    field4\n  }\n}',
            rootNode.build(true)
        );
    }

    @IsTest
    private static void buildNodeWithArgumentsPositiveTest() {
        String nodeName = 'testMethod';
        List<String> fields = new List<String>{ 'field1', 'field2', 'field3' };

        GraphQLNode node = new GraphQLNode(nodeName, fields)
            .withArgument('var1', 'test1')
            .withArgument('var2', 1)
            .withArgument('var3', new Map<String, Object>{ 'f1' => 1, 'f2' => '2' });

        GraphQLNode rootNode = new GraphQLNode('root').withNode(node);

        System.assert(node != null);
        System.assert(rootNode != null);
        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(
            'root{testMethod(var1:"test1",var2:1,var3:{f2:"2",f1:1}){field1,field2,field3}}',
            rootNode.build()
        );
        System.assertEquals(
            'root {\n  testMethod(var1: "test1", var2: 1, var3: {f2:"2",f1:1}) {\n    field1\n    field2\n    field3\n  }\n}',
            rootNode.build(true)
        );
    }

    @IsTest
    private static void buildNodeWithDeepNestingNegativeTest() {
        Integer depthLevel = 20;
        GraphQLNode node = new GraphQLNode();
        GraphQLNode prevNode;
        for (Integer i = 0; i < depthLevel; i++) {
            GraphQLNode newNode = new GraphQLNode('node' + i);
            if (prevNode == null) {
                prevNode = node;
            }
            prevNode.withNode(newNode);
            prevNode = newNode;
        }

        Exception error;
        try {
            node.build();
        } catch (Exception err) {
            error = err;
        }

        System.assert(error != null);
        System.assert(error.getMessage().startsWith('Maximum request depth level is'));
    }

    @IsTest
    private static void buildEmptyNodeWithoutChildrenNegativeTest() {
        GraphQLNode node = new GraphQLNode();

        Exception error;
        try {
            node.build();
        } catch (Exception err) {
            error = err;
        }

        System.assert(error != null);
        System.assertEquals(Label.EmptyNodeError, error.getMessage());
    }
}
