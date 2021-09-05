public class GraphQLNodeParser extends GraphQLParser {
    public override String parse(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        if (String.isBlank(node.name) && !node.hasNodes()) {
            throw new GraphQLNodeParserException(Label.EmptyNodeError);
        }
        return parseNode((GraphQLNode) node, depth, pretty);
    }

    private class GraphQLNodeParserException extends Exception {
    }
}
