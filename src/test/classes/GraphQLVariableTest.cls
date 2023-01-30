@IsTest(IsParallel = true)
private class GraphQLVariableTest {
    @IsTest
    private static void createVariableTest() {
        GraphQLVariable variable = new GraphQLVariable('key', 'Int');

        System.assertEquals('key', variable.name);
        System.assertEquals('Int', variable.type);
        System.assertEquals(null, variable.defaultValue);
        System.assert(!variable.isNonNull);
        System.assertEquals('$key:Int', variable.toString());
        System.assertEquals('$key: Int', variable.toString(true));
    }

    @IsTest
    private static void createVariableAsNonNullTest() {
        GraphQLVariable variable = new GraphQLVariable('key', 'Int').asNonNull();

        System.assertEquals('key', variable.name);
        System.assertEquals('Int', variable.type);
        System.assertEquals(null, variable.defaultValue);
        System.assert(variable.isNonNull);
        System.assertEquals('$key:Int!', variable.toString());
        System.assertEquals('$key: Int!', variable.toString(true));
    }

    @IsTest
    private static void createNonNullVariableTest() {
        GraphQLVariable variable = new GraphQLVariable('key', 'Int!');

        System.assertEquals('key', variable.name);
        System.assertEquals('Int', variable.type);
        System.assertEquals(null, variable.defaultValue);
        System.assert(variable.isNonNull);
        System.assertEquals('$key:Int!', variable.toString());
        System.assertEquals('$key: Int!', variable.toString(true));
    }

    @IsTest
    private static void createNonNullVariableWithDollarNameTest() {
        GraphQLVariable variable = new GraphQLVariable('$key', 'Int!');

        System.assertEquals('key', variable.name);
        System.assertEquals('Int', variable.type);
        System.assertEquals(null, variable.defaultValue);
        System.assert(variable.isNonNull);
        System.assertEquals('$key:Int!', variable.toString());
        System.assertEquals('$key: Int!', variable.toString(true));
    }

    @IsTest
    private static void createVariableWithWithDefaultStringValueTest() {
        GraphQLVariable variable = new GraphQLVariable('$key', 'String').withDefault('hello world!');

        System.assertEquals('key', variable.name);
        System.assertEquals('String', variable.type);
        System.assertEquals('hello world!', variable.defaultValue);
        System.assert(!variable.isNonNull);
        System.assertEquals('$key:String="hello world!"', variable.toString());
        System.assertEquals('$key: String = "hello world!"', variable.toString(true));
    }

    @IsTest
    private static void createVariableWithWithDefaultEnumValueTest() {
        GraphQLVariable variable = new GraphQLVariable('$key', 'SomeEnum').withDefault('ENUM_VAL').asEnum();

        System.assertEquals('key', variable.name);
        System.assertEquals('SomeEnum', variable.type);
        System.assertEquals('ENUM_VAL', variable.defaultValue);
        System.assert(!variable.isNonNull);
        System.assertEquals('$key:SomeEnum=ENUM_VAL', variable.toString());
        System.assertEquals('$key: SomeEnum = ENUM_VAL', variable.toString(true));
    }

    @IsTest
    private static void asEnumWithoutDefaultValueNegativeTest() {
        Exception error;
        try {
            new GraphQLVariable('$key', 'SomeEnum').asEnum();
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error instanceof GraphQLVariable.GraphQLVariableException);
    }
}
