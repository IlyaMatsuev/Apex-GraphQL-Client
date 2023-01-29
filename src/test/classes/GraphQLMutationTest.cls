@IsTest(IsParallel = true)
private class GraphQLMutationTest {
    @IsTest
    private static void emptyMutationTest() {
        GraphQLMutation node = new GraphQLMutation();

        System.assert(String.isBlank(node.name));
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void namedMutationTest() {
        String nodeName = 'Test';

        GraphQLMutation node = new GraphQLMutation(nodeName);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithChildNodeTest() {
        GraphQLField childNode = new GraphQLField('node1');

        GraphQLMutation node = new GraphQLMutation(childNode);

        System.assert(String.isBlank(node.name));
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithChildNodesTest() {
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLMutation node = new GraphQLMutation(childNodes);

        System.assert(String.isBlank(node.name));
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLMutation node = new GraphQLMutation(nodeName, new GraphQLField('node1'));

        System.assertEquals(nodeName, node.name);
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLMutation node = new GraphQLMutation(nodeName, childNodes);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void emptyMutationWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLMutation node = new GraphQLMutation(fields);

        System.assert(String.isBlank(node.name));
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void namedMutationWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLMutation node = new GraphQLMutation(nodeName, fields);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void mutationWithFieldTest() {
        String fieldName = 'field1';

        GraphQLMutation node = new GraphQLMutation().withField(fieldName);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void mutationWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLMutation node = new GraphQLMutation().withFields(fields);

        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('field1', node.nodes.get(0).name);
        System.assertEquals('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void mutationWithFragmentDefinitionTest() {
        GraphQLFragment fragment = new GraphQLFragment('fragment1', 'Type1');

        GraphQLMutation node = new GraphQLMutation().defineFragment(fragment);

        System.assert(node.hasFragments());
        System.assertEquals(1, node.fragments.size());
        System.assertEquals(fragment.name, node.fragments.get(0).name);
    }

    @IsTest
    private static void mutationWithFragmentDefinitionsTest() {
        List<GraphQLFragment> fragments = new List<GraphQLFragment> {
            new GraphQLFragment('fragment1', 'Type1'),
            new GraphQLFragment('fragment2', 'Type2')
        };

        GraphQLMutation node = new GraphQLMutation().defineFragments(fragments);

        System.assert(node.hasFragments());
        System.assertEquals(fragments.size(), node.fragments.size());
        System.assertEquals('fragment1', node.fragments.get(0).name);
        System.assertEquals('fragment2', node.fragments.get(1).name);
    }

    @IsTest
    private static void mutationWithFieldNodeTest() {
        String nodeName = 'node1';

        GraphQLMutation node = new GraphQLMutation().withField(new GraphQLField(nodeName));

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void mutationWithFieldNodesTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLMutation node = new GraphQLMutation().withFields(nodes);

        System.assertEquals(nodes.size(), node.nodes.size());
        System.assertEquals('node1', node.nodes.get(0).name);
        System.assertEquals('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void mutationWithVariableDefinitionTest() {
        GraphQLMutation node = new GraphQLMutation()
            .withField(new GraphQLField('node'))
            .defineVariable('var', '[String!]');

        System.assertEquals(1, node.variables.size());
    }

    @IsTest
    private static void mutationBuildRequestTest() {
        GraphQLRequest request = new GraphQLMutation(new List<String> { 'field1' }).asRequest();

        System.assertEquals(GraphQLOperationType.Mutation, request.operation);
        System.assertEquals('{"query":"mutation{field1}"}', request.toString());
        System.assertEquals('{\n  "query" : "mutation {\\n  field1\\n}"\n}', request.toString(true));
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

        System.assert(mutation != null);
        System.assert(String.isBlank(mutation.name));
        System.assertEquals(nodes.size() + fields.size(), mutation.nodes.size());
        System.assertEquals('mutation{field1,field2,field3,field4}', mutation.build());
        System.assertEquals('mutation {\n  field1\n  field2\n  field3\n  field4\n}', mutation.build(true));
    }

    @IsTest
    private static void buildMutationWithVariableDefinitionPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLMutation mutation = new GraphQLMutation()
            .withFields(nodes)
            .withFields(fields)
            .defineVariable(new GraphQLVariable('model', 'InputType!').withDefault('hello world!'));

        System.assert(mutation != null);
        System.assert(String.isBlank(mutation.name));
        System.assertEquals(nodes.size() + fields.size(), mutation.nodes.size());
        System.assertEquals('mutation($model:InputType!="hello world!"){node1,node2,field3,field4}', mutation.build());
        System.assertEquals(
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

        System.assert(mutation != null);
        System.assertEquals('TestMutation', mutation.name);
        System.assertEquals(nodes.size(), mutation.nodes.size());
        System.assertEquals('mutation TestMutation{field1,field2{field21,field22},field3}', mutation.build());
        System.assertEquals(
            'mutation TestMutation {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            mutation.build(true)
        );
    }
}
