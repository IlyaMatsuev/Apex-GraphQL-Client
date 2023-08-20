/**
 * @description Represents a GraphQL directive
 */
global class GraphQLDirective {
    /**
     * @description The directive's name followed after the `@` sign
     */
    global final String name;
    /**
     * @description The list of arguments added to the directive
     */
    global final List<GraphQLArgument> arguments = new List<GraphQLArgument>();

    /**
     * @description Creates an instance of a directive by the provided name
     * @param name The directive's name. E.g. `include` or `skip`
     */
    global GraphQLDirective(String name) {
        this.name = name;
    }

    /**
     * @description Check if the directive contains any arguments
     * @return `true` if there are any arguments. `false` otherwise
     */
    global Boolean hasArguments() {
        return !arguments.isEmpty();
    }

    /**
     * @description Add an argument to the current directive
     * @param key The argument name
     * @param value The argument value. Use string with the `$` sign for variable referencing
     * @return The current instance of <<GraphQLDirective>>
     */
    global GraphQLDirective withArgument(String key, Object value) {
        return withArgument(new GraphQLArgument(key, value));
    }

    /**
     * @description Add an argument to the current directive
     * @param argument The argument to be added
     * @return The current instance of <<GraphQLDirective>>
     */
    global GraphQLDirective withArgument(GraphQLArgument argument) {
        arguments.add(argument);
        return this;
    }

    public override String toString() {
        return toString(false);
    }

    public String toString(Boolean pretty) {
        String definition = GraphQLConstants.AT + name;
        if (hasArguments()) {
            List<String> rawArguments = new List<String>();
            for (GraphQLArgument argument : arguments) {
                rawArguments.add(argument.toString(pretty));
            }
            definition +=
                GraphQLConstants.PARENTHESE_LEFT +
                String.join(rawArguments, GraphQLConstants.COMMA + GraphQLParser.getSmallIndent(pretty)) +
                GraphQLConstants.PARENTHESE_RIGHT;
        }
        return definition;
    }
}
