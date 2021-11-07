global class GraphQLDirective implements IGraphQLParser {
    private static final String IF_ARG_NAME = 'if';

    private final GraphQLDirectiveType type;
    private final GraphQLArgument ifArgument;

    global GraphQLDirective(GraphQLDirectiveType type, String ifArgumentValue) {
        this(type, ifArgumentValue);
    }

    global GraphQLDirective(GraphQLDirectiveType type, Boolean ifArgumentValue) {
        this(type, ifArgumentValue);
    }

    private GraphQLDirective(GraphQLDirectiveType type, Object ifArgumentValue) {
        if (ifArgumentValue == null) {
            throw new GraphQLDirectiveException(Label.NullDirectiveArgumentError);
        }
        this.type = type;
        this.ifArgument = new GraphQLArgument(IF_ARG_NAME, toVariableIfPossible(ifArgumentValue));
    }

    public String parse(GraphQLNodeBase node, Boolean pretty) {
        return CommonConstants.AT +
            this.type.name().toLowerCase() +
            CommonConstants.PARENTHESE_LEFT +
            ifArgument.parse(node, pretty) +
            CommonConstants.PARENTHESE_RIGHT;
    }

    private Object toVariableIfPossible(Object argument) {
        if (argument instanceof String && !((String) argument).startsWith(CommonConstants.DOLLAR)) {
            return CommonConstants.DOLLAR + argument;
        }
        return argument;
    }

    private class GraphQLDirectiveException extends Exception {
    }
}
