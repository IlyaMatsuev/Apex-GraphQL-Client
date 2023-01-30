public abstract class GraphQLParser {
    private static final Integer INITIAL_DEPTH = 0;

    protected final Integer maxQueryDepth = GraphQLConfigs.getInteger(GraphQLConfigs.Option.MaxQueryDepth);
    protected final Integer defaultIndent = GraphQLConfigs.getInteger(GraphQLConfigs.Option.QueryIndentSize);

    public static String getSmallIndent(Boolean pretty) {
        return pretty ? GraphQLConstants.SPACE : GraphQLConstants.EMPTY;
    }

    public String parse(GraphQLNode node, Boolean pretty) {
        return parse(node, INITIAL_DEPTH, pretty);
    }

    protected abstract String parse(GraphQLNode node, Integer depth, Boolean pretty);

    protected String parseChildNodes(GraphQLNode node, Integer depth, Boolean pretty) {
        if (!node.hasNodes()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawNodes = new List<String>();
        for (GraphQLNode n : node.nodes) {
            rawNodes.add(n.getParser().parse(n, depth + 1, pretty));
        }

        return GraphQLConstants.BRACE_LEFT +
            getLineBreak(pretty) +
            String.join(rawNodes, pretty ? GraphQLConstants.LINE_BREAK : GraphQLConstants.COMMA) +
            getLineBreak(pretty) +
            getIndent(depth, pretty) +
            GraphQLConstants.BRACE_RIGHT;
    }

    protected String parseDirectives(GraphQLNode node, Boolean pretty) {
        if (!node.hasDirectives()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawDirectives = new List<String>();
        for (GraphQLDirective directive : node.directives) {
            rawDirectives.add(directive.toString(pretty));
        }

        return getSmallIndent(pretty) + String.join(rawDirectives, GraphQLConstants.SPACE);
    }

    protected String getIndent(Integer depth, Boolean pretty) {
        if (!pretty) {
            return GraphQLConstants.EMPTY;
        }
        return GraphQLConstants.SPACE.repeat(depth * defaultIndent);
    }

    protected String getLineBreak(Boolean pretty) {
        return pretty ? GraphQLConstants.LINE_BREAK : GraphQLConstants.EMPTY;
    }
}
