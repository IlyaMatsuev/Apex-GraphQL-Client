@IsTest(isParallel = true)
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
    private static void createVariableWithDefaultStringValueTest() {
        GraphQLVariable variable = new GraphQLVariable('$key', 'String').withDefault('hello world!');

        System.assertEquals('key', variable.name);
        System.assertEquals('String', variable.type);
        System.assertEquals('hello world!', variable.defaultValue);
        System.assert(!variable.isNonNull);
        System.assertEquals('$key:String="hello world!"', variable.toString());
        System.assertEquals('$key: String = "hello world!"', variable.toString(true));
    }

    @IsTest
    private static void createVariableWithDefaultEnumValueTest() {
        GraphQLVariable variable = new GraphQLVariable('$key', 'SomeEnum').withDefault(new GraphQLEnum('ENUM_VAL'));

        Assert.areEqual('key', variable.name);
        Assert.areEqual('SomeEnum', variable.type);
        Assert.areEqual('ENUM_VAL', variable.defaultValue?.toString());
        Assert.isFalse(variable.isNonNull);
        Assert.areEqual('$key:SomeEnum=ENUM_VAL', variable.toString());
        Assert.areEqual('$key: SomeEnum = ENUM_VAL', variable.toString(true));
    }

    @IsTest
    private static void createVariableWithDefaultEnumListValueTest() {
        GraphQLVariable variable = new GraphQLVariable('$key', 'SomeEnum')
            .withDefault(new List<GraphQLEnum> { new GraphQLEnum('ENUM_VAL1'), new GraphQLEnum('ENUM_VAL2') });

        Assert.areEqual('key', variable.name);
        Assert.areEqual('SomeEnum', variable.type);
        Assert.isInstanceOfType(variable.defaultValue, List<Object>.class);
        Assert.isFalse(variable.isNonNull);
        Assert.areEqual('$key:SomeEnum=[ENUM_VAL1,ENUM_VAL2]', variable.toString());
        Assert.areEqual('$key: SomeEnum = [ ENUM_VAL1, ENUM_VAL2 ]', variable.toString(true));
    }
}
