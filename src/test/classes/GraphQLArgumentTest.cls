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
            GraphQLConstants.DOUBLE_QUOTES +
            value +
            GraphQLConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyEnumArgumentTest() {
        String key = 'key';
        String value = 'VALUE';

        GraphQLArgument argument = new GraphQLArgument(key, value).asEnum();

        System.assertEquals(value, argument.toString());
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
            GraphQLConstants.DOUBLE_QUOTES +
            UserInfo.getUserId() +
            GraphQLConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyBlobArgumentTest() {
        String key = 'key';
        Blob value = Blob.valueOf('qqqq');

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            GraphQLConstants.DOUBLE_QUOTES +
            value +
            GraphQLConstants.DOUBLE_QUOTES,
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
            GraphQLConstants.DOUBLE_QUOTES +
            dateValue.format('MM/dd/yyyy') +
            GraphQLConstants.DOUBLE_QUOTES,
            argument.toString()
        );
    }

    @IsTest
    private static void stringifyDateTimeArgumentTest() {
        String key = 'key';
        DateTime value = DateTime.now();

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            GraphQLConstants.DOUBLE_QUOTES +
            String.valueOf(value) +
            GraphQLConstants.DOUBLE_QUOTES,
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
        Map<String, Object> value = new Map<String, Object> {
            'key1' => 'value',
            'key2' => '$var',
            'key3' => 2,
            'key4' => new Map<String, Object> { 'key41' => '$var2', 'key42' => 'value:"$var2"     !' }
        };

        GraphQLArgument argument = new GraphQLArgument(key, value);

        // Fields order is reversed
        System.assertEquals(
            '{ key4: { key42: "value:\\"$var2\\"     !", key41: $var2 }, key3: 2, key2: $var, key1: "value" }',
            argument.toString(true)
        );
    }

    @IsTest
    private static void parseStringArgumentTest() {
        String key = 'key';
        String value = 'value';

        GraphQLArgument argument = new GraphQLArgument(key, value);

        System.assertEquals(
            key +
            GraphQLConstants.COLON +
            GraphQLConstants.DOUBLE_QUOTES +
            value +
            GraphQLConstants.DOUBLE_QUOTES,
            argument.parse(null, false)
        );
        System.assertEquals(
            key +
            GraphQLConstants.COLON +
            GraphQLConstants.SPACE +
            GraphQLConstants.DOUBLE_QUOTES +
            value +
            GraphQLConstants.DOUBLE_QUOTES,
            argument.parse(null, true)
        );
    }

    @IsTest
    private static void parseEnumArgumentTest() {
        String key = 'key';
        String value = 'VALUE';

        GraphQLArgument argument = new GraphQLArgument(key, value).asEnum();

        System.assertEquals(key + GraphQLConstants.COLON + value, argument.parse(null, false));
        System.assertEquals(key + GraphQLConstants.COLON + GraphQLConstants.SPACE + value, argument.parse(null, true));
    }

    @IsTest
    private static void asEnumWithVariableFailureTest() {
        String key = 'key';
        String value = '$var';

        Exception error;
        try {
            new GraphQLArgument(key, value).asEnum();
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error instanceof GraphQLArgument.GraphQLArgumentException);
    }
}
