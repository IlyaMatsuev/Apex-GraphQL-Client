/**
 * @description Represents an entry of a GraphQL argument in a node
 */
global class GraphQLArgument {
    // Searches for all JSON property names. Needed to escape properties' double quotes
    private static final String REPLACE_JSON_PROPS_REGEXP = '"(\\w+)"\\s*:';
    // Searches for all JSON values that are strings starting from '$'. Needed to escape variables' ref double quotes
    private static final String REPLACE_JSON_VARIABLE_REFS_REGEXP = ':\\s*"(\\$\\w+)"';
    private static final String FIRST_REGEX_MATCH_GROUP = '$1';

    private static final String DATE_VALUE_FORMAT = GraphQLConfigs.getString(GraphQLConfigs.Option.DateArgumentFormat);
    private static final String DATE_TIME_VALUE_FORMAT = GraphQLConfigs.getString(
        GraphQLConfigs.Option.DateTimeArgumentFormat
    );
    private static final Boolean SUPPRESS_NULLS = GraphQLConfigs.getBoolean(
        GraphQLConfigs.Option.SupressNullsForObjectArguments
    );

    /**
     * @description The argument name
     */
    global final String key;

    /**
     * @description The argument value
     */
    global final Object value;

    /**
     * @description The argument GraphQL type
     */
    global GraphQLArgumentType type {
        get {
            if (type == null) {
                type = getArgumentTypeByValue(value);
            }
            return type;
        }
        private set;
    }

    /**
     * @description Create an instance of an argument by the provided name and value
     * @param key The argument name
     * @param value The argument value
     */
    global GraphQLArgument(String key, Object value) {
        this.key = key;
        this.value = value;
    }

    /**
     * @description Check if the current argument references a variable
     * @return `true` if the current argument references a variable. `false` otherwise
     */
    global Boolean isVariable() {
        return value instanceof String && value != null && ((String) value).startsWith(GraphQLConstants.DOLLAR);
    }

    /**
     * @description Represent the current argument as a GraphQL enum value
     * @throws GraphQLArgumentException If the current argument value is not String or if it's a variable reference
     * @return The current instance of `GraphQLArgument`
     */
    global GraphQLArgument asEnum() {
        if (!(value instanceof String) || isVariable()) {
            throw new GraphQLArgumentException(
                'Impossible to cast GraphQL argument as enum. The value type must be String and must not be a variable reference.'
            );
        }
        type = GraphQLArgumentType.x_Enum;
        return this;
    }

    public override String toString() {
        return toString(false);
    }

    public String toString(Boolean pretty) {
        if (String.isBlank(key)) {
            return valueToString(pretty);
        }
        return key + GraphQLConstants.COLON + GraphQLParser.getSmallIndent(pretty) + valueToString(pretty);
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

    private String valueToString(Boolean pretty) {
        switch on type {
            when x_Integer, x_Float, x_Boolean, x_Null, x_Enum {
                return String.valueOf(value);
            }
            when x_String {
                return isVariable()
                    ? (String) value
                    : GraphQLConstants.DOUBLE_QUOTES + value + GraphQLConstants.DOUBLE_QUOTES;
            }
            when x_DateTime {
                return GraphQLConstants.DOUBLE_QUOTES +
                    ((DateTime) value).format(DATE_TIME_VALUE_FORMAT) +
                    GraphQLConstants.DOUBLE_QUOTES;
            }
            when x_Date {
                return GraphQLConstants.DOUBLE_QUOTES +
                    dateToDateTime((Date) value).format(DATE_VALUE_FORMAT) +
                    GraphQLConstants.DOUBLE_QUOTES;
            }
            when else {
                return objectToString(value, pretty);
            }
        }
    }

    private DateTime dateToDateTime(Date dateValue) {
        return DateTime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
    }

    private String objectToString(Object value, Boolean pretty) {
        String jsonValue = pretty ? JSON.serializePretty(value, SUPPRESS_NULLS) : JSON.serialize(value, SUPPRESS_NULLS);

        if (pretty) {
            jsonValue = jsonValue
                // Replace all multiple spaces with the single space. Couldn't use .normalizeSpace() because it would affect JSON string values as well
                .replaceAll('\\s+"', GraphQLConstants.SPACE + GraphQLConstants.DOUBLE_QUOTES)
                .replaceAll('\\s*}', GraphQLConstants.SPACE + GraphQLConstants.BRACE_RIGHT);
        }

        return jsonValue
            .replaceAll(REPLACE_JSON_PROPS_REGEXP, FIRST_REGEX_MATCH_GROUP + GraphQLConstants.COLON)
            .replaceAll(
                REPLACE_JSON_VARIABLE_REFS_REGEXP,
                GraphQLConstants.COLON +
                GraphQLParser.getSmallIndent(pretty) +
                FIRST_REGEX_MATCH_GROUP
            );
    }

    @TestVisible
    private class GraphQLArgumentException extends Exception {}
}
