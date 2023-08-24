@IsTest(isParallel = true)
private class GraphQLDirectiveTest {
    @IsTest
    private static void createDirectiveTest() {
        GraphQLDirective directive = new GraphQLDirective('test');
        Assert.areEqual('test', directive.name);
        Assert.isFalse(directive.hasArguments());
        Assert.areEqual('@test', directive.toString());
        Assert.areEqual('@test', directive.toString(true));
    }

    @IsTest
    private static void createDirectiveWithArgumentTest() {
        GraphQLDirective directive = new GraphQLDirective('include').withArgument('if', '$someVar');

        Assert.areEqual('include', directive.name);
        Assert.isTrue(directive.hasArguments());
        Assert.areEqual('@include(if:$someVar)', directive.toString());
        Assert.areEqual('@include(if: $someVar)', directive.toString(true));
    }

    @IsTest
    private static void createDirectiveWithArgumentInstanceTest() {
        GraphQLDirective directive = new GraphQLDirective('include').withArgument(new GraphQLArgument('if', true));

        Assert.areEqual('include', directive.name);
        Assert.isTrue(directive.hasArguments());
        Assert.areEqual('@include(if:true)', directive.toString());
        Assert.areEqual('@include(if: true)', directive.toString(true));
    }

    @IsTest
    private static void createDirectiveWithArgumentsTest() {
        GraphQLDirective directive = new GraphQLDirective('test')
            .withArgument(new GraphQLArgument('if', '$someVar'))
            .withArgument(new GraphQLArgument('elseif', true));

        Assert.areEqual('test', directive.name);
        Assert.isTrue(directive.hasArguments());
        Assert.areEqual('@test(if:$someVar,elseif:true)', directive.toString());
        Assert.areEqual('@test(if: $someVar, elseif: true)', directive.toString(true));
    }
}
