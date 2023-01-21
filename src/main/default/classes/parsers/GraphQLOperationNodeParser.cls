public class GraphQLOperationNodeParser extends GraphQLParser {
    public override String parse(GraphQLBaseNode node, Integer depth, Boolean pretty) {
        return parse((GraphQLOperationNode) node, depth, pretty);
    }

    private String parse(GraphQLOperationNode node, Integer depth, Boolean pretty) {
        return parseOperation(node) +
            parseName(node, pretty) +
            parseVariableDefinitions(node, pretty) +
            parseChildNodes(node, depth, pretty) +
            parseFragmentDefinitions(node, depth, pretty);
    }

    private String parseOperation(GraphQLOperationNode node) {
        return node.getOperation().name().toLowerCase();
    }

    private String parseName(GraphQLOperationNode node, Boolean pretty) {
        return String.isBlank(node.name) ? getSmallIndent(pretty) : (GraphQLConstants.SPACE + node.name);
    }

    private String parseVariableDefinitions(GraphQLOperationNode node, Boolean pretty) {
        if (!node.hasVariables()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawVariableDefinitions = new List<String>();
        for (String name : node.variables.keySet()) {
            rawVariableDefinitions.add(
                GraphQLConstants.DOLLAR +
                name +
                GraphQLConstants.COLON +
                getSmallIndent(pretty) +
                node.variables.get(name)
            );
        }

        return GraphQLConstants.PARENTHESE_LEFT +
            String.join(rawVariableDefinitions, GraphQLConstants.COMMA + getSmallIndent(pretty)) +
            GraphQLConstants.PARENTHESE_RIGHT +
            getSmallIndent(pretty);
    }

    private String parseFragmentDefinitions(GraphQLOperationNode node, Integer depth, Boolean pretty) {
        if (!node.hasFragments()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawFragments = new List<String>();
        for (GraphQLFragmentNode fragment : node.fragments) {
            rawFragments.add(fragment.build(pretty));
        }
        return getLineBreakIndent(pretty) + String.join(rawFragments, getLineBreakIndent(pretty));
    }

    private String getLineBreakIndent(Boolean pretty) {
        return pretty ? GraphQLConstants.LINE_BREAK : GraphQLConstants.EMPTY;
    }
}
