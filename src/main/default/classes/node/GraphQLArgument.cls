global class GraphQLArgument implements IGraphQLParser {
    // Searches for all JSON property names. Needed to escape properties' double quotes
    private static final String REPLACE_JSON_PROPS_REGEXP = '"(\\w+)"\\s*:';
    // Takes the first match from the regex
    private static final String ESCAPED_PROP_NAME_EXP = '$1:';

    private static final String DATE_VALUE_FORMAT = GraphQLConfigManager.getString(GraphQLConfig.DateArgumentFormat);
    private static final String DATE_TIME_VALUE_FORMAT = GraphQLConfigManager.getString(
        GraphQLConfig.DateTimeArgumentFormat
    );
    private static final Boolean SUPPRESS_NULLS = GraphQLConfigManager.getBoolean(
        GraphQLConfig.SupressNullsForObjectArguments
    );

    global final String key;
    global final Object value;
    global GraphQLArgumentType type {
        get {
            if (type == null) {
                type = getArgumentTypeByValue(value);
            }
            return type;
        }
        private set;
    }

    global GraphQLArgument(String key, Object value) {
        this.key = key;
        this.value = value;
    }

    global Boolean isVariable() {
        return value instanceof String && value != null && ((String) value).startsWith(CommonConstants.DOLLAR);
    }

    global override String toString() {
        switch on type {
            when x_Integer, x_Float, x_Boolean, x_Null {
                return String.valueOf(value);
            }
            when x_String {
                return isVariable()
                    ? (String) value
                    : CommonConstants.DOUBLE_QUOTES + value + CommonConstants.DOUBLE_QUOTES;
            }
            when x_DateTime {
                return CommonConstants.DOUBLE_QUOTES +
                    ((DateTime) value).format(DATE_TIME_VALUE_FORMAT) +
                    CommonConstants.DOUBLE_QUOTES;
            }
            when x_Date {
                return CommonConstants.DOUBLE_QUOTES +
                    dateToDateTime((Date) value).format(DATE_VALUE_FORMAT) +
                    CommonConstants.DOUBLE_QUOTES;
            }
            when else {
                return JSON.serialize(value, SUPPRESS_NULLS)
                    .replaceAll(REPLACE_JSON_PROPS_REGEXP, ESCAPED_PROP_NAME_EXP);
            }
        }
    }

    public String parse(GraphQLNodeBase node, Boolean pretty) {
        return key + CommonConstants.COLON + (pretty ? CommonConstants.SPACE : CommonConstants.EMPTY) + this;
    }

    // There is no way to get an object's type yet
    private GraphQLArgumentType getArgumentTypeByValue(Object value) {
        if (value instanceof Integer || value instanceof Long) {
            return GraphQLArgumentType.x_Integer;
        } else if (value instanceof String || value instanceof Blob || value instanceof Id) {
            return GraphQLArgumentType.x_String;
        } else if (value instanceof Double || value instanceof Decimal) {
            return GraphQLArgumentType.x_Float;
        } else if (value instanceof Boolean) {
            return GraphQLArgumentType.x_Boolean;
        } else if (value instanceof Date) {
            return GraphQLArgumentType.x_Date;
        } else if (value instanceof DateTime || value instanceof Time) {
            return GraphQLArgumentType.x_DateTime;
        } else if (value == null) {
            return GraphQLArgumentType.x_Null;
        } else {
            return GraphQLArgumentType.x_Object;
        }
    }

    private DateTime dateToDateTime(Date dateValue) {
        return DateTime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
    }
}
