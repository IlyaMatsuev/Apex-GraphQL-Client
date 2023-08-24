@IsTest(isParallel = true)
private class GraphQLFragmentTest {
    @IsTest
    private static void emptyFragmentTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type);

        Assert.isTrue(fragment.isFragmentNode());
        Assert.areEqual(name, fragment.name);
        Assert.areEqual(type, fragment.type);
        Assert.isFalse(fragment.hasNodes());
    }

    @IsTest
    private static void fragmentWithFieldsTest() {
        String name = 'Fields';
        String type = 'SomeType';
        List<String> fields = new List<String> { 'field1', 'field2', 'field3' };
        GraphQLFragment fragment = new GraphQLFragment(name, type, fields);

        Assert.areEqual(name, fragment.name);
        Assert.areEqual(type, fragment.type);
        Assert.isTrue(fragment.hasNodes());
        Assert.areEqual(fields.size(), fragment.nodes.size());
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

        Assert.areEqual(name, fragment.name);
        Assert.areEqual(type, fragment.type);
        Assert.isTrue(fragment.hasNodes());
        Assert.areEqual(nodes.size(), fragment.nodes.size());
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

        Assert.areEqual(name, fragment.name);
        Assert.areEqual(type, fragment.type);
        Assert.isTrue(fragment.hasNodes());
        Assert.areEqual(nodes.size() + fields.size(), fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithFieldTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type).withField('field1');

        Assert.areEqual(name, fragment.name);
        Assert.areEqual(type, fragment.type);
        Assert.isTrue(fragment.hasNodes());
        Assert.areEqual(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithFieldNodeTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type)
            .withField(new GraphQLField('node', new List<String> { 'field1', 'field2' }));

        Assert.areEqual(name, fragment.name);
        Assert.areEqual(type, fragment.type);
        Assert.isTrue(fragment.hasNodes());
        Assert.areEqual(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithFragmentTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type).withFragment('OtherFields');

        Assert.areEqual(name, fragment.name);
        Assert.areEqual(type, fragment.type);
        Assert.isTrue(fragment.hasNodes());
        Assert.areEqual(1, fragment.nodes.size());
    }

    @IsTest
    private static void fragmentWithCustomDirectivesTest() {
        String name = 'Fields';
        String type = 'SomeType';
        GraphQLFragment fragment = new GraphQLFragment(name, type)
            .withField('field1')
            .withField('field2')
            .withDirective(new GraphQLDirective('include').withArgument('if', true))
            .withDirective(new GraphQLDirective('skip').withArgument('if', false));

        Assert.isTrue(fragment.hasNodes());
        Assert.isTrue(fragment.hasDirectives());
        Assert.areEqual(2, fragment.nodes.size());
        Assert.areEqual(2, fragment.directives.size());
        Assert.areEqual(
            'fragment Fields on SomeType@include(if:true) @skip(if:false){field1,field2}',
            fragment.build()
        );
        Assert.areEqual(
            'fragment Fields on SomeType @include(if: true) @skip(if: false) {\n  field1\n  field2\n}',
            fragment.build(true)
        );
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

        Assert.isTrue(fragment.hasNodes());
        Assert.isTrue(fragment.hasDirectives());
        Assert.areEqual(2, fragment.nodes.size());
        Assert.areEqual(2, fragment.directives.size());
        Assert.areEqual(
            'fragment Fields on SomeType@include(if:true) @skip(if:false){field1,field2}',
            fragment.build()
        );
        Assert.areEqual(
            'fragment Fields on SomeType @include(if: true) @skip(if: false) {\n  field1\n  field2\n}',
            fragment.build(true)
        );
    }

    @IsTest
    private static void fragmentWithInlineFragmentTest() {
        GraphQLFragment inlineFragment = new GraphQLFragment('SomeType2').withField('field1');
        GraphQLFragment fragment = new GraphQLFragment('Fields', 'SomeType').withInlineFragment(inlineFragment);

        Assert.isTrue(fragment.hasNodes());
        Assert.areEqual(1, fragment.nodes.size());
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
            .withField(new GraphQLField('node', new List<String> { 'field1', 'field2' }))
            .withInlineFragment(new GraphQLFragment('SomeType2').withField('field11'))
            .withInlineFragment(new GraphQLFragment().includeIf('var').skipIf('var2').withField('field22'));

        Assert.areEqual(
            'fragment Fields on SomeType{field1,field2,node{field1,field2},... on SomeType2{field11},...@include(if:$var) @skip(if:$var2){field22}}',
            fragment.build()
        );
        Assert.areEqual(
            'fragment Fields on SomeType {\n  field1\n  field2\n  node {\n    field1\n    field2\n  }\n  ... on SomeType2 {\n    field11\n  }\n  ... @include(if: $var) @skip(if: $var2) {\n    field22\n  }\n}',
            fragment.build(true)
        );
    }
}
