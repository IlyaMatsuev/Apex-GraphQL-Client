@IsTest(IsParallel = true)
public class GraphQLNodeTest {

    @IsTest
    public static void buildNodePositiveTest() {
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };

        GraphQLNode node = new GraphQLNode().withFields(fields);

        System.assert(node != null);
        System.assertEquals(CommonConstants.EMPTY, node.name);
        System.assertEquals(fields.size(), node.nodes.size());
        System.assertEquals('{field1,field2,field3}', node.build());
        System.assertEquals('{\n  field1\n  field2\n  field3\n}', node.build(true));
    }

    @IsTest
    public static void buildNodeWithChildrenPositiveTest() {
        String firstMethodName = 'testMethod1';
        String secondMethodName = 'testMethod2';
        List<String> firstMethodFields = new List<String> { 'field1', 'field2' };
        List<String> secondMethodFields = new List<String> { 'field3', 'field4' };
        List<String> childrenNodeFields = new List<String> { 'field11', 'field22' };
        
        GraphQLNode firstNode = new GraphQLNode(firstMethodName, firstMethodFields);

        GraphQLNode secondNode = new GraphQLNode(secondMethodName)
            .withNode(new GraphQLNode('field3', childrenNodeFields))
            .withField('field4');

        List<GraphQLNode> childrenNodes = new List<GraphQLNode> { firstNode, secondNode };

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
    public static void buildNodeWithArgumentsPositiveTest() {
        String nodeName = 'testMethod';
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };
        
        GraphQLNode node = new GraphQLNode(nodeName, fields)
            .withArgument('var1', 'test1')
            .withArgument('var2', 1)
            .withArgument('var3', new Map<String, Object> { 'f1' => 1, 'f2' => '2'});

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
}
