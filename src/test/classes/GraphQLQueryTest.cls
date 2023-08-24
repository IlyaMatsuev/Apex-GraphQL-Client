@IsTest(isParallel = true)
private class GraphQLQueryTest {
    @IsTest
    private static void emptyQueryTest() {
        GraphQLQuery node = new GraphQLQuery();

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(0, node.nodes.size());
    }

    @IsTest
    private static void namedQueryTest() {
        String nodeName = 'Test';

        GraphQLQuery node = new GraphQLQuery(nodeName);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(0, node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithChildNodeTest() {
        GraphQLField childNode = new GraphQLField('node1');

        GraphQLQuery node = new GraphQLQuery(childNode);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(1, node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithChildNodesTest() {
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLQuery node = new GraphQLQuery(childNodes);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithChildNodeTest() {
        String nodeName = 'Test';

        GraphQLQuery node = new GraphQLQuery(nodeName, new GraphQLField('node1'));

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(1, node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithChildNodesTest() {
        String nodeName = 'Test';
        List<GraphQLField> childNodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLQuery node = new GraphQLQuery(nodeName, childNodes);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(childNodes.size(), node.nodes.size());
    }

    @IsTest
    private static void emptyQueryWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQuery node = new GraphQLQuery(fields);

        Assert.isTrue(String.isBlank(node.name));
        Assert.areEqual(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void namedQueryWithFieldsTest() {
        String nodeName = 'node';
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQuery node = new GraphQLQuery(nodeName, fields);

        Assert.areEqual(nodeName, node.name);
        Assert.areEqual(fields.size(), node.nodes.size());
    }

    @IsTest
    private static void queryWithFieldTest() {
        String fieldName = 'field1';

        GraphQLQuery node = new GraphQLQuery().withField(fieldName);

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(fieldName, node.nodes.get(0).name);
    }

    @IsTest
    private static void queryWithFieldsTest() {
        List<String> fields = new List<String> { 'field1', 'field2' };

        GraphQLQuery node = new GraphQLQuery().withFields(fields);

        Assert.areEqual(fields.size(), node.nodes.size());
        Assert.areEqual('field1', node.nodes.get(0).name);
        Assert.areEqual('field2', node.nodes.get(1).name);
    }

    @IsTest
    private static void queryWithFragmentDefinitionTest() {
        GraphQLFragment fragment = new GraphQLFragment('fragment1', 'Type1');

        GraphQLQuery node = new GraphQLQuery().defineFragment(fragment);

        Assert.isTrue(node.hasFragments());
        Assert.areEqual(1, node.fragments.size());
        Assert.areEqual(fragment.name, node.fragments.get(0).name);
    }

    @IsTest
    private static void queryWithFragmentDefinitionsTest() {
        List<GraphQLFragment> fragments = new List<GraphQLFragment> {
            new GraphQLFragment('fragment1', 'Type1'),
            new GraphQLFragment('fragment2', 'Type2')
        };

        GraphQLQuery node = new GraphQLQuery().defineFragments(fragments);

        Assert.isTrue(node.hasFragments());
        Assert.areEqual(fragments.size(), node.fragments.size());
        Assert.areEqual('fragment1', node.fragments.get(0).name);
        Assert.areEqual('fragment2', node.fragments.get(1).name);
    }

    @IsTest
    private static void queryWithDirectiveTest() {
        GraphQLQuery query = new GraphQLQuery().withDirective(new GraphQLDirective('test')).withField('field');

        Assert.areEqual(1, query.directives.size());
        Assert.areEqual('query@test{field}', query.build());
        Assert.areEqual('query @test {\n  field\n}', query.build(true));
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

        Assert.isNotNull(error);
        Assert.isInstanceOfType(error, GraphQLOperation.GraphQLOperationException.class);
    }

    @IsTest
    private static void queryWithFieldNodeTest() {
        String nodeName = 'node1';

        GraphQLQuery node = new GraphQLQuery().withField(new GraphQLField(nodeName));

        Assert.areEqual(1, node.nodes.size());
        Assert.areEqual(nodeName, node.nodes.get(0).name);
    }

    @IsTest
    private static void queryWithFieldNodesTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('node1'), new GraphQLField('node2') };

        GraphQLQuery node = new GraphQLQuery().withFields(nodes);

        Assert.areEqual(nodes.size(), node.nodes.size());
        Assert.areEqual('node1', node.nodes.get(0).name);
        Assert.areEqual('node2', node.nodes.get(1).name);
    }

    @IsTest
    private static void queryWithVariableDefinitionTest() {
        GraphQLQuery node = new GraphQLQuery()
            .withField(new GraphQLField('node'))
            .defineVariable('newVariable', '[Int]! = 0');

        Assert.areEqual(1, node.variables.size());
    }

    @IsTest
    private static void queryBuildRequestTest() {
        GraphQLRequest request = new GraphQLQuery(new List<String> { 'field1' }).asRequest();

        Assert.areEqual(GraphQLOperationType.Query, request.operation);
        Assert.areEqual('{"query":"query{field1}"}', request.toString());
        Assert.areEqual('{\n  "query" : "query {\\n  field1\\n}"\n}', request.toString(true));
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

        Assert.isTrue(String.isBlank(query.name));
        Assert.areEqual(nodes.size() + fields.size(), query.nodes.size());
        Assert.areEqual('query{field1,field2,field3,field4}', query.build());
        Assert.areEqual('query {\n  field1\n  field2\n  field3\n  field4\n}', query.build(true));
    }

    @IsTest
    private static void buildQueryWithDirectivePositiveTest() {
        List<GraphQLField> nodes = new List<GraphQLField> { new GraphQLField('field1'), new GraphQLField('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLQuery query = new GraphQLQuery()
            .withField(nodes.get(0))
            .withField(nodes.get(1))
            .withFields(fields)
            .withField('field3');

        Assert.isTrue(String.isBlank(query.name));
        Assert.areEqual(nodes.size() + fields.size(), query.nodes.size());
        Assert.areEqual('query{field1,field2,field3,field4}', query.build());
        Assert.areEqual('query {\n  field1\n  field2\n  field3\n  field4\n}', query.build(true));
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

        Assert.isTrue(String.isBlank(query.name));
        Assert.areEqual(nodes.size() + fields.size(), query.nodes.size());
        Assert.areEqual('query($param1:Int!,$param2:String){node1(arg:$param1),node2,field3,field4}', query.build());
        Assert.areEqual(
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

        Assert.areEqual('TestQuery', query.name);
        Assert.areEqual(nodes.size(), query.nodes.size());
        Assert.areEqual('query TestQuery{field1,field2{field21,field22},field3}', query.build());
        Assert.areEqual(
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

        Assert.areEqual(
            'query{node1{...Fields1},node2{...Fields2}}' +
                'fragment Fields1 on Type1{f1,f2}' +
                'fragment Fields2 on Type2{f3,f4}',
            query.build()
        );
        Assert.areEqual(
            'query {\n  node1 {\n    ...Fields1\n  }\n  node2 {\n    ...Fields2\n  }\n}\n' +
                'fragment Fields1 on Type1 {\n  f1\n  f2\n}\n' +
                'fragment Fields2 on Type2 {\n  f3\n  f4\n}',
            query.build(true)
        );
    }
}
