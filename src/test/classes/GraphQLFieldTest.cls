@IsTest(isParallel = true)
private class GraphQLFieldTest {
    @IsTest
    private static void emptyNodeTest() {
        GraphQLField node = new GraphQLField();

        Assert.isTrue(node.isFieldNode());
        Assert.areEqual(GraphQLConstants.EMPTY, node.name);
        Assert.areEqual(0, node.nodes.size());
        Assert.areEqual(0, node.arguments.size());
    }

    @IsTest
    private static void namedNodeTest() {
        String nodeName = 'node';

        GraphQLField node = new GraphQLField(nodeName);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(0, node.nodes.size());
        Assert.areEqual(0, node.arguments.size());
    }

    @IsTest
    private static void emptyNodeWithChildNodesTest() {
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLField node = new GraphQLField(childNodes);

        Assert.areEqual(GraphQLConstants.EMPTY, node.name);
        Assert.areEqual(childNodes.size(), node.nodes.size());
        Assert.areEqual(0, node.arguments.size());
        Assert.isTrue(node.hasField(childNodes.get(0)));
        Assert.isFalse(node.hasField(new GraphQLField('node3')));
    }

    @IsTest
    private static void namedNodeWithChildNodesTest() {
        String nodeName = 'node';
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLField node = new GraphQLField(nodeName, childNodes);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(childNodes.size(), node.nodes.size());
        Assert.areEqual(0, node.arguments.size());
    }

    @IsTest
    private static void emptyNodeWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLField node = new GraphQLField(fields);

