global class GraphQLArgument {
    // Searches for all JSON property names. Needed to escape properties' double quotes
    private static final String REPLACE_JSON_PROPS_REGEXP = '"(\\w+)"\\s*:';
    // Takes the first match from the regex
    private static final String ESCAPED_PROP_NAME_EXP = '$1:';

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

    global override String toString() {
        switch on type {
            when x_Integer, x_Float, x_Boolean {
                return String.valueOf(value);
            }
            when x_String {
                return CommonConstants.DOUBLE_QUOTES + value + CommonConstants.DOUBLE_QUOTES;
            }
            // TODO: Move formatting to Custom Metadata configuration
            when x_DateTime {
                return CommonConstants.DOUBLE_QUOTES +
                    String.valueOf((DateTime) value) +
                    CommonConstants.DOUBLE_QUOTES;
            }
            // TODO: Move formatting to Custom Metadata configuration
            when x_Date {
                return CommonConstants.DOUBLE_QUOTES +
                    ((Date) value).format() +
                    CommonConstants.DOUBLE_QUOTES;
            }
            when else {
                // TODO: support pretty formatting for objects in arguments
                return JSON.serialize(value)
                    .replaceAll(REPLACE_JSON_PROPS_REGEXP, ESCAPED_PROP_NAME_EXP);
            }
        }
    }

    // There is no way to get an object's type yet
    private static GraphQLArgumentType getArgumentTypeByValue(Object value) {
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
        } else {
            return GraphQLArgumentType.x_Object;
        }
    }

    private class GraphQLArgumentException extends Exception {
    }
}
