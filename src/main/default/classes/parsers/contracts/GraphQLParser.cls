public abstract class GraphQLParser implements IGraphQLParser {
    private static final Integer INITIAL_DEPTH = 0;

    protected final Integer maxQueryDepth = GraphQLConfigurationManager.getConfigurationAsInt(
        GraphQLConfiguration.MaxQueryDepth
    );

    protected final Integer defaultIndent = GraphQLConfigurationManager.getConfigurationAsInt(
        GraphQLConfiguration.QueryIndentSize
    );

    public String parse(GraphQLNodeBase node, Boolean pretty) {
        return parse(node, INITIAL_DEPTH, pretty);
    }

    public abstract String parse(GraphQLNodeBase node, Integer depth, Boolean pretty);

    protected String parseNode(GraphQLNode node, Integer depth, Boolean pretty) {
        if (depth >= maxQueryDepth) {
            throw new GraphQLBaseParserException(
                Label.MaxRequestDepthError.replace(
                    CommonConstants.FIRST_FORMAT_PARAM,
                    String.valueOf(maxQueryDepth)
                )
            );
        }

        return parseNodeName(node, depth, pretty) +
            parseArguments(node, pretty) +
            parseDirectives(node, pretty) +
            parseChildNodes(node, depth, pretty);
    }

    protected String parseChildNodes(GraphQLNodeBase node, Integer depth, Boolean pretty) {
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
            rawNodes.add(parseNode(n, depth + 1, pretty));
        }

        childNodes += String.join(
            rawNodes,
            pretty ? CommonConstants.LINE_BREAK : CommonConstants.COMMA
        );

        if (pretty) {
            childNodes += CommonConstants.LINE_BREAK + getIndent(depth, pretty);
        }

        childNodes += CommonConstants.BRACE_RIGHT;

        return childNodes;
    }

    protected String getIndent(Integer depth, Boolean pretty) {
        if (!pretty) {
            return CommonConstants.EMPTY;
        }
        return CommonConstants.SPACE.repeat(depth * defaultIndent);
    }

    protected String getSmallIndent(Boolean pretty) {
        return pretty ? CommonConstants.SPACE : CommonConstants.EMPTY;
    }

    private String parseNodeName(GraphQLNode node, Integer depth, Boolean pretty) {
        return getIndent(depth, pretty) + parseAlias(node, pretty) + node.name;
    }

    private String parseAlias(GraphQLNode node, Boolean pretty) {
        if (String.isBlank(node.alias)) {
            return CommonConstants.EMPTY;
        }
        return node.alias + CommonConstants.COLON + getSmallIndent(pretty);
    }

    private String parseArguments(GraphQLNode node, Boolean pretty) {
        if (!node.hasArguments()) {
            return CommonConstants.EMPTY;
        }

        List<String> rawArguments = new List<String>();
        for (GraphQLArgument argument : node.arguments.values()) {
            rawArguments.add(argument.parse(node, pretty));
        }

        return CommonConstants.PARENTHESE_LEFT +
            String.join(rawArguments, CommonConstants.COMMA + getSmallIndent(pretty)) +
            CommonConstants.PARENTHESE_RIGHT;
    }

    private String parseDirectives(GraphQLNode node, Boolean pretty) {
        if (!node.hasDirectives()) {
            return CommonConstants.EMPTY;
        }

        List<String> rawDirectives = new List<String>();
        for (GraphQLDirective directive : node.directives.values()) {
            rawDirectives.add(directive.parse(node, pretty));
        }

        return CommonConstants.SPACE + String.join(rawDirectives, CommonConstants.SPACE);
    }

    private class GraphQLBaseParserException extends Exception {
    }
}
