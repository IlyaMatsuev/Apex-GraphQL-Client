@IsTest(isParallel = true)
private class GraphQLVariableTest {
    @IsTest
    private static void createVariableTest() {
        GraphQLVariable variable = new GraphQLVariable('key', 'Int');

        Assert.areEqual('key', variable.name);
        Assert.areEqual('Int', variable.type);
        Assert.isNull(variable.defaultValue);
        Assert.isFalse(variable.isNonNull);
        Assert.areEqual('$key:Int', variable.toString());
        Assert.areEqual('$key: Int', variable.toString(true));
    }

    @IsTest
    private static void createVariableAsNonNullTest() {
        GraphQLVariable variable = new GraphQLVariable('key', 'Int').asNonNull();

        Assert.areEqual('key', variable.name);
        Assert.areEqual('Int', variable.type);
        Assert.isNull(variable.defaultValue);
        Assert.isTrue(variable.isNonNull);
        Assert.areEqual('$key:Int!', variable.toString());
        Assert.areEqual('$key: Int!', variable.toString(true));
    }

    @IsTest
    private static void createNonNullVariableTest() {
        GraphQLVariable variable = new GraphQLVariable('key', 'Int!');

        Assert.areEqual('key', variable.name);
        Assert.areEqual('Int', variable.type);
        Assert.isNull(variable.defaultValue);
        Assert.isTrue(variable.isNonNull);
        Assert.areEqual('$key:Int!', variable.toString());
        Assert.areEqual('$key: Int!', variable.toString(true));
    }

    @IsTest
    private static void createNonNullVariableWithDollarNameTest() {
        GraphQLVariable variable = new GraphQLVariable('$key', 'Int!');

        Assert.areEqual('key', variable.name);
        Assert.areEqual('Int', variable.type);
        Assert.isNull(variable.defaultValue);
        Assert.isTrue(variable.isNonNull);
        Assert.areEqual('$key:Int!', variable.toString());
        Assert.areEqual('$key: Int!', variable.toString(true));
    }

    @IsTest
    private static void createVariableWithDefaultStringValueTest() {
        GraphQLVariable variable = new GraphQLVariable('$key', 'String').withDefault('hello world!');

        Assert.areEqual('key', variable.name);
        Assert.areEqual('String', variable.type);
        Assert.areEqual('hello world!', variable.defaultValue);
        Assert.isTrue(!variable.isNonNull);
        Assert.areEqual('$key:String="hello world!"', variable.toString());
        Assert.areEqual('$key: String = "hello world!"', variable.toString(true));
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
