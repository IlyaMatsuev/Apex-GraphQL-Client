public class GraphQLRequestGenerator {

    @TestVisible
    private static final Integer INITIAL_DEPTH = 0;

    private GraphQLNode node;

    public GraphQLRequestGenerator(GraphQLNode node) {
        this.node = node;
    }
    
    public String generate(Boolean pretty) {
        return generate(node, INITIAL_DEPTH, pretty);
    }

    private String generate(GraphQLNode node, Integer depth, Boolean pretty) {
        String indent = getIndent(depth);
        String rawNode = (pretty ? indent : CommonConstants.EMPTY) + node.name;

        if (node.hasNodes()) {
            List<String> rawNodes = new List<String>();
            for (GraphQLNode n : node.asList()) {
                rawNodes.add(generate(n, depth + 1, pretty));
            }

            rawNode += pretty ? CommonConstants.SPACE : CommonConstants.EMPTY;
            rawNode += CommonConstants.BRACE_LEFT;
            rawNode += pretty ? CommonConstants.LINE_BREAK : CommonConstants.EMPTY;

            rawNode += String.join(
                rawNodes,
                pretty ? CommonConstants.LINE_BREAK : CommonConstants.COMMA
            );

            // Because when a brance closes we get back by one indent level
            rawNode += pretty ? (CommonConstants.LINE_BREAK + indent) : CommonConstants.EMPTY;
            rawNode += CommonConstants.BRACE_RIGHT;
        }
        return rawNode;
    }

    private String getIndent(Integer depth) {
        return CommonConstants.SPACE.repeat(depth * CommonConstants.DEFAULT_INDENT);
    }
}
