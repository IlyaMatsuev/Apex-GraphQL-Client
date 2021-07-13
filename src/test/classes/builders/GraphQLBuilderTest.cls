@IsTest(IsParallel = true)
public class GraphQLBuilderTest {

    /**
     * TODO: Add tests
     * ~~~~~~~~
     * 1. Node generation with child nodes negative
     */


    /**
     * GraphQL Nodes creating tests below
     */

    @IsTest
    public static void createSimpleNodeWithRequestPositiveTest() {
        String nodeName = 'testMethod';
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };
        
        GraphQLNode node = new GraphQLBuilder(nodeName)
            .withFields(fields)
            .buildNode();

        GraphQLRequest request = new GraphQLBuilder('TestQuery')
            .withNode(node)
            .asQuery()
            .buildRequest();

        System.assert(node != null);
        System.assert(request != null);
        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('query TestQuery{testMethod{field1,field2,field3}}', request.asString());
        System.assertEquals(
            'query TestQuery {\n  testMethod {\n    field1\n    field2\n    field3\n  }\n}',
            request.asString(true)
        );
    }

    @IsTest
    public static void createNodeWithNestingWithRequestPositiveTest() {
        String firstMethodName = 'testMethod1';
        String secondMethodName = 'testMethod2';
        List<String> firstMethodFields = new List<String> { 'field1', 'field2' };
        List<String> secondMethodFields = new List<String> { 'field3', 'field4' };
        List<String> nestingNodeFields = new List<String> { 'field11', 'field22' };
        
        GraphQLNode firstNode = new GraphQLBuilder(firstMethodName)
            .withFields(firstMethodFields)
            .buildNode();

        GraphQLNode secondNode = new GraphQLBuilder(secondMethodName)
            .withNode(new GraphQLNode('field3', nestingNodeFields))
            .withField('field4')
            .buildNode();

        GraphQLRequest request = new GraphQLBuilder('TestQuery')
            .withNode(firstNode)
            .withNode(secondNode)
            .asQuery()
            .buildRequest();

        System.assert(firstNode != null);
        System.assert(secondNode != null);
        System.assert(request != null);
        System.assertEquals(firstMethodName, firstNode.name);
        System.assertEquals(secondMethodName, secondNode.name);
        System.assertEquals(firstMethodFields.size(), firstNode.nodes.size());
        System.assertEquals(secondMethodFields.size(), secondNode.nodes.size());
        System.assertEquals(
            'query TestQuery{testMethod1{field1,field2},testMethod2{field3{field11,field22},field4}}',
            request.asString()
        );
        System.assertEquals(
            'query TestQuery {\n  testMethod1 {\n    field1\n    field2\n  }\n  testMethod2 {\n    field3 {\n      field11\n      field22\n    }\n    field4\n  }\n}',
            request.asString(true)
        );
    }

    @IsTest
    public static void createNodeWithArgumentsInRequestPositiveTest() {
        String nodeName = 'testMethod';
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };
        
        GraphQLNode node = new GraphQLBuilder(nodeName)
            .withFields(fields)
            .withArgument('var1', 'test1')
            .withArgument('var2', 1)
            .withArgument('var3', new Map<String, Object> { 'f1' => 1, 'f2' => '2'})
            .buildNode();

        GraphQLRequest request = new GraphQLBuilder('TestQuery')
            .withNode(node)
            .asQuery()
            .buildRequest();

        System.assert(node != null);
        System.assert(request != null);
        System.assertEquals(nodeName, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals(
            'query TestQuery{testMethod(var1:"test1",var2:1,var3:{f2:"2",f1:1}){field1,field2,field3}}',
            request.asString()
        );
        System.assertEquals(
            'query TestQuery {\n  testMethod(var1: "test1", var2: 1, var3: {f2:"2",f1:1}) {\n    field1\n    field2\n    field3\n  }\n}',
            request.asString(true)
        );
    }
    
    /**
     * GraphQL Query tests below
     */

    @IsTest
    public static void simpleQueryPositiveRequestTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> { new GraphQLNode('field1'), new GraphQLNode('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLRequest request = new GraphQLBuilder('TestQuery')
            .withNodes(nodes)
            .withFields(fields)
            .withField('field3')
            .asQuery()
            .buildRequest();

        System.assert(request != null);
        System.assertEquals(GraphQLOperation.Query, request.operation);
        System.assertEquals(nodes.size() + fields.size(), request.asNode().nodes.size());
        System.assertEquals('query TestQuery{field1,field2,field3,field4}', request.asString());
        System.assertEquals(
            'query TestQuery {\n  field1\n  field2\n  field3\n  field4\n}',
            request.asString(true)
        );
    }

    @IsTest
    public static void queryWithNestingPositiveRequestTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('field1'),
            new GraphQLNode('field2', new List<GraphQLNode> { new GraphQLNode('field21'), new GraphQLNode('field22') }),
            new GraphQLNode('field3')
        };

        GraphQLRequest request = new GraphQLBuilder('TestQuery')
            .asQuery()
            .withNodes(nodes)
            .withField('field1')
            .asQuery()
            .buildRequest();

        System.assert(request != null);
        System.assertEquals(GraphQLOperation.Query, request.operation);
        System.assertEquals(nodes.size(), request.asNode().nodes.size());
        System.assertEquals(
            'query TestQuery{field1,field2{field21,field22},field3}',
            request.asString()
        );
        System.assertEquals(
            'query TestQuery {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            request.asString(true)
        );
    }

    /**
     * GraphQL Mutation tests below
     */

    @IsTest
    public static void simpleMutationPositiveRequestTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> { new GraphQLNode('field1'), new GraphQLNode('field2') };
        List<String> fields = new List<String> { 'field3', 'field4' };

        GraphQLRequest request = new GraphQLBuilder('TestMutation')
            .withNodes(nodes)
            .withField(fields.get(0))
            .withField(fields.get(1))
            .withField('field3')
            .asMutation()
            .buildRequest();

        System.assert(request != null);
        System.assertEquals(GraphQLOperation.Mutation, request.operation);
        System.assertEquals(nodes.size() + fields.size(), request.asNode().nodes.size());
        System.assertEquals('mutation TestMutation{field1,field2,field3,field4}', request.asString());
        System.assertEquals(
            'mutation TestMutation {\n  field1\n  field2\n  field3\n  field4\n}',
            request.asString(true)
        );
    }

    @IsTest
    public static void mutationWithNestingPositiveRequestTest() {
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('field1'),
            new GraphQLNode('field2', new List<GraphQLNode> { new GraphQLNode('field21'), new GraphQLNode('field22') }),
            new GraphQLNode('field3')
        };

        GraphQLRequest request = new GraphQLBuilder('TestMutation')
            .asMutation()
            .withNodes(nodes)
            .withField('field1')
            .asMutation()
            .buildRequest();

        System.assert(request != null);
        System.assertEquals(GraphQLOperation.Mutation, request.operation);
        System.assertEquals(nodes.size(), request.asNode().nodes.size());
        System.assertEquals(
            'mutation TestMutation{field1,field2{field21,field22},field3}',
            request.asString()
        );
        System.assertEquals(
            'mutation TestMutation {\n  field1\n  field2 {\n    field21\n    field22\n  }\n  field3\n}',
            request.asString(true)
        );
    }
}
