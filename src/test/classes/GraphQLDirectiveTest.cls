@IsTest(IsParallel = true)
private class GraphQLDirectiveTest {
    @IsTest
    private static void createDirectiveTest() {
        GraphQLDirective directive = new GraphQLDirective('test');
        System.assertEquals('test', directive.name);
        System.assert(!directive.hasArguments());
        System.assertEquals('@test', directive.toString());
        System.assertEquals('@test', directive.toString(true));
    }

    @IsTest
    private static void createDirectiveWithArgumentTest() {
        GraphQLDirective directive = new GraphQLDirective('include').withArgument('if', '$someVar');

        System.assertEquals('include', directive.name);
        System.assert(directive.hasArguments());
        System.assertEquals('@include(if:$someVar)', directive.toString());
        System.assertEquals('@include(if: $someVar)', directive.toString(true));
    }

    @IsTest
    private static void createDirectiveWithArgumentInstanceTest() {
        GraphQLDirective directive = new GraphQLDirective('include').withArgument(new GraphQLArgument('if', true));

        System.assertEquals('include', directive.name);
        System.assert(directive.hasArguments());
        System.assertEquals('@include(if:true)', directive.toString());
        System.assertEquals('@include(if: true)', directive.toString(true));
    }

    @IsTest
    private static void createDirectiveWithArgumentsTest() {
        GraphQLDirective directive = new GraphQLDirective('test')
            .withArgument(new GraphQLArgument('if', '$someVar'))
            .withArgument(new GraphQLArgument('elseif', true));

        System.assertEquals('test', directive.name);
        System.assert(directive.hasArguments());
        System.assertEquals('@test(if:$someVar,elseif:true)', directive.toString());
        System.assertEquals('@test(if: $someVar, elseif: true)', directive.toString(true));
    }
}
