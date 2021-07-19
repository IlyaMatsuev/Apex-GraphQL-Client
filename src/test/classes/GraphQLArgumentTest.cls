@IsTest(IsParallel = true)
private class GraphQLArgumentTest {
    
    @IsTest
    private static void createArgumentTest() {
        String key = 'key';
        String value = 'value';
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(key, argument.key);
        System.assertEquals(value, argument.value);
        System.assertEquals(type, type);
    }

    @IsTest
    private static void stringifyIntegerArgumentTest() {
        String key = 'key';
        Integer value = 111;
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('111', argument.toString());
    }

    @IsTest
    private static void stringifyLongArgumentTest() {
        String key = 'key';
        Long value = 1111111111;
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('1111111111', argument.toString());
    }

    @IsTest
    private static void stringifyDecimalArgumentTest() {
        String key = 'key';
        Decimal value = 111.11;
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('111.11', argument.toString());
    }

    @IsTest
    private static void stringifyDoubleArgumentTest() {
        String key = 'key';
        Double value = 111.11;
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('111.11', argument.toString());
    }

    @IsTest
    private static void stringifyBooleanArgumentTest() {
        String key = 'key';
        Boolean value = true;
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('true', argument.toString());
    }

    @IsTest
    private static void stringifyStringArgumentTest() {
        String key = 'key';
        String value = 'qqqq';
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES + value + CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyIdArgumentTest() {
        String key = 'key';
        Id value = UserInfo.getUserId();
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES + UserInfo.getUserId() + CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyBlobArgumentTest() {
        String key = 'key';
        Blob value = Blob.valueOf('qqqq');
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES + value + CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyDateArgumentTest() {
        String key = 'key';
        Date value = Date.today();
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES + value.format() + CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyDateTimeArgumentTest() {
        String key = 'key';
        DateTime value = DateTime.now();
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES + String.valueOf(value) + CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyObjectArgumentTest() {
        String key = 'key';
        Map<String, Object> value = new Map<String, Object> { 'key1' => 'value', 'key2' => 2 };
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        // Fields order is reversed
        System.assertEquals(
            '{key2:2,key1:"value"}',
            argument.toString()
        );
    }
}
