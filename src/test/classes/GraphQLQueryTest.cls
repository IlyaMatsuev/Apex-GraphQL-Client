@IsTest(IsParallel = true)
private class GraphQLQueryTest {
    @IsTest
    private static void emptyQueryTest() {
        GraphQLQuery node = new GraphQLQuery();

        System.assert(String.isBlank(node.name));
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void namedQueryTest() {
        String nodeName = 'Test';

        GraphQLQuery node = new GraphQLQuery(nodeName);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(0, node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithChildNodeTest() {
        GraphQLField childNode = new GraphQLField('node1');

        GraphQLQuery node = new GraphQLQuery(childNode);

        System.assert(String.isBlank(node.name));
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithChildNodesTest() {
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLQuery node = new GraphQLQuery(childNodes);

        System.assert(String.isBlank(node.name));
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLQuery node = new GraphQLQuery(nodeName, new GraphQLField('node1'));

        System.assertEquals(nodeName, node.name);
        System.assertEquals(1, node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLQuery node = new GraphQLQuery(nodeName, childNodes);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQuery node = new GraphQLQuery(fields);

        System.assert(String.isBlank(node.name));
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQuery node = new GraphQLQuery(nodeName, fields);

        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void queryWithFieldTest() {
        String fieldName = 'field1';

        GraphQLQuery node = new GraphQLQuery().withField(fieldName);

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void queryWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQuery node = new GraphQLQuery().withFields(fields);

        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('field1', node.nodes.get(0).name);
        System.assertEquals('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void queryWithFragmentDefinitionTest() {
        GraphQLFragment fragment = new GraphQLFragment('fragment1', 'Type1');

        GraphQLQuery node = new GraphQLQuery().defineFragment(fragment);

        System.assert(node.hasFragments());
        System.assertEquals(1, node.fragments.size());
        System.assertEquals(fragment.name, node.fragments.get(0).name);
    }

    @IsTest
    private static void queryWithFragmentDefinitionsTest() {
        List<GraphQLFragment> fragments = new List<GraphQLFragment> {
            new GraphQLFragment('fragment1', 'Type1'),
            new GraphQLFragment('fragment2', 'Type2')
        };

        GraphQLQuery node = new GraphQLQuery().defineFragments(fragments);

        System.assert(node.hasFragments());
        System.assertEquals(fragments.size(), node.fragments.size());
        System.assertEquals('fragment1', node.fragments.get(0).name);
        System.assertEquals('fragment2', node.fragments.get(1).name);
    }

    @IsTest
    private static void queryWithInlineFragmentDefinitionNegativeTest() {
        GraphQLFragment fragment = new GraphQLFragment('Type1');

        Exception error;
        try {
            new GraphQLQuery().defineFragment(fragment);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error instanceof GraphQLOperation.GraphQLOperationException);
    }

    @IsTest
    private static void queryWithFieldNodeTest() {
        String nodeName = 'node1';

        GraphQLQuery node = new GraphQLQuery().withField(new GraphQLField(nodeName));

        System.assertEquals(1, node.nodes.size());
        System.assertEquals(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void queryWithFieldNodesTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLQuery node = new GraphQLQuery().withFields(nodes);

        System.assertEquals(nodes.size(), node.nodes.size());
        System.assertEquals('node1', node.nodes.get(0).name);
        System.assertEquals('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void queryWithVariableDefinitionTest() {
        GraphQLQuery node = new GraphQLQuery()
            .withField(new GraphQLField('node'))
            .defineVariable('newVariable', '[Int]! = 0');

        System.assertEquals(1, node.variables.size());
    }

    @IsTest
    private static void queryBuildRequestTest() {
        GraphQLRequest request = new GraphQLQuery(new List<String> { 'field1' }).asRequest();

        System.assertEquals(GraphQLOperationType.Query, request.operation);
        System.assertEquals('{"query":"query{field1}"}', request.toString());
        System.assertEquals('{\n  "query" : "query {\\n  field1\\n}"\n}', request.toString(true));
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildQueryPositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('field1'), new GraphQLField('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLQuery query = new GraphQLQuery()
            .withField(nodes.get(0))
            .withField(nodes.get(1))
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
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('node1').withArgument('arg', '$param1'),
            new GraphQLField('node2')
        };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLQuery query = new GraphQLQuery()
            .withFields(nodes)
            .withFields(fields)
            .defineVariable(new GraphQLVariable('param1', 'Int').asNonNull())
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
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('field1'),
            new GraphQLField(
                'field2',
                new List<GraphQLField> { new GraphQLField('field21'), new GraphQLField('field22') }
            ),
            new GraphQLField('field3')
        };

        GraphQLQuery query = new GraphQLQuery('TestQuery', nodes).withField('field1');

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
        List<GraphQLFragment> fragments = new List<GraphQLFragment> {
            new GraphQLFragment('Fields1', 'Type1', new List<String> { 'f1', 'f2' }),
            new GraphQLFragment('Fields2', 'Type2', new List<String> { 'f3', 'f4' })
        };
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('node1').withFragment(fragments.get(0).name),
            new GraphQLField('node2').withFragment(fragments.get(1).name)
        };

        GraphQLQuery query = new GraphQLQuery().withFields(nodes).defineFragments(fragments);

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
