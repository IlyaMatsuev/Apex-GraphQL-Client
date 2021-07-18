public class GraphQLNodeParser implements IGraphQLNodeParser {

    @TestVisible
    private static final Integer INITIAL_DEPTH = 0;
    // TODO: Move to Custom Metadata configuration
    @TestVisible
    private static final Integer MAX_QUERY_DEPTH = 10;
    // TODO: Move to Custom Metadata configuration
    @TestVisible
    private static final Integer DEFAULT_INDENT = 2;

    private GraphQLNodeBase node;

    public GraphQLNodeParser(GraphQLNodeBase node) {
        this.node = node;
    }

    public String toString(Boolean pretty) {        
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
        if (node.hasArguments()) {
            rawNode += generateArguments(node, depth, pretty);
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

    private String generateArguments(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        List<String> rawArguments = new List<String>();
        for (String key : node.arguments.keySet()) {
            String arg = key + CommonConstants.COLON;
            if (pretty) {
                arg += CommonConstants.SPACE;
            }
            arg += node.arguments.get(key) ;

            rawArguments.add(arg);
        }
        return CommonConstants.PARENTHESE_LEFT
                + String.join(
                    rawArguments,
                    CommonConstants.COMMA + (pretty ? CommonConstants.SPACE : CommonConstants.EMPTY)
                )
                + CommonConstants.PARENTHESE_RIGHT;
    }

    private String generateChildNodes(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        String childNodes = CommonConstants.EMPTY;
        List<String> rawNodes = new List<String>();
        for (GraphQLNode n : node.nodes) {
            rawNodes.add(generate(n, depth + 1, pretty));
        }

        childNodes += (pretty && String.isNotBlank(node.name)) ? CommonConstants.SPACE : CommonConstants.EMPTY;
        childNodes += CommonConstants.BRACE_LEFT;
        childNodes += pretty ? CommonConstants.LINE_BREAK : CommonConstants.EMPTY;

        childNodes += String.join(
            rawNodes,
            pretty ? CommonConstants.LINE_BREAK : CommonConstants.COMMA
        );

        // Because when a brace closes we should get back by one indent level
        childNodes += pretty ? (CommonConstants.LINE_BREAK + getIndent(depth)) : CommonConstants.EMPTY;
        childNodes += CommonConstants.BRACE_RIGHT;

        return childNodes;
    }

    private String getIndent(Integer depth) {
        return CommonConstants.SPACE.repeat(depth * DEFAULT_INDENT);
    }

    private class GraphQLNodeParserException extends Exception {}
}
