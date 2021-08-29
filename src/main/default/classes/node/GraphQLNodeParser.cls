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
            generateChildNodes(node, depth, pretty) +
            generateFragments(node, depth, pretty);
    }

    private String generateNodeName(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        if (String.isBlank(node.name) && !node.hasNodes()) {
            throw new GraphQLNodeParserException(Label.EmptyNodeError);
        }
        if (node instanceof GraphQLOperationNode) {
            return generateOperationName((GraphQLOperationNode) node, pretty);
        }
        if (node instanceof GraphQLFragmentNode) {
            return generateFragmentName((GraphQLFragmentNode) node);
        }
        return getIndent(depth, pretty) + generateAlias(node, pretty) + node.name;
    }

    private String generateOperationName(GraphQLOperationNode node, Boolean pretty) {
        if (String.isBlank(node.name)) {
            return node.getOperation().name().toLowerCase();
        }
        return node.getOperation().name().toLowerCase() + CommonConstants.SPACE + node.name;
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
        if (
            !(node instanceof GraphQLOperationNode) || !((GraphQLOperationNode) node).hasVariables()
        ) {
            return CommonConstants.EMPTY;
        }

        Map<String, String> variables = ((GraphQLOperationNode) node).variables;
        List<String> rawVariableDefinitions = new List<String>();
        for (String name : variables.keySet()) {
            String variableDefinition = CommonConstants.DOLLAR + name + CommonConstants.COLON;
            if (pretty) {
                variableDefinition += CommonConstants.SPACE;
            }
            variableDefinition += variables.get(name);
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
        if (!(node instanceof GraphQLNode) || !((GraphQLNode) node).hasArguments()) {
            return CommonConstants.EMPTY;
        }

        Map<String, GraphQLArgument> arguments = ((GraphQLNode) node).arguments;
        List<String> rawArguments = new List<String>();
        for (String key : arguments.keySet()) {
            String arg = key + CommonConstants.COLON;
            arg += getSmallIndent(pretty);
            arg += arguments.get(key);
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

        if (pretty && (String.isNotBlank(node.name) || node instanceof GraphQLOperationNode)) {
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

    private String generateFragmentName(GraphQLFragmentNode node) {
        return 'fragment ' + node.name + ' on ' + node.type;
    }

    private String generateFragment(GraphQLFragmentNode node, Integer depth, Boolean pretty) {
        return generateFragmentName(node) + generateChildNodes(node, depth, pretty);
    }

    private String generateFragments(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        if (
            !(node instanceof GraphQLOperationNode) || !((GraphQLOperationNode) node).hasFragments()
        ) {
            return CommonConstants.EMPTY;
        }

        List<String> rawFragments = new List<String>();
        for (GraphQLFragmentNode fragment : ((GraphQLOperationNode) node).fragments) {
            rawFragments.add(generateFragment(fragment, depth, pretty));
        }

        return (pretty ? CommonConstants.LINE_BREAK : CommonConstants.EMPTY) +
            String.join(rawFragments, pretty ? CommonConstants.LINE_BREAK : CommonConstants.EMPTY);
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
