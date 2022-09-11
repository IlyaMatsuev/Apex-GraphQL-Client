public abstract class GraphQLParser implements IGraphQLParser {
    private static final Integer INITIAL_DEPTH = 0;

    protected final Integer maxQueryDepth = GraphQLConfigManager.getInteger(GraphQLConfig.MaxQueryDepth);
    protected final Integer defaultIndent = GraphQLConfigManager.getInteger(GraphQLConfig.QueryIndentSize);

    public String parse(GraphQLBaseNode node, Boolean pretty) {
        return parse(node, INITIAL_DEPTH, pretty);
    }

    public abstract String parse(GraphQLBaseNode node, Integer depth, Boolean pretty);

    protected String parseNode(GraphQLNode node, Integer depth, Boolean pretty) {
        if (depth >= maxQueryDepth) {
            throw new GraphQLBaseParserException('Maximum request depth level is ' + String.valueOf(maxQueryDepth));
        }

        return parseNodeName(node, depth, pretty) +
            parseArguments(node, pretty) +
            parseDirectives(node, pretty) +
            parseChildNodes(node, depth, pretty);
    }

    protected String parseChildNodes(GraphQLBaseNode node, Integer depth, Boolean pretty) {
        if (!node.hasNodes()) {
            return GraphQLConstants.EMPTY;
        }

        String childNodes = GraphQLConstants.EMPTY;

        if (pretty && String.isNotBlank(node.name)) {
            childNodes += GraphQLConstants.SPACE;
        }

        childNodes += GraphQLConstants.BRACE_LEFT;
        childNodes += pretty ? GraphQLConstants.LINE_BREAK : GraphQLConstants.EMPTY;

        List<String> rawNodes = new List<String>();
        for (GraphQLNode n : node.nodes) {
            rawNodes.add(parseNode(n, depth + 1, pretty));
        }

        childNodes += String.join(rawNodes, pretty ? GraphQLConstants.LINE_BREAK : GraphQLConstants.COMMA);

        if (pretty) {
            childNodes += GraphQLConstants.LINE_BREAK + getIndent(depth, pretty);
        }

        childNodes += GraphQLConstants.BRACE_RIGHT;

        return childNodes;
    }

    protected String getIndent(Integer depth, Boolean pretty) {
        if (!pretty) {
            return GraphQLConstants.EMPTY;
        }
        return GraphQLConstants.SPACE.repeat(depth * defaultIndent);
    }

    protected String getSmallIndent(Boolean pretty) {
        return pretty ? GraphQLConstants.SPACE : GraphQLConstants.EMPTY;
    }

    private String parseNodeName(GraphQLNode node, Integer depth, Boolean pretty) {
        return getIndent(depth, pretty) + parseAlias(node, pretty) + node.name;
    }

    private String parseAlias(GraphQLNode node, Boolean pretty) {
        if (String.isBlank(node.alias)) {
            return GraphQLConstants.EMPTY;
        }
        return node.alias + GraphQLConstants.COLON + getSmallIndent(pretty);
    }

    private String parseArguments(GraphQLNode node, Boolean pretty) {
        if (!node.hasArguments()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawArguments = new List<String>();
        for (GraphQLArgument argument : node.arguments.values()) {
            rawArguments.add(argument.parse(node, pretty));
        }

        return GraphQLConstants.PARENTHESE_LEFT +
            String.join(rawArguments, GraphQLConstants.COMMA + getSmallIndent(pretty)) +
            GraphQLConstants.PARENTHESE_RIGHT;
    }

    private String parseDirectives(GraphQLNode node, Boolean pretty) {
        if (!node.hasDirectives()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawDirectives = new List<String>();
        for (GraphQLDirective directive : node.directives.values()) {
            rawDirectives.add(directive.parse(node, pretty));
        }

        return GraphQLConstants.SPACE + String.join(rawDirectives, GraphQLConstants.SPACE);
    }

    private class GraphQLBaseParserException extends Exception {
    }
}
