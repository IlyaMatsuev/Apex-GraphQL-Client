@IsTest(IsParallel = true)
private class GraphQLNodeTest {
    @IsTest
    private static void emptyNodeTest() {
        GraphQLFieldNode node = new GraphQLFieldNode();

        System.assert(node.isFieldNode());
        System.assertEquals(GraphQLConstants.EMPTY, node.name);
        System.assertEquals(0, node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void namedNodeTest() {
        String nodeName = 'node';

        GraphQLFieldNode node = new GraphQLFieldNode(nodeName);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(0, node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void emptyNodeWithChildNodesTest() {
        List<GraphQLFieldNode> childNodes = new List<GraphQLFieldNode> {
            new GraphQLFieldNode('node1'),
            new GraphQLFieldNode('node2')
        };

        GraphQLFieldNode node = new GraphQLFieldNode(childNodes);

        System.assertEquals(GraphQLConstants.EMPTY, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
        System.assert(node.hasNode(childNodes.get(0)));
        System.assert(!node.hasNode(new GraphQLFieldNode('node3')));
    }

    @IsTest
    private static void namedNodeWithChildNodesTest() {
        String nodeName = 'node';
        List<GraphQLFieldNode> childNodes = new List<GraphQLFieldNode> {
            new GraphQLFieldNode('node1'),
            new GraphQLFieldNode('node2')
        };

        GraphQLFieldNode node = new GraphQLFieldNode(nodeName, childNodes);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void emptyNodeWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLFieldNode node = new GraphQLFieldNode(fields);

        System.assertEquals(GraphQLConstants.EMPTY, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void namedNodeWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLFieldNode node = new GraphQLFieldNode(nodeName, fields);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(0, node.arguments.size());
    }

    @IsTest
    private static void nodeWithFieldTest() {
        String fieldName = 'field1';

        GraphQLFieldNode node = new GraphQLFieldNode().withField(fieldName);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void nodeWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLFieldNode node = new GraphQLFieldNode().withFields(fields);

        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('field1', node.nodes.get(0).name);
        System.assertEquals('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void nodeWithFragmentTest() {
        String fragmentName = 'FieldSet';

        GraphQLFieldNode node = new GraphQLFieldNode().withFragment(fragmentName);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(GraphQLConstants.DOT.repeat(3) + fragmentName, node.nodes.get(0).name);
    }

    @IsTest
    private static void nodeWithFragmentsTest() {
        List<String> fragments = new List<String> { 'FieldSet1', 'FieldSet12' };

        GraphQLFieldNode node = new GraphQLFieldNode().withFragments(fragments);

        System.assertEquals(fragments.size(), node.nodes.size());
        System.assertEquals(GraphQLConstants.DOT.repeat(3) + 'FieldSet1', node.nodes.get(0).name);
        System.assertEquals(GraphQLConstants.DOT.repeat(3) + 'FieldSet12', node.nodes.get(1).name);
    }

    @IsTest
    private static void nodeWithInlineFragmentTest() {
        GraphQLFragmentNode fragment = new GraphQLFragmentNode('SomeType').withField('field1');

        GraphQLFieldNode node = new GraphQLFieldNode().withInlineFragment(fragment);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals('{... on SomeType{field1}}', node.build());
        System.assertEquals('{\n  ... on SomeType {\n    field1\n  }\n}', node.build(true));
    }

    @IsTest
    private static void nodeWithInlineFragmentsTest() {
        List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode> {
            new GraphQLFragmentNode('SomeType').withField('field1'),
            new GraphQLFragmentNode('SomeType2').withField('field11')
        };

        GraphQLFieldNode node = new GraphQLFieldNode().withInlineFragments(fragments);

        System.assertEquals(2, node.nodes.size());
        System.assertEquals('{... on SomeType{field1},... on SomeType2{field11}}', node.build());
    }

    @IsTest
    private static void nodeWithInlineFragmentOnTheSameTypeTest() {
        GraphQLFieldNode node = new GraphQLFieldNode()
            .withInlineFragment(new GraphQLFragmentNode().withField('field1').withField('field2'));

        System.assertEquals(1, node.nodes.size());
        System.assertEquals('{...{field1,field2}}', node.build());
        System.assertEquals('{\n  ... {\n    field1\n    field2\n  }\n}', node.build(true));
    }

    @IsTest
    private static void nodeWithInlineFragmentWithNamedFragmentNegativeTest() {
        GraphQLFragmentNode fragment = new GraphQLFragmentNode('fragment1', 'SomeType').withField('field1');

        Exception error;
        try {
            new GraphQLFieldNode().withInlineFragment(fragment);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error instanceof GraphQLNode.GraphQLBaseNodeException);
    }

    @IsTest
    private static void nodeWithNodeTest() {
        String nodeName = 'node1';

        GraphQLFieldNode node = new GraphQLFieldNode().withNode(new GraphQLFieldNode(nodeName));

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void nodeWithNodesTest() {
        List<GraphQLFieldNode> nodes = new List<GraphQLFieldNode> {
            new GraphQLFieldNode('node1'),
            new GraphQLFieldNode('node2')
        };

        GraphQLFieldNode node = new GraphQLFieldNode().withNodes(nodes);

        System.assertEquals(nodes.size(), node.nodes.size());
        System.assertEquals('node1', node.nodes.get(0).name);
        System.assertEquals('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void nodeWithArgumentTest() {
        GraphQLFieldNode node = new GraphQLFieldNode().withArgument('key', 'value');

        System.assertEquals(1, node.arguments.size());
        System.assertEquals('value', node.arguments.get('key').value);
    }

    @IsTest
    private static void nodeWithArgumentsTest() {
        List<GraphQLArgument> arguments = new List<GraphQLArgument> {
            new GraphQLArgument('key1', 'value1'),
            new GraphQLArgument('key2', 'value2')
        };

        GraphQLFieldNode node = new GraphQLFieldNode().withArguments(arguments);

        System.assertEquals(arguments.size(), node.arguments.size());
        System.assertEquals('value1', node.arguments.get('key1').value);
        System.assertEquals('value2', node.arguments.get('key2').value);
    }

    @IsTest
    private static void nodeIncludeIfConditionAndVariableTest() {
        GraphQLFieldNode node = new GraphQLFieldNode().includeIf(false).includeIf('var');

        System.assert(node.hasDirectives());
        System.assertEquals(2, node.directives.size());
    }

    @IsTest
    private static void nodeSkipIfConditionAndVariableTest() {
        GraphQLFieldNode node = new GraphQLFieldNode().skipIf(false).skipIf('var');

        System.assert(node.hasDirectives());
        System.assertEquals(2, node.directives.size());
    }

    @IsTest
    private static void nodeAsQueryTest() {
        List<GraphQLFieldNode> nodes = new List<GraphQLFieldNode> {
            new GraphQLFieldNode('node1'),
            new GraphQLFieldNode('node2')
        };

        GraphQLQueryNode query = new GraphQLFieldNode('Test', nodes).asQuery();

        System.assertEquals('Test', query.name);
        System.assertEquals(nodes.size(), query.nodes.size());
        System.assertEquals(0, query.variables.size());
        System.assertEquals('query Test{node1,node2}', query.build());
    }

    @IsTest
    private static void nodeAsMutationTest() {
        List<GraphQLFieldNode> nodes = new List<GraphQLFieldNode> {
            new GraphQLFieldNode('node1'),
            new GraphQLFieldNode('node2')
        };

        GraphQLMutationNode mutation = new GraphQLFieldNode('Test', nodes).asMutation();

        System.assertEquals('Test', mutation.name);
        System.assertEquals(nodes.size(), mutation.nodes.size());
        System.assertEquals(0, mutation.variables.size());
        System.assertEquals('mutation Test{node1,node2}', mutation.build());
    }

    @IsTest
    private static void nodeAsSubscriptionTest() {
        List<GraphQLFieldNode> nodes = new List<GraphQLFieldNode> {
            new GraphQLFieldNode('node1'),
            new GraphQLFieldNode('node2')
        };

        GraphQLSubscriptionNode subscription = new GraphQLFieldNode('Test', nodes).asSubscription();

        System.assertEquals('Test', subscription.name);
        System.assertEquals(nodes.size(), subscription.nodes.size());
        System.assertEquals(0, subscription.variables.size());
        System.assertEquals('subscription Test{node1,node2}', subscription.build());
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildNodeWithAliasPositiveTest() {
        GraphQLFieldNode childNode = new GraphQLFieldNode('countries', new List<String> { 'name', 'code' })
            .byAlias('ctrs');

        GraphQLFieldNode node = new GraphQLFieldNode(new List<GraphQLFieldNode> { childNode });

        System.assert(node != null);
        System.assertEquals('{ctrs:countries{name,code}}', node.build());
        System.assertEquals('{\n  ctrs: countries {\n    name\n    code\n  }\n}', node.build(true));
    }

    @IsTest
    private static void buildNodePositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLFieldNode node = new GraphQLFieldNode().withFields(fields).withFragment('SomeFields');

        System.assert(node != null);
        System.assertEquals(GraphQLConstants.EMPTY, node.name);
        System.assertEquals(fields.size() + 1, node.nodes.size());
        System.assertEquals('{field1,field2,field3,...SomeFields}', node.build());
        System.assertEquals('{\n  field1\n  field2\n  field3\n  ...SomeFields\n}', node.build(true));
    }

    @IsTest
    private static void buildNodeWithInlineFragmentPositiveTest() {
        GraphQLFragmentNode inlineFragment = new GraphQLFragmentNode('SomeType').withField('field11');

        GraphQLFieldNode node = new GraphQLFieldNode()
            .withField('field1')
            .withFragment('SomeFields')
            .withInlineFragment(inlineFragment);

        System.assert(node != null);
        System.assertEquals(3, node.nodes.size());
        System.assertEquals('{field1,...SomeFields,... on SomeType{field11}}', node.build());
        System.assertEquals('{\n  field1\n  ...SomeFields\n  ... on SomeType {\n    field11\n  }\n}', node.build(true));
    }

    @IsTest
    private static void buildNodeAsQueryPositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLQueryNode query = new GraphQLFieldNode().withFields(fields).withArgument('arg', 'value').asQuery();

        System.assert(query != null);
        System.assert(String.isBlank(query.name));
        System.assertEquals(fields.size(), query.nodes.size());
        System.assertEquals('query{field1,field2,field3}', query.build());
        System.assertEquals('query {\n  field1\n  field2\n  field3\n}', query.build(true));
    }

    @IsTest
    private static void buildNodeAsMutationPositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLMutationNode mutation = new GraphQLFieldNode()
            .withFields(fields)
            .withArgument('arg', 'value')
            .asMutation();

        System.assert(mutation != null);
        System.assert(String.isBlank(mutation.name));
        System.assertEquals(fields.size(), mutation.nodes.size());
        System.assertEquals('mutation{field1,field2,field3}', mutation.build());
        System.assertEquals('mutation {\n  field1\n  field2\n  field3\n}', mutation.build(true));
    }

    @IsTest
    private static void buildNodeAsSubscriptionPositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLSubscriptionNode subscription = new GraphQLFieldNode()
            .withFields(fields)
            .withArgument('arg', 'value')
            .asSubscription();

        System.assert(subscription != null);
        System.assert(String.isBlank(subscription.name));
        System.assertEquals(fields.size(), subscription.nodes.size());
        System.assertEquals('subscription{field1,field2,field3}', subscription.build());
        System.assertEquals('subscription {\n  field1\n  field2\n  field3\n}', subscription.build(true));
    }

    @IsTest
    private static void buildNodeWithChildrenPositiveTest() {
        String firstMethodName = 'testMethod1';
        String secondMethodName = 'testMethod2';
        List<String> firstMethodFields = new List<String> { 'field1', 'field2' };
        List<String> secondMethodFields = new List<String> { 'field3', 'field4' };
        List<String> childrenNodeFields = new List<String> { 'field11', 'field22' };

        GraphQLFieldNode firstNode = new GraphQLFieldNode(firstMethodName, firstMethodFields);

        GraphQLFieldNode secondNode = new GraphQLFieldNode(secondMethodName)
            .withNode(new GraphQLFieldNode('field3', childrenNodeFields))
            .withField('field4');

        List<GraphQLFieldNode> childrenNodes = new List<GraphQLFieldNode> { firstNode, secondNode };

        GraphQLFieldNode rootNode = new GraphQLFieldNode(childrenNodes);

        System.assert(firstNode != null);
        System.assert(secondNode != null);
        System.assert(rootNode != null);
        System.assertEquals(firstMethodName, firstNode.name);
        System.assertEquals(secondMethodName, secondNode.name);
        System.assertEquals(GraphQLConstants.EMPTY, rootNode.name);
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
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLFieldNode node = new GraphQLFieldNode(nodeName, fields)
            .withArgument('var1', 'test1')
            .withArgument('var2', 1)
            .withArgument('var3', new Map<String, Object> { 'f1' => 1, 'f2' => '2', 'f3' => '$ref' });

        GraphQLFieldNode rootNode = new GraphQLFieldNode('root').withNode(node);

        System.assert(node != null);
        System.assert(rootNode != null);
        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(
            'root{testMethod(var1:"test1",var2:1,var3:{f3:$ref,f2:"2",f1:1}){field1,field2,field3}}',
            rootNode.build()
        );
        System.assertEquals(
            'root {\n  testMethod(var1: "test1", var2: 1, var3: { f3: $ref, f2: "2", f1: 1 }) {\n    field1\n    field2\n    field3\n  }\n}',
            rootNode.build(true)
        );
    }

    @IsTest
    private static void buildNodeWithDirectivePositiveTest() {
        String nodeName = 'testMethod';
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLFieldNode node = new GraphQLFieldNode(nodeName, fields)
            .includeIf(true)
            .skipIf('test1')
            .withArgument('var1', '$test1');

        GraphQLFieldNode rootNode = new GraphQLFieldNode('root').withNode(node);

        System.assertEquals(
            'root{testMethod(var1:$test1) @include(if:true) @skip(if:$test1){field1,field2,field3}}',
            rootNode.build()
        );
        System.assertEquals(
            'root {\n  testMethod(var1: $test1) @include(if: true) @skip(if: $test1) {\n    field1\n    field2\n    field3\n  }\n}',
            rootNode.build(true)
        );
    }

    @IsTest
    private static void buildNodeWithDeepNestingNegativeTest() {
        Integer depthLevel = 20;
        GraphQLFieldNode node = new GraphQLFieldNode();
        GraphQLFieldNode prevNode;
        for (Integer i = 0; i < depthLevel; i++) {
            GraphQLFieldNode newNode = new GraphQLFieldNode('node' + i);
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
        GraphQLFieldNode node = new GraphQLFieldNode();

        Exception error;
        try {
            node.build();
        } catch (Exception err) {
            error = err;
        }

        System.assert(error != null);
        System.assertEquals('Cannot parse an empty node without any child nodes', error.getMessage());
    }

    @IsTest
    private static void getNodeParserNegativeTest() {
        Exception error;
        try {
            new TestNode().build();
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error instanceof GraphQLNode.GraphQLBaseNodeException);
    }

    private class TestNode extends GraphQLNode {
        private TestNode() {
            super(GraphQLConstants.EMPTY, new List<String>());
        }
    }
}
