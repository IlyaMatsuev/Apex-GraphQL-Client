/**
 * @description Represents an entry of a GraphQL argument in a node
 */
global class GraphQLDirective implements IGraphQLParser {
    private static final String IF_ARG_NAME = 'if';

    private final GraphQLDirectiveType type;
    private final GraphQLArgument ifArgument;

    /**
     * @description Create an instance of a directive by the provided type and value
     * @param type The directive standard type
     * @param ifArgumentValue The reference to a boolean variable. The `$` sign is not required
     * @throws GraphQLDirectiveException If the provided argument value is `null`
     */
    global GraphQLDirective(GraphQLDirectiveType type, String ifArgumentValue) {
        this(type, (Object) ifArgumentValue);
    }

    /**
     * @description Create an instance of a directive by the provided type and value
     * @param type The directive standard type
     * @param ifArgumentValue The boolean condition for the directive
     * @throws GraphQLDirectiveException If the provided argument value is `null`
     */
    global GraphQLDirective(GraphQLDirectiveType type, Boolean ifArgumentValue) {
        this(type, (Object) ifArgumentValue);
    }

    private GraphQLDirective(GraphQLDirectiveType type, Object ifArgumentValue) {
        if (ifArgumentValue == null) {
            throw new GraphQLDirectiveException(
                'Directive argument value cannot be null. It should be either Boolean or variable'
            );
        }
        this.type = type;
        this.ifArgument = new GraphQLArgument(IF_ARG_NAME, toVariableIfPossible(ifArgumentValue));
    }

    public String parse(GraphQLBaseNode node, Boolean pretty) {
        return GraphQLConstants.AT +
            this.type.name().toLowerCase() +
            GraphQLConstants.PARENTHESE_LEFT +
            ifArgument.parse(node, pretty) +
            GraphQLConstants.PARENTHESE_RIGHT;
    }

    private Object toVariableIfPossible(Object argument) {
        if (argument instanceof String && !((String) argument).startsWith(GraphQLConstants.DOLLAR)) {
            return GraphQLConstants.DOLLAR + argument;
        }
        return argument;
    }

    private class GraphQLDirectiveException extends Exception {
    }
}
