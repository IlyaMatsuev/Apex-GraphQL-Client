/**
 * @description Represents a GraphQL variable definition
 */
global class GraphQLVariable {
    /**
     * @description The variable definition name without the `$` sign
     */
    global String name {
        get;
        private set {
            String newName = value.trim();
            if (newName.startsWith(GraphQLConstants.DOLLAR)) {
                newName = newName.substringAfter(GraphQLConstants.DOLLAR);
            }
            name = newName;
        }
    }

    /**
     * @description The variable definition type without the `!` sign. If it's non-null type, the `isNonNull` variable should be `true`
     */
    global String type {
        get;
        private set {
            String newType = value.trim();
            if (newType.endsWith(GraphQLConstants.EXCLAMATION)) {
                asNonNull();
                newType = newType.substringBeforeLast(GraphQLConstants.EXCLAMATION);
            }
            type = newType;
        }
    }

    /**
     * @description The variable definition default value
     */
    global Object defaultValue {
        get { return defaultValueArgument?.value; }
        private set { defaultValueArgument = new GraphQLArgument(GraphQLConstants.EMPTY, value); }
    }

    /**
     * @dsecription Flag that shows if the variable value is non-null for the request
     */
    global Boolean isNonNull {
        get {
            if (isNonNull == null) {
                isNonNull = false;
            }
            return isNonNull;
        }
        private set;
    }

    private GraphQLArgument defaultValueArgument;

    /**
     * @description Creates a variable definition by the provided name and type
     * @param name The variable name with or without the `$` sign
     * @param type The variable type. E.g. `Int`, `String` or some custom type
     */
    global GraphQLVariable(String name, String type) {
        this.name = name;
        this.type = type;
    }

    /**
     * @description Marks the current variable definition as the non-null type
     * @return The current instance of the variable definition
     */
    global GraphQLVariable asNonNull() {
        return asNonNull(true);
    }

    /**
     * @description Marks the current variable definition as the non-null or optional type
     * @param isNonNull Flag that defines if the variable type is non-null or optional
     * @return The current instance of the variable definition
     */
    global GraphQLVariable asNonNull(Boolean isNonNull) {
        this.isNonNull = isNonNull;
        return this;
    }

    /**
     * @description Adds a default value to the variable definition
     * @param defaultValue The default value for the variable
     * @return The current instance of the variable definition
     */
    global GraphQLVariable withDefault(Object defaultValue) {
        this.defaultValue = defaultValue;
        return this;
    }

    /**
     * @description Represents the current variable default value as a GraphQL enum value
     * @throws GraphQLVariableException If the doesn't have any default value set yet
     * @throws GraphQLArgumentException If the default value is not String or if it's a variable reference
     * @return The current instance of the variable definition
     */
    global GraphQLVariable asEnum() {
        if (defaultValueArgument == null) {
            throw new GraphQLVariableException('The default value was not set for the variable yet');
        }
        defaultValueArgument.asEnum();
        return this;
    }

    public override String toString() {
        return toString(false);
    }

    public String toString(Boolean pretty) {
        String definition =
            GraphQLConstants.DOLLAR +
            name +
            GraphQLConstants.COLON +
            GraphQLParser.getSmallIndent(pretty) +
            type +
            (isNonNull ? GraphQLConstants.EXCLAMATION : GraphQLConstants.EMPTY);

        if (defaultValueArgument != null) {
            definition +=
                GraphQLParser.getSmallIndent(pretty) +
                GraphQLConstants.ASSIGN +
                GraphQLParser.getSmallIndent(pretty) +
                defaultValueArgument.toString(pretty);
        }
        return definition;
    }

    @TestVisible
    private class GraphQLVariableException extends Exception {}
}
