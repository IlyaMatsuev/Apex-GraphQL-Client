@IsTest(isParallel = true)
private class GraphQLMutationTest {
    @IsTest
    private static void emptyMutationTest() {
        GraphQLMutation node = new GraphQLMutation();

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(0, node.nodes.size());
    }

    @IsTest
    private static void namedMutationTest() {
        String nodeName = 'Test';

        GraphQLMutation node = new GraphQLMutation(nodeName);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(0, node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithChildNodeTest() {
        GraphQLField childNode = new GraphQLField('node1');

        GraphQLMutation node = new GraphQLMutation(childNode);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(1, node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithChildNodesTest() {
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLMutation node = new GraphQLMutation(childNodes);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLMutation node = new GraphQLMutation(nodeName, new GraphQLField('node1'));

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(1, node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLMutation node = new GraphQLMutation(nodeName, childNodes);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLMutation node = new GraphQLMutation(fields);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLMutation node = new GraphQLMutation(nodeName, fields);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void mutationWithFieldTest() {
        String fieldName = 'field1';

        GraphQLMutation node = new GraphQLMutation().withField(fieldName);

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void mutationWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLMutation node = new GraphQLMutation().withFields(fields);

        Assert.areEqual(fields.size(), node.nodes.size());
        Assert.areEqual('field1', node.nodes.get(0).name);
        Assert.areEqual('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void mutationWithFragmentDefinitionTest() {
        GraphQLFragment fragment = new GraphQLFragment('fragment1', 'Type1');

        GraphQLMutation node = new GraphQLMutation().defineFragment(fragment);

        Assert.isTrue(node.hasFragments());
        Assert.areEqual(1, node.fragments.size());
        Assert.areEqual(fragment.name, node.fragments.get(0).name);
    }

    @IsTest
    private static void mutationWithFragmentDefinitionsTest() {
        List<GraphQLFragment> fragments = new List<GraphQLFragment> {
            new GraphQLFragment('fragment1', 'Type1'),
            new GraphQLFragment('fragment2', 'Type2')
        };

        GraphQLMutation node = new GraphQLMutation().defineFragments(fragments);

        Assert.isTrue(node.hasFragments());
        Assert.areEqual(fragments.size(), node.fragments.size());
        Assert.areEqual('fragment1', node.fragments.get(0).name);
        Assert.areEqual('fragment2', node.fragments.get(1).name);
    }

    @IsTest
    private static void mutationWithDirectiveTest() {
        GraphQLMutation mutation = new GraphQLMutation().withDirective(new GraphQLDirective('test')).withField('field');

        Assert.areEqual(1, mutation.directives.size());
        Assert.areEqual('mutation@test{field}', mutation.build());
        Assert.areEqual('mutation @test {\n  field\n}', mutation.build(true));
    }

    @IsTest
    private static void mutationWithFieldNodeTest() {
        String nodeName = 'node1';

        GraphQLMutation node = new GraphQLMutation().withField(new GraphQLField(nodeName));

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void mutationWithFieldNodesTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLMutation node = new GraphQLMutation().withFields(nodes);

        Assert.areEqual(nodes.size(), node.nodes.size());
        Assert.areEqual('node1', node.nodes.get(0).name);
        Assert.areEqual('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void mutationWithVariableDefinitionTest() {
        GraphQLMutation node = new GraphQLMutation()
            .withField(new GraphQLField('node'))
            .defineVariable('var', '[String!]');

        Assert.areEqual(1, node.variables.size());
    }

    @IsTest
    private static void mutationBuildRequestTest() {
        GraphQLRequest request = new GraphQLMutation(new List<String> { 'field1' }).asRequest();

        Assert.areEqual(GraphQLOperationType.Mutation, request.operation);
        Assert.areEqual('{"query":"mutation{field1}"}', request.toString());
        Assert.areEqual('{\n  "query" : "mutation {\\n  field1\\n}"\n}', request.toString(true));
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildMutationPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('field1'), new GraphQLField('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLMutation mutation = new GraphQLMutation()
            .withField(nodes.get(0))
            .withField(nodes.get(1))
            .withField(fields.get(0))
            .withField(fields.get(1));

        Assert.isTrue(String.isBlank(mutation.name));
        Assert.areEqual(nodes.size() + fields.size(), mutation.nodes.size());
        Assert.areEqual('mutation{field1,field2,field3,field4}', mutation.build());
        Assert.areEqual('mutation {\n  field1\n  field2\n  field3\n  field4\n}', mutation.build(true));
    }

    @IsTest
    private static void buildMutationWithVariableDefinitionPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLMutation mutation = new GraphQLMutation()
            .withFields(nodes)
            .withFields(fields)
            .defineVariable(new GraphQLVariable('model', 'InputType!').withDefault('hello world!'));

        Assert.isTrue(String.isBlank(mutation.name));
        Assert.areEqual(nodes.size() + fields.size(), mutation.nodes.size());
        Assert.areEqual('mutation($model:InputType!="hello world!"){node1,node2,field3,field4}', mutation.build());
        Assert.areEqual(
            'mutation ($model: InputType! = "hello world!") {\n  node1\n  node2\n  field3\n  field4\n}',
            mutation.build(true)
        );
    }

    @IsTest
    private static void buildMutationWithChildNodesPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('field1'),
            new GraphQLField(
                'field2',
                new List<GraphQLField> { new GraphQLField('field21'), new GraphQLField('field22') }
            ),
            new GraphQLField('field3')
        };

        GraphQLMutation mutation = new GraphQLMutation('TestMutation', nodes);

        Assert.areEqual('TestMutation', mutation.name);
        Assert.areEqual(nodes.size(), mutation.nodes.size());
        Assert.areEqual('mutation TestMutation{field1,field2{field21,field22},field3}', mutation.build());
        Assert.areEqual(
            'mutation TestMutation {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            mutation.build(true)
        );
    }
}