        Assert.areEqual(GraphQLConstants.EMPTY, node.name);
        Assert.areEqual(fields.size(), node.nodes.size());
        Assert.areEqual(0, node.arguments.size());
    }

    @IsTest
    private static void namedNodeWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLField node = new GraphQLField(nodeName, fields);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(fields.size(), node.nodes.size());
        Assert.areEqual(0, node.arguments.size());
    }

    @IsTest
    private static void nodeWithFieldTest() {
        String fieldName = 'field1';

        GraphQLField node = new GraphQLField().withField(fieldName);

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void nodeWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLField node = new GraphQLField().withFields(fields);

        Assert.areEqual(fields.size(), node.nodes.size());
        Assert.areEqual('field1', node.nodes.get(0).name);
        Assert.areEqual('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void nodeWithFragmentTest() {
        String fragmentName = 'FieldSet';

        GraphQLField node = new GraphQLField().withFragment(fragmentName);

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(GraphQLConstants.DOT.repeat(3) + fragmentName, node.nodes.get(0).name);
    }

    @IsTest
    private static void nodeWithFragmentsTest() {
        List<String> fragments = new List<String> { 'FieldSet1', 'FieldSet12' };

        GraphQLField node = new GraphQLField().withFragments(fragments);

        Assert.areEqual(fragments.size(), node.nodes.size());
        Assert.areEqual(GraphQLConstants.DOT.repeat(3) + 'FieldSet1', node.nodes.get(0).name);
        Assert.areEqual(GraphQLConstants.DOT.repeat(3) + 'FieldSet12', node.nodes.get(1).name);
    }

    @IsTest
    private static void nodeWithInlineFragmentTest() {
        GraphQLFragment fragment = new GraphQLFragment('SomeType').withField('field1');

        GraphQLField node = new GraphQLField().withInlineFragment(fragment);

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual('{... on SomeType{field1}}', node.build());
        Assert.areEqual('{\n  ... on SomeType {\n    field1\n  }\n}', node.build(true));
    }

    @IsTest
    private static void nodeWithInlineFragmentsTest() {
        List<GraphQLFragment> fragments = new List<GraphQLFragment> {
            new GraphQLFragment('SomeType').withField('field1'),
            new GraphQLFragment('SomeType2').withField('field11')
        };

        GraphQLField node = new GraphQLField().withInlineFragments(fragments);

        Assert.areEqual(2, node.nodes.size());
        Assert.areEqual('{... on SomeType{field1},... on SomeType2{field11}}', node.build());
    }

    @IsTest
    private static void nodeWithInlineFragmentOnTheSameTypeTest() {
        GraphQLField node = new GraphQLField()
            .withInlineFragment(new GraphQLFragment().withField('field1').withField('field2'));

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual('{...{field1,field2}}', node.build());
        Assert.areEqual('{\n  ... {\n    field1\n    field2\n  }\n}', node.build(true));
    }

    @IsTest
    private static void nodeWithInlineFragmentWithNamedFragmentNegativeTest() {
        GraphQLFragment fragment = new GraphQLFragment('fragment1', 'SomeType').withField('field1');

        Exception error;
        try {
            new GraphQLField().withInlineFragment(fragment);
        } catch (Exception ex) {
            error = ex;
        }

        Assert.isNotNull(error);
        Assert.isInstanceOfType(error, GraphQLNode.GraphQLNodeException.class);
    }

    @IsTest
    private static void nodeWithFieldNodeTest() {
        String nodeName = 'node1';

        GraphQLField node = new GraphQLField().withField(new GraphQLField(nodeName));

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void nodeWithFieldNodesTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLField node = new GraphQLField().withFields(nodes);

        Assert.areEqual(nodes.size(), node.nodes.size());
        Assert.areEqual('node1', node.nodes.get(0).name);
        Assert.areEqual('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void nodeWithArgumentTest() {
        GraphQLField node = new GraphQLField().withArgument('key', 'value');

        Assert.areEqual(1, node.arguments.size());
        Assert.areEqual('value', node.arguments.get('key').value);
    }

    @IsTest
    private static void nodeWithArgumentsTest() {
        List<GraphQLArgument> arguments = new List<GraphQLArgument> {
            new GraphQLArgument('key1', 'value1'),
            new GraphQLArgument('key2', 'value2')
        };

        GraphQLField node = new GraphQLField().withArguments(arguments);

        Assert.areEqual(arguments.size(), node.arguments.size());
        Assert.areEqual('value1', node.arguments.get('key1').value);
        Assert.areEqual('value2', node.arguments.get('key2').value);
    }

    @IsTest
    private static void nodeWithDirectiveTest() {
        GraphQLField node = new GraphQLField('node')
            .withDirective(new GraphQLDirective('test').withArgument('var', true))
            .withField('field1');

        Assert.isTrue(node.hasDirectives());
        Assert.areEqual(1, node.directives.size());
        Assert.areEqual('node@test(var:true){field1}', node.build());
        Assert.areEqual('node @test(var: true) {\n  field1\n}', node.build(true));
    }

    @IsTest
    private static void nodeIncludeIfConditionAndVariableTest() {
        GraphQLField node = new GraphQLField().includeIf(false).includeIf('var');

        Assert.isTrue(node.hasDirectives());
        Assert.areEqual(2, node.directives.size());
    }

    @IsTest
    private static void nodeSkipIfConditionAndVariableTest() {
        GraphQLField node = new GraphQLField().skipIf(false).skipIf('var');

        Assert.isTrue(node.hasDirectives());
        Assert.areEqual(2, node.directives.size());
    }

    @IsTest
    private static void nodeAsQueryTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLQuery query = new GraphQLField('Test', nodes).asQuery();

        Assert.areEqual('Test', query.name);
        Assert.areEqual(nodes.size(), query.nodes.size());
        Assert.areEqual(0, query.variables.size());
        Assert.areEqual('query Test{node1,node2}', query.toString());
    }

    @IsTest
    private static void nodeAsMutationTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLMutation mutation = new GraphQLField('Test', nodes).asMutation();

        Assert.areEqual('Test', mutation.name);
        Assert.areEqual(nodes.size(), mutation.nodes.size());
        Assert.areEqual(0, mutation.variables.size());
        Assert.areEqual('mutation Test{node1,node2}', mutation.toString());
    }

    @IsTest
    private static void nodeAsSubscriptionTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLSubscription subscription = new GraphQLField('Test', nodes).asSubscription();

        Assert.areEqual('Test', subscription.name);
        Assert.areEqual(nodes.size(), subscription.nodes.size());
        Assert.areEqual(0, subscription.variables.size());
        Assert.areEqual('subscription Test{node1,node2}', subscription.toString());
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildNodeWithAliasPositiveTest() {
        GraphQLField childNode = new GraphQLField('countries', new List<String> { 'name', 'code' }).byAlias('ctrs');

        GraphQLField node = new GraphQLField(new List<GraphQLField> { childNode });

        Assert.areEqual('{ctrs:countries{name,code}}', node.build());
        Assert.areEqual('{\n  ctrs: countries {\n    name\n    code\n  }\n}', node.build(true));
    }

    @IsTest
    private static void buildNodePositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLField node = new GraphQLField().withFields(fields).withFragment('SomeFields');

        Assert.areEqual(GraphQLConstants.EMPTY, node.name);
        Assert.areEqual(fields.size() + 1, node.nodes.size());
        Assert.areEqual('{field1,field2,field3,...SomeFields}', node.build());
        Assert.areEqual('{\n  field1\n  field2\n  field3\n  ...SomeFields\n}', node.build(true));
    }

    @IsTest
    private static void buildNodeWithInlineFragmentPositiveTest() {
        GraphQLFragment inlineFragment = new GraphQLFragment('SomeType').withField('field11');

        GraphQLField node = new GraphQLField()
            .withField('field1')
            .withFragment('SomeFields')
            .withInlineFragment(inlineFragment);

        Assert.areEqual(3, node.nodes.size());
        Assert.areEqual('{field1,...SomeFields,... on SomeType{field11}}', node.build());
        Assert.areEqual('{\n  field1\n  ...SomeFields\n  ... on SomeType {\n    field11\n  }\n}', node.build(true));
    }

    @IsTest
    private static void buildNodeAsQueryPositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLQuery query = new GraphQLField().withFields(fields).withArgument('arg', 'value').asQuery();

        Assert.isTrue(String.isBlank(query.name));
        Assert.areEqual(fields.size(), query.nodes.size());
        Assert.areEqual('query{field1,field2,field3}', query.build());
        Assert.areEqual('query {\n  field1\n  field2\n  field3\n}', query.build(true));
    }

    @IsTest
    private static void buildNodeAsMutationPositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLMutation mutation = new GraphQLField().withFields(fields).withArgument('arg', 'value').asMutation();

        Assert.isTrue(String.isBlank(mutation.name));
        Assert.areEqual(fields.size(), mutation.nodes.size());
        Assert.areEqual('mutation{field1,field2,field3}', mutation.build());
        Assert.areEqual('mutation {\n  field1\n  field2\n  field3\n}', mutation.build(true));
    }

    @IsTest
    private static void buildNodeAsSubscriptionPositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLSubscription subscription = new GraphQLField()
            .withFields(fields)
            .withArgument('arg', 'value')
            .asSubscription();

        Assert.isTrue(String.isBlank(subscription.name));
        Assert.areEqual(fields.size(), subscription.nodes.size());
        Assert.areEqual('subscription{field1,field2,field3}', subscription.build());
        Assert.areEqual('subscription {\n  field1\n  field2\n  field3\n}', subscription.build(true));
    }

    @IsTest
    private static void buildNodeWithChildrenPositiveTest() {
        String firstMethodName = 'testMethod1';
        String secondMethodName = 'testMethod2';
        List<String> firstMethodFields = new List<String> { 'field1', 'field2' };
        List<String> secondMethodFields = new List<String> { 'field3', 'field4' };
        List<String> childrenNodeFields = new List<String> { 'field11', 'field22' };

        GraphQLField firstNode = new GraphQLField(firstMethodName, firstMethodFields);

        GraphQLField secondNode = new GraphQLField(secondMethodName)
            .withField(new GraphQLField('field3', childrenNodeFields))
            .withField('field4');

        List<GraphQLField> childrenNodes = new List<GraphQLField> { firstNode, secondNode };

        GraphQLField rootNode = new GraphQLField(childrenNodes);

        Assert.areEqual(firstMethodName, firstNode.name);
        Assert.areEqual(secondMethodName, secondNode.name);
        Assert.areEqual(GraphQLConstants.EMPTY, rootNode.name);
        Assert.areEqual(firstMethodFields.size(), firstNode.nodes.size());
        Assert.areEqual(secondMethodFields.size(), secondNode.nodes.size());
        Assert.areEqual(childrenNodes.size(), rootNode.nodes.size());
        Assert.areEqual('{testMethod1{field1,field2},testMethod2{field3{field11,field22},field4}}', rootNode.build());
        Assert.areEqual(
            '{\n  testMethod1 {\n    field1\n    field2\n  }\n  testMethod2 {\n    field3 {\n      field11\n      field22\n    }\n    field4\n  }\n}',
            rootNode.build(true)
        );
    }

    @IsTest
    private static void buildNodeWithArgumentsPositiveTest() {
        String nodeName = 'testMethod';
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLField node = new GraphQLField(nodeName, fields)
            .withArgument('var1', 'test1')
            .withArgument('var2', 1)
            .withArgument('var3', new Map<String, Object> { 'f1' => 1, 'f2' => '2', 'f3' => '$ref' });

        GraphQLField rootNode = new GraphQLField('root').withField(node);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(fields.size(), node.nodes.size());
        Assert.areEqual(
            'root{testMethod(var1:"test1",var2:1,var3:{f3:$ref,f2:"2",f1:1}){field1,field2,field3}}',
            rootNode.build()
        );
        Assert.areEqual(
            'root {\n  testMethod(var1: "test1", var2: 1, var3: { f3: $ref, f2: "2", f1: 1 }) {\n    field1\n    field2\n    field3\n  }\n}',
            rootNode.build(true)
        );
    }

    @IsTest
    private static void buildNodeWithDirectivePositiveTest() {
        String nodeName = 'testMethod';
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLField node = new GraphQLField(nodeName, fields)
            .includeIf(true)
            .skipIf('test1')
            .withArgument('var1', '$test1');

        GraphQLField rootNode = new GraphQLField('root').withField(node);

        Assert.areEqual(
            'root{testMethod(var1:$test1)@include(if:true) @skip(if:$test1){field1,field2,field3}}',
            rootNode.build()
        );
        Assert.areEqual(
            'root {\n  testMethod(var1: $test1) @include(if: true) @skip(if: $test1) {\n    field1\n    field2\n    field3\n  }\n}',
            rootNode.build(true)
        );
    }

    @IsTest
    private static void buildNodeWithDeepNestingNegativeTest() {
        Integer depthLevel = 20;
        GraphQLField node = new GraphQLField();
        GraphQLField prevNode;
        for (Integer i = 0; i < depthLevel; i++) {
            GraphQLField newNode = new GraphQLField('node' + i);
            if (prevNode == null) {
                prevNode = node;
            }
            prevNode.withField(newNode);
            prevNode = newNode;
        }

        Exception error;
        try {
            node.build();
        } catch (Exception err) {
            error = err;
        }

        Assert.isNotNull(error);
        Assert.isTrue(error.getMessage().startsWith('Maximum request depth level is'));
    }

    @IsTest
    private static void buildEmptyNodeWithoutChildrenNegativeTest() {
        GraphQLField node = new GraphQLField();

        Exception error;
        try {
            node.build();
        } catch (Exception err) {
            error = err;
        }

        Assert.isNotNull(error);
        Assert.areEqual('Cannot parse an empty node without any child nodes', error.getMessage());
    }

    @IsTest
    private static void getNodeParserNegativeTest() {
        Exception error;
        try {
            new TestNode().build();
        } catch (Exception ex) {
            error = ex;
        }

        Assert.isNotNull(error);
        Assert.isInstanceOfType(error, GraphQLNode.GraphQLNodeException.class);
    }

    private class TestNode extends GraphQLNode {
        private TestNode() {
            super(GraphQLConstants.EMPTY, new List<String>());
        }
    }
}
