@IsTest(IsParallel = true)
private class GraphQLFragmentTest {
    @IsTest
    private static void emptyFragmentTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type);

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
        GraphQLFragment fragment = new GraphQLFragment(name, type, fields);

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(fields.size(), fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithNodesTest() {
        String name = 'Fields';
        String type = 'SomeType';
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('node1', new List<String> { 'field' }),
            new GraphQLField('node2', new List<String> { 'field1', 'field2' })
        };
        GraphQLFragment fragment = new GraphQLFragment(name, type, nodes);

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(nodes.size(), fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithNodesAndFieldsTest() {
        String name = 'Fields';
        String type = 'SomeType';
        List<GraphQLField> nodes = new List<GraphQLField> {
            new GraphQLField('node1', new List<String> { 'field' }),
            new GraphQLField('node2', new List<String> { 'field1', 'field2' })
        };
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };
        GraphQLFragment fragment = new GraphQLFragment(name, type, nodes, fields);

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(nodes.size() + fields.size(), fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithFieldTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type).withField('field1');

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithNodeTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type)
            .withNode(new GraphQLField('node', new List<String> { 'field1', 'field2' }));

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithFragmentTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type).withFragment('OtherFields');

        System.assertEquals(name, fragment.name);
        System.assertEquals(type, fragment.type);
        System.assert(fragment.hasNodes());
        System.assertEquals(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithDirectivesTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type)
            .withField('field1')
            .withField('field2')
            .includeIf(true)
            .skipIf(false);

        System.assert(fragment.hasNodes());
        System.assert(fragment.hasDirectives());
        System.assertEquals(2, fragment.nodes.size());
        System.assertEquals(2, fragment.directives.size());
        System.assertEquals(
            'fragment Fields on SomeType @include(if:true) @skip(if:false){field1,field2}',
            fragment.build()
        );
        System.assertEquals(
            'fragment Fields on SomeType @include(if: true) @skip(if: false) {\n  field1\n  field2\n}',
            fragment.build(true)
        );
    }

    @IsTest
    private static void fragmentWithInlineFragmentTest() {
        GraphQLFragment inlineFragment = new GraphQLFragment('SomeType2').withField('field1');
        GraphQLFragment fragment = new GraphQLFragment('Fields', 'SomeType').withInlineFragment(inlineFragment);

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
        GraphQLFragment fragment = new GraphQLFragment(name, type)
            .withFields(new List<String> { 'field1', 'field2' })
            .withNode(new GraphQLField('node', new List<String> { 'field1', 'field2' }))
            .withInlineFragment(new GraphQLFragment('SomeType2').withField('field11'))
            .withInlineFragment(new GraphQLFragment().includeIf('var').skipIf('var2').withField('field22'));

        System.assertEquals(
            'fragment Fields on SomeType{field1,field2,node{field1,field2},... on SomeType2{field11},... @include(if:$var) @skip(if:$var2){field22}}',
            fragment.build()
        );
        System.assertEquals(
            'fragment Fields on SomeType {\n  field1\n  field2\n  node {\n    field1\n    field2\n  }\n  ... on SomeType2 {\n    field11\n  }\n  ... @include(if: $var) @skip(if: $var2) {\n    field22\n  }\n}',
            fragment.build(true)
        );
    }
}
