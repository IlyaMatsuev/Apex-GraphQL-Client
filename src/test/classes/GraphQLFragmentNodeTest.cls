@IsTest(IsParallel = true)
private class GraphQLFragmentNodeTest {
    @IsTest
    private static void emptyFragmentTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type);

        System.assert(fragment.isFragmentNode());
        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(!fragment.hasNodes());
    }

    @IsTest
    private static void fragmentWithFieldsTest() {
        String name = 'Fields';
        String type = 'SomeType';
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type, fields);

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(fields.size(), fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithNodesTest() {
        String name = 'Fields';
        String type = 'SomeType';
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('node1', new List<String> { 'field' }),
            new GraphQLNode('node2', new List<String> { 'field1', 'field2' })
        };
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type, nodes);

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(nodes.size(), fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithNodesAndFieldsTest() {
        String name = 'Fields';
        String type = 'SomeType';
        List<GraphQLNode> nodes = new List<GraphQLNode> {
            new GraphQLNode('node1', new List<String> { 'field' }),
            new GraphQLNode('node2', new List<String> { 'field1', 'field2' })
        };
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type, nodes, fields);

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(nodes.size() + fields.size(), fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithFieldTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type).withField('field1');

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithNodeTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type)
            .withNode(new GraphQLNode('node', new List<String> { 'field1', 'field2' }));

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithFragmentTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type).withFragment('OtherFields');

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithDirectiveTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type)
            .withField('field1')
            .withField('field2')
            .includeIf(true);

        System.assert(fragment.hasNodes());
        System.assert(fragment.hasDirectives());
        System.assertEquals(2, fragment.nodes.size());
        System.assertEquals(1, fragment.directives.size());
        System.assertEquals('fragment Fields on SomeType @include(if:true){field1,field2}', fragment.build());
        System.assertEquals(
            'fragment Fields on SomeType @include(if: true) {\n  field1\n  field2\n}',
            fragment.build(true)
        );
    }

    @IsTest
    private static void fragmentWithInlineFragmentTest() {
        GraphQLFragmentNode inlineFragment = new GraphQLFragmentNode('SomeType2').withField('field1');
        GraphQLFragmentNode fragment = new GraphQLFragmentNode('Fields', 'SomeType').withInlineFragment(inlineFragment);

        System.assert(fragment.hasNodes());
        System.assertEquals(1, fragment.nodes.size());
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void buildFragmentNodePositiveTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragmentNode fragment = new GraphQLFragmentNode(name, type)
            .withFields(new List<String> { 'field1', 'field2' })
            .withNode(new GraphQLNode('node', new List<String> { 'field1', 'field2' }))
            .withInlineFragment(new GraphQLFragmentNode('SomeType2').withField('field11'))
            .withInlineFragment(new GraphQLFragmentNode().includeIf('var').withField('field22'));

        System.assertEquals(
            'fragment Fields on SomeType{field1,field2,node{field1,field2},... on SomeType2{field11},... @include(if:$var){field22}}',
            fragment.build()
        );
        System.assertEquals(
            'fragment Fields on SomeType {\n  field1\n  field2\n  node {\n    field1\n    field2\n  }\n  ... on SomeType2 {\n    field11\n  }\n  ... @include(if: $var) {\n    field22\n  }\n}',
            fragment.build(true)
        );
    }
}
