public class GraphQLNodeParser implements IGraphQLNodeParser {
    @TestVisible
    private static final Integer INITIAL_DEPTH = 0;
    // TODO: Move to Custom Metadata configuration
    @TestVisible
    private static final Integer MAX_QUERY_DEPTH = 10;
    // TODO: Move to Custom Metadata configuration
    @TestVisible
    private static final Integer DEFAULT_INDENT = 2;

    public String toString(GraphQLNodeBase node, Boolean pretty) {
        return generate(node, INITIAL_DEPTH, pretty);
    }

    private String generate(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        if (depth >= MAX_QUERY_DEPTH) {
            throw new GraphQLNodeParserException(
                Label.MaxRequestDepthError.replace(
                    CommonConstants.FIRST_FORMAT_PARAM,
                    String.valueOf(MAX_QUERY_DEPTH)
                )
            );
        }

        String rawNode = generateNodeName(node, depth, pretty);
        if (!node.variables.isEmpty()) {
            rawNode += generateVariables(node, pretty);
        }
        if (node.hasArguments()) {
            rawNode += generateArguments(node, pretty);
        }
        if (node.hasNodes()) {
            rawNode += generateChildNodes(node, depth, pretty);
        }
        return rawNode;
    }

    private String generateNodeName(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        if (String.isBlank(node.name) && !node.hasNodes()) {
            throw new GraphQLNodeParserException(Label.EmptyNodeError);
        }
        return (pretty ? getIndent(depth) : CommonConstants.EMPTY) + node.name;
    }

    private String generateVariables(GraphQLNodeBase node, Boolean pretty) {
        List<String> rawVariableDefinitions = new List<String>();
        for (String name : node.variables.keySet()) {
            String variableDefinition = CommonConstants.DOLLAR + name + CommonConstants.COLON;
            if (pretty) {
                variableDefinition += CommonConstants.SPACE;
            }
            variableDefinition += node.variables.get(name);
            rawVariableDefinitions.add(variableDefinition);
        }
        return CommonConstants.PARENTHESE_LEFT +
            String.join(
                rawVariableDefinitions,
                CommonConstants.COMMA + (pretty ? CommonConstants.SPACE : CommonConstants.EMPTY)
            ) +
            CommonConstants.PARENTHESE_RIGHT;
    }

    private String generateArguments(GraphQLNodeBase node, Boolean pretty) {
        List<String> rawArguments = new List<String>();
        for (String key : node.arguments.keySet()) {
            String arg = key + CommonConstants.COLON;
            if (pretty) {
                arg += CommonConstants.SPACE;
            }
            arg += node.arguments.get(key);
            rawArguments.add(arg);
        }
        return CommonConstants.PARENTHESE_LEFT +
            String.join(
                rawArguments,
                CommonConstants.COMMA + (pretty ? CommonConstants.SPACE : CommonConstants.EMPTY)
            ) +
            CommonConstants.PARENTHESE_RIGHT;
    }

    private String generateChildNodes(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        String childNodes = CommonConstants.EMPTY;
        List<String> rawNodes = new List<String>();
        for (GraphQLNode n : node.nodes) {
            rawNodes.add(generate(n, depth + 1, pretty));
        }

        if (pretty && String.isNotBlank(node.name)) {
            childNodes += CommonConstants.SPACE;
        }

        childNodes += CommonConstants.BRACE_LEFT;
        childNodes += pretty ? CommonConstants.LINE_BREAK : CommonConstants.EMPTY;

        childNodes += String.join(
            rawNodes,
            pretty ? CommonConstants.LINE_BREAK : CommonConstants.COMMA
        );

        // Because when a brace closes we should get back by one indent level
        childNodes += pretty
            ? (CommonConstants.LINE_BREAK + getIndent(depth))
            : CommonConstants.EMPTY;
        childNodes += CommonConstants.BRACE_RIGHT;

        return childNodes;
    }

    private String getIndent(Integer depth) {
        return CommonConstants.SPACE.repeat(depth * DEFAULT_INDENT);
    }

    private class GraphQLNodeParserException extends Exception {
    }
}
