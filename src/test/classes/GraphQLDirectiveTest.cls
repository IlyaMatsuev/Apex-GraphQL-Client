@IsTest(IsParallel = true)
private class GraphQLDirectiveTest {
    @IsTest
    private static void parseDirectiveWithBooleanPositiveTest() {
        Boolean include = true;
        GraphQLDirective includeDirective = new GraphQLDirective(GraphQLDirectiveType.Include, include);

        System.assertEquals('@include(if:true)', includeDirective.toString());
        System.assertEquals('@include(if: true)', includeDirective.toString(true));
    }

    @IsTest
    private static void parseDirectiveWithVariablePositiveTest() {
        String var = 'var';
        GraphQLDirective includeDirective = new GraphQLDirective(GraphQLDirectiveType.Include, var);

        System.assertEquals('@include(if:$var)', includeDirective.toString());
        System.assertEquals('@include(if: $var)', includeDirective.toString(true));
    }

    @IsTest
    private static void createDirectiveWithNullArgumentNegativeTest() {
        Exception error;
        try {
            new GraphQLDirective(GraphQLDirectiveType.Include, (String) null);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error instanceof GraphQLDirective.GraphQLDirectiveException);
    }
}
