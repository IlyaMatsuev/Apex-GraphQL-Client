public class GraphQLFieldParser extends GraphQLParser {
    protected override String parse(GraphQLNode node, Integer depth, Boolean pretty) {
        return parseNode((GraphQLField) node, depth, pretty);
    }

    private String parseNode(GraphQLField node, Integer depth, Boolean pretty) {
        if (String.isBlank(node.name) && !node.hasNodes()) {
            throw new GraphQLNodeParserException('Cannot parse an empty node without any child nodes');
        }

        if (depth >= maxQueryDepth) {
            throw new GraphQLNodeParserException('Maximum request depth level is reached: ' + maxQueryDepth);
        }

        String nodeNameAndArgs =
            parseNodeName(node, depth, pretty) +
            parseArguments(node, pretty) +
            parseDirectives(node, pretty);

        if (String.isNotBlank(nodeNameAndArgs) && node.hasNodes()) {
            nodeNameAndArgs += GraphQLParser.getSmallIndent(pretty);
        }

        return nodeNameAndArgs + parseChildNodes(node, depth, pretty);
    }

    private String parseNodeName(GraphQLField node, Integer depth, Boolean pretty) {
        return getIndent(depth, pretty) + parseAlias(node, pretty) + node.name;
    }

    private String parseAlias(GraphQLField node, Boolean pretty) {
        if (String.isBlank(node.alias)) {
            return GraphQLConstants.EMPTY;
        }
        return node.alias + GraphQLConstants.COLON + GraphQLParser.getSmallIndent(pretty);
    }

    private String parseArguments(GraphQLField node, Boolean pretty) {
        if (!node.hasArguments()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawArguments = new List<String>();
        for (GraphQLArgument argument : node.arguments.values()) {
            rawArguments.add(argument.toString(pretty));
        }

        return GraphQLConstants.PARENTHESE_LEFT +
            String.join(rawArguments, GraphQLConstants.COMMA + GraphQLParser.getSmallIndent(pretty)) +
            GraphQLConstants.PARENTHESE_RIGHT;
    }

    private class GraphQLNodeParserException extends Exception {}
}
