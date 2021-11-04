@IsTest(IsParallel=true)
private class GraphQLDirectiveTest {
    @IsTest
    private static void parseDirectiveWithBooleanPositiveTest() {
        Boolean include = true;
        GraphQLDirective includeDirective = new GraphQLDirective(
            GraphQLDirectiveType.Include,
            include
        );

        System.assertEquals('@include(if: true)', includeDirective.parse(null, true));
        System.assertEquals('@include(if:true)', includeDirective.parse(null, false));
    }

    @IsTest
    private static void parseDirectiveWithVariablePositiveTest() {
        String var = 'var';
        GraphQLDirective includeDirective = new GraphQLDirective(GraphQLDirectiveType.Include, var);

        System.assertEquals('@include(if: $var)', includeDirective.parse(null, true));
        System.assertEquals('@include(if:$var)', includeDirective.parse(null, false));
    }

    @IsTest
    private static void createDirectiveWithNullArgumentNegativeTest() {
        Exception error;
        try {
            new GraphQLDirective(GraphQLDirectiveType.Include, null);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assertEquals(Label.NullDirectiveArgumentError, error.getMessage());
    }

    @IsTest
    private static void createDirectiveWithIntegerArgumentNegativeTest() {
        Exception error;
        try {
            new GraphQLDirective(GraphQLDirectiveType.Include, 5);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assertEquals(Label.DirectiveArgumentInvalidTypeError, error.getMessage());
    }
}
