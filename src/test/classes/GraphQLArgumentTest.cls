@IsTest(isParallel = true)
private class GraphQLArgumentTest {
    @IsTest
    private static void createArgumentTest() {
        String key = 'key';
        String value = 'value';
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual(key, argument.key);
        Assert.areEqual(value, argument.value);
        Assert.areEqual(type, argument.type);
    }

    @IsTest
    private static void stringifyIntegerArgumentTest() {
        String key = 'key';
        Integer value = 111;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:111', argument.toString());
    }

    @IsTest
    private static void stringifyIntegerArgumentWithoutKeyTest() {
        GraphQLArgument argument = new GraphQLArgument(null, 123);
        Assert.areEqual('123', argument.toString());
    }

    @IsTest
    private static void stringifyLongArgumentTest() {
        String key = 'key';
        Long value = 1111111111;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:1111111111', argument.toString());
    }

    @IsTest
    private static void stringifyDecimalArgumentTest() {
        String key = 'key';
        Decimal value = 111.11;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:111.11', argument.toString());
    }

    @IsTest
    private static void stringifyDoubleArgumentTest() {
        String key = 'key';
        Double value = 111.11;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:111.11', argument.toString());
    }

    @IsTest
    private static void stringifyBooleanArgumentTest() {
        String key = 'key';
        Boolean value = true;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:true', argument.toString());
    }

    @IsTest
    private static void stringifyStringArgumentTest() {
        String key = 'key';
        String value = 'qqqq';

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:"qqqq"', argument.toString());
    }

    @IsTest
    private static void stringifyVariableArgumentTest() {
        String key = 'key';
        String value = '$variableName';

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:$variableName', argument.toString());
    }

    @IsTest
    private static void stringifyIdArgumentTest() {
        String key = 'key';
        Id value = UserInfo.getUserId();

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:"' + value + '"', argument.toString());
    }

    @IsTest
    private static void stringifyBlobArgumentTest() {
        String key = 'key';
        Blob value = Blob.valueOf('qqqq');

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:"' + value + '"', argument.toString());
    }

    @IsTest
    private static void stringifyDateArgumentTest() {
        String key = 'key';
        Date value = Date.today();
        DateTime dateValue = DateTime.newInstance(value.year(), value.month(), value.day());

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:"' + dateValue.format('MM/dd/yyyy') + '"', argument.toString());
    }

    @IsTest
    private static void stringifyDateTimeArgumentTest() {
        String key = 'key';
        DateTime value = DateTime.now();

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:"' + String.valueOf(value) + '"', argument.toString());
    }

    @IsTest
    private static void stringifyNullArgumentTest() {
        String key = 'key';

        GraphQLArgument argument = new GraphQLArgument(key, null);

        Assert.areEqual('key:null', argument.toString());
    }

    @IsTest
    private static void stringifyObjectArgumentTest() {
        String key = 'key';
        Map<String, Object> value = new Map<String, Object> {
            'key1' => 'value',
            'key2' => '$var',
            'key3' => 2,
            'key4' => new Map<String, Object> { 'key41' => '$var2', 'key42' => 'value:"$var2"     !' }
        };

        GraphQLArgument argument = new GraphQLArgument(key, value);

        // Fields order is reversed
        Assert.areEqual(
            'key: { key4: { key42: "value:\\"$var2\\"     !", key41: $var2 }, key3: 2, key2: $var, key1: "value" }',
            argument.toString(true)
        );
    }

    @IsTest
    private static void stringifyObjectArgumentWithoutKeyTest() {
        Map<String, Object> value = new Map<String, Object> {
            'key1' => 'value',
            'key2' => '$var',
            'key3' => 2,
            'key4' => new Map<String, Object> { 'key41' => '$var2', 'key42' => 'value:"$var2"     !' }
        };

        GraphQLArgument argument = new GraphQLArgument(null, value);

        // Fields order is reversed
        Assert.areEqual(
            '{ key4: { key42: "value:\\"$var2\\"     !", key41: $var2 }, key3: 2, key2: $var, key1: "value" }',
            argument.toString(true)
        );
    }

    @IsTest
    private static void stringifyEnumArgumentTest() {
        String key = 'key';
        GraphQLEnum value = new GraphQLEnum('VALUE');

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:VALUE', argument.toString());
        Assert.areEqual(argument.type, GraphQLArgumentType.x_Enum);
    }

    @IsTest
    private static void stringifyEnumArrayArgumentTest() {
        String key = 'key';
        List<GraphQLEnum> value = new List<GraphQLEnum> { new GraphQLEnum('VALUE1'), new GraphQLEnum('VALUE2') };

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:[VALUE1,VALUE2]', argument.toString());
        Assert.areEqual('key: [ VALUE1, VALUE2 ]', argument.toString(true));
        Assert.areEqual(argument.type, GraphQLArgumentType.x_List);
    }

    @IsTest
    private static void stringifyEnumInObjectArgumentTest() {
        String key = 'key';
        Map<String, Object> value = new Map<String, Object> {
            'key3' => new GraphQLEnum('VALUE3'),
            'key2' => new GraphQLEnum('VALUE2'),
            'key1' => 'value1'
        };

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:{key1:"value1",key2:VALUE2,key3:VALUE3}', argument.toString());
        Assert.areEqual('key: { key1: "value1", key2: VALUE2, key3: VALUE3 }', argument.toString(true));
        Assert.areEqual(argument.type, GraphQLArgumentType.x_Object);
    }

    @IsTest
    private static void stringifyStringArrayArgumentTest() {
        String key = 'key';
        List<String> value = new List<String> { 'value1', 'value2' };

        GraphQLArgument argument = new GraphQLArgument(key, value);

        Assert.areEqual('key:["value1","value2"]', argument.toString());
        Assert.areEqual('key: [ "value1", "value2" ]', argument.toString(true));
        Assert.areEqual(argument.type, GraphQLArgumentType.x_List);
    }
}
