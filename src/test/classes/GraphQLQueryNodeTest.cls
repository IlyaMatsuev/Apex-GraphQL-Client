@IsTest(IsParallel = true)
private class GraphQLQueryNodeTest {
    @IsTest
    private static void emptyQueryTest() {
        GraphQLQueryNode node = new GraphQLQueryNode();

        System.assert(String.isBlank(node.name));
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void namedQueryTest() {
        String nodeName = 'Test';

        GraphQLQueryNode node = new GraphQLQueryNode(nodeName);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithChildNodeTest() {
        GraphQLNode childNode = new GraphQLNode('node1');

        GraphQLQueryNode node = new GraphQLQueryNode(childNode);

        System.assert(String.isBlank(node.name));
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithChildNodesTest() {
        List<GraphQLNode> childNodes = new List<GraphQLNode> { new GraphQLNode('node1'), new GraphQLNode('node2') };

        GraphQLQueryNode node = new GraphQLQueryNode(childNodes);

        System.assert(String.isBlank(node.name));
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLQueryNode node = new GraphQLQueryNode(nodeName, new GraphQLNode('node1'));

        System.assertEquals(nodeName, node.name);
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLNode> childNodes = new List<GraphQLNode> { new GraphQLNode('node1'), new GraphQLNode('node2') };

        GraphQLQueryNode node = new GraphQLQueryNode(nodeName, childNodes);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQueryNode node = new GraphQLQueryNode(fields);

        System.assert(String.isBlank(node.name));
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQueryNode node = new GraphQLQueryNode(nodeName, fields);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void queryWithFieldTest() {
        String fieldName = 'field1';

        GraphQLQueryNode node = new GraphQLQueryNode().withField(fieldName);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void queryWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQueryNode node = new GraphQLQueryNode().withFields(fields);

        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('field1', node.nodes.get(0).name);
        System.assertEquals('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void queryWithFragmentDefinitionTest() {
        GraphQLFragmentNode fragment = new GraphQLFragmentNode('fragment1', 'Type1');

        GraphQLQueryNode node = new GraphQLQueryNode().defineFragment(fragment);

        System.assert(node.hasFragments());
        System.assertEquals(1, node.fragments.size());
        System.assertEquals(fragment.name, node.fragments.get(0).name);
    }

    @IsTest
    private static void queryWithFragmentDefinitionsTest() {
        List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode> {
            new GraphQLFragmentNode('fragment1', 'Type1'),
            new GraphQLFragmentNode('fragment2', 'Type2')
        };

        GraphQLQueryNode node = new GraphQLQueryNode().defineFragments(fragments);

        System.assert(node.hasFragments());
        System.assertEquals(fragments.size(), node.fragments.size());
        System.assertEquals('fragment1', node.fragments.get(0).name);
        System.assertEquals('fragment2', node.fragments.get(1).name);
    }

    @IsTest
    private static void queryWithInlineFragmentDefinitionNegativeTest() {
        GraphQLFragmentNode fragment = new GraphQLFragmentNode('Type1');

        Exception error;
        try {
            new GraphQLQueryNode().defineFragment(fragment);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error instanceof GraphQLOperationNode.GraphQLOperationNodeException);
    }

    @IsTest
    private static void queryWithNodeTest() {
        String nodeName = 'node1';

        GraphQLQueryNode node = new GraphQLQueryNode().withNode(new GraphQLNode(nodeName));

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void queryWithNodesTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> { new GraphQLNode('node1'), new GraphQLNode('node2') };

        GraphQLQueryNode node = new GraphQLQueryNode().withNodes(nodes);

        System.assertEquals(nodes.size(), node.nodes.size());
        System.assertEquals('node1', node.nodes.get(0).name);
        System.assertEquals('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void queryWithVariableDefinitionTest() {
        GraphQLQueryNode node = new GraphQLQueryNode()
            .withNode(new GraphQLNode('node'))
            .defineVariable('newVariable', '[Int]! = 0');

        System.assertEquals(1, node.variables.size());
    }

    @IsTest
    private static void queryBuildRequestTest() {
        GraphQLRequest request = new GraphQLQueryNode(new List<String> { 'field1' }).asRequest();

        System.assertEquals(GraphQLOperation.Query, request.operation);
        System.assertEquals('{"query":"query{field1}"}', request.toString());
        System.assertEquals('{\n  "query" : "query {\\n  field1\\n}"\n}', request.toString(true));
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildQueryPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> { new GraphQLNode('field1'), new GraphQLNode('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLQueryNode query = new GraphQLQueryNode()
            .withNode(nodes.get(0))
            .withNode(nodes.get(1))
            .withFields(fields)
            .withField('field3');

        System.assert(query != null);
        System.assert(String.isBlank(query.name));
        System.assertEquals(nodes.size() + fields.size(), query.nodes.size());
        System.assertEquals('query{field1,field2,field3,field4}', query.build());
        System.assertEquals('query {\n  field1\n  field2\n  field3\n  field4\n}', query.build(true));
    }

    @IsTest
    private static void buildQueryWithVariableDefinitionsPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('node1').withArgument('arg', '$param1'),
            new GraphQLNode('node2')
        };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLQueryNode query = new GraphQLQueryNode()
            .withNodes(nodes)
            .withFields(fields)
            .defineVariable('param1', 'Int!')
            .defineVariable('param2', 'String');

        System.assert(query != null);
        System.assert(String.isBlank(query.name));
        System.assertEquals(nodes.size() + fields.size(), query.nodes.size());
        System.assertEquals(
            'query($param1:Int!,$param2:String){node1(arg:$param1),node2,field3,field4}',
            query.build()
        );
        System.assertEquals(
            'query ($param1: Int!, $param2: String) {\n  node1(arg: $param1)\n  node2\n  field3\n  field4\n}',
            query.build(true)
        );
    }

    @IsTest
    private static void buildQueryWithChildNodesPositiveTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('field1'),
            new GraphQLNode('field2', new List<GraphQLNode> { new GraphQLNode('field21'), new GraphQLNode('field22') }),
            new GraphQLNode('field3')
        };

        GraphQLQueryNode query = new GraphQLQueryNode('TestQuery', nodes).withField('field1');

        System.assert(query != null);
        System.assertEquals('TestQuery', query.name);
        System.assertEquals(nodes.size(), query.nodes.size());
        System.assertEquals('query TestQuery{field1,field2{field21,field22},field3}', query.build());
        System.assertEquals(
            'query TestQuery {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            query.build(true)
        );
    }

    @IsTest
    private static void buildQueryWithFragmentsPositiveTest() {
        List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode> {
            new GraphQLFragmentNode('Fields1', 'Type1', new List<String> { 'f1', 'f2' }),
            new GraphQLFragmentNode('Fields2', 'Type2', new List<String> { 'f3', 'f4' })
        };
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('node1').withFragment(fragments.get(0).name),
            new GraphQLNode('node2').withFragment(fragments.get(1).name)
        };

        GraphQLQueryNode query = new GraphQLQueryNode().withNodes(nodes).defineFragments(fragments);

        System.assertEquals(
            'query{node1{...Fields1},node2{...Fields2}}' +
            'fragment Fields1 on Type1{f1,f2}' +
            'fragment Fields2 on Type2{f3,f4}',
            query.build()
        );
        System.assertEquals(
            'query {\n  node1 {\n    ...Fields1\n  }\n  node2 {\n    ...Fields2\n  }\n}\n' +
            'fragment Fields1 on Type1 {\n  f1\n  f2\n}\n' +
            'fragment Fields2 on Type2 {\n  f3\n  f4\n}',
            query.build(true)
        );
    }
}
