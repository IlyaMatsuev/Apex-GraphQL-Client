@IsTest(IsParallel=true)
private class GraphQLArgumentTest {
    @IsTest
    private static void createArgumentTest() {
        String key = 'key';
        String value = 'value';
        GraphQLArgumentType type = GraphQLArgumentType.x_String;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(key, argument.key);
        System.assertEquals(value, argument.value);
        System.assertEquals(type, argument.type);
    }

    @IsTest
    private static void stringifyIntegerArgumentTest() {
        String key = 'key';
        Integer value = 111;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('111', argument.toString());
    }

    @IsTest
    private static void stringifyLongArgumentTest() {
        String key = 'key';
        Long value = 1111111111;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('1111111111', argument.toString());
    }

    @IsTest
    private static void stringifyDecimalArgumentTest() {
        String key = 'key';
        Decimal value = 111.11;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('111.11', argument.toString());
    }

    @IsTest
    private static void stringifyDoubleArgumentTest() {
        String key = 'key';
        Double value = 111.11;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('111.11', argument.toString());
    }

    @IsTest
    private static void stringifyBooleanArgumentTest() {
        String key = 'key';
        Boolean value = true;

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals('true', argument.toString());
    }

    @IsTest
    private static void stringifyStringArgumentTest() {
        String key = 'key';
        String value = 'qqqq';

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES +
            value +
            CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyVariableArgumentTest() {
        String key = 'key';
        String value = '$variableName';

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(value, argument.toString());
    }

    @IsTest
    private static void stringifyIdArgumentTest() {
        String key = 'key';
        Id value = UserInfo.getUserId();

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES +
            UserInfo.getUserId() +
            CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyBlobArgumentTest() {
        String key = 'key';
        Blob value = Blob.valueOf('qqqq');

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES +
            value +
            CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyDateArgumentTest() {
        String key = 'key';
        Date value = Date.today();
        DateTime dateValue = DateTime.newInstance(value.year(), value.month(), value.day());

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES +
            dateValue.format('MM/dd/yyyy') +
            CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyDateTimeArgumentTest() {
        String key = 'key';
        DateTime value = DateTime.now();

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            CommonConstants.DOUBLE_QUOTES +
            String.valueOf(value) +
            CommonConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyNullArgumentTest() {
        String key = 'key';

        GraphQLArgument argument = new GraphQLArgument(key, null);

        System.assertEquals(((String) null), argument.toString());
    }

    @IsTest
    private static void stringifyObjectArgumentTest() {
        String key = 'key';
        Map<String, Object> value = new Map<String, Object>{ 'key1' => 'value', 'key2' => 2 };

        GraphQLArgument argument = new GraphQLArgument(key, value);

        // Fields order is reversed
        System.assertEquals('{key2:2,key1:"value"}', argument.toString());
    }

    @IsTest
    private static void parseStringArgumentTest() {
        String key = 'key';
        String value = 'value';

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            key +
            CommonConstants.COLON +
            CommonConstants.DOUBLE_QUOTES +
            value +
            CommonConstants.DOUBLE_QUOTES,
            argument.parse(null, false)
        );
        System.assertEquals(
            key +
            CommonConstants.COLON +
            CommonConstants.SPACE +
            CommonConstants.DOUBLE_QUOTES +
            value +
            CommonConstants.DOUBLE_QUOTES,
            argument.parse(null, true)
        );
    }
}
