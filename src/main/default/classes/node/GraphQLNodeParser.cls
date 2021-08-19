public class GraphQLNodeParser implements IGraphQLNodeParser {
    private static final Integer INITIAL_DEPTH = 0;

    private static final Integer MAX_QUERY_DEPTH = GraphQLConfigurationManager.getConfigurationAsInt(
        GraphQLConfiguration.MaxQueryDepth
    );

    private static final Integer DEFAULT_INDENT = GraphQLConfigurationManager.getConfigurationAsInt(
        GraphQLConfiguration.QueryIndentSize
    );

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

        return generateNodeName(node, depth, pretty) +
            generateVariables(node, pretty) +
            generateArguments(node, pretty) +
            generateChildNodes(node, depth, pretty);
    }

    private String generateNodeName(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        if (String.isBlank(node.name) && !node.hasNodes()) {
            throw new GraphQLNodeParserException(Label.EmptyNodeError);
        }
        return getIndent(depth, pretty) + generateAlias(node, pretty) + node.name;
    }

    private String generateAlias(GraphQLNodeBase node, Boolean pretty) {
        if (!(node instanceof GraphQLNode) || String.isBlank(((GraphQLNode) node).alias)) {
            return CommonConstants.EMPTY;
        }

        return ((GraphQLNode) node).alias +
            CommonConstants.COLON +
            (pretty ? CommonConstants.SPACE : CommonConstants.EMPTY);
    }

    private String generateVariables(GraphQLNodeBase node, Boolean pretty) {
        if (node.variables.isEmpty()) {
            return CommonConstants.EMPTY;
        }

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
        if (!node.hasArguments()) {
            return CommonConstants.EMPTY;
        }

        List<String> rawArguments = new List<String>();
        for (String key : node.arguments.keySet()) {
            String arg = key + CommonConstants.COLON;
            arg += getSmallIndent(pretty);
            arg += node.arguments.get(key);
            rawArguments.add(arg);
        }
        return CommonConstants.PARENTHESE_LEFT +
            String.join(rawArguments, CommonConstants.COMMA + getSmallIndent(pretty)) +
            CommonConstants.PARENTHESE_RIGHT;
    }

    private String generateChildNodes(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        if (!node.hasNodes()) {
            return CommonConstants.EMPTY;
        }

        String childNodes = CommonConstants.EMPTY;

        if (pretty && String.isNotBlank(node.name)) {
            childNodes += CommonConstants.SPACE;
        }

        childNodes += CommonConstants.BRACE_LEFT;
        childNodes += pretty ? CommonConstants.LINE_BREAK : CommonConstants.EMPTY;

        List<String> rawNodes = new List<String>();
        for (GraphQLNode n : node.nodes) {
            rawNodes.add(generate(n, depth + 1, pretty));
        }

        childNodes += String.join(
            rawNodes,
            pretty ? CommonConstants.LINE_BREAK : CommonConstants.COMMA
        );

        // Because when a brace closes we should get back by one indent level
        childNodes += pretty
            ? (CommonConstants.LINE_BREAK + getIndent(depth, pretty))
            : CommonConstants.EMPTY;
        childNodes += CommonConstants.BRACE_RIGHT;

        return childNodes;
    }

    private String getIndent(Integer depth, Boolean pretty) {
        if (!pretty) {
            return CommonConstants.EMPTY;
        }
        return CommonConstants.SPACE.repeat(depth * DEFAULT_INDENT);
    }

    private String getSmallIndent(Boolean pretty) {
        return pretty ? CommonConstants.SPACE : CommonConstants.EMPTY;
    }

    private class GraphQLNodeParserException extends Exception {
    }
}
