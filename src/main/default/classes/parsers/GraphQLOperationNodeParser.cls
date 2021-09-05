public class GraphQLOperationNodeParser extends GraphQLParser {
    public override String parse(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        return parse((GraphQLOperationNode) node, depth, pretty);
    }

    private String parse(GraphQLOperationNode node, Integer depth, Boolean pretty) {
        return parseOperation(node) +
            parseName(node, pretty) +
            parseVariables(node, pretty) +
            parseChildNodes(node, depth, pretty) +
            parseFragments(node, depth, pretty);
    }

    private String parseOperation(GraphQLOperationNode node) {
        return node.getOperation().name().toLowerCase();
    }

    private String parseName(GraphQLOperationNode node, Boolean pretty) {
        return String.isBlank(node.name)
            ? getSmallIndent(pretty)
            : (CommonConstants.SPACE + node.name);
    }

    private String parseVariables(GraphQLOperationNode node, Boolean pretty) {
        if (!node.hasVariables()) {
            return CommonConstants.EMPTY;
        }

        List<String> rawVariableDefinitions = new List<String>();
        for (String name : node.variables.keySet()) {
            rawVariableDefinitions.add(
                CommonConstants.DOLLAR +
                name +
                CommonConstants.COLON +
                getSmallIndent(pretty) +
                node.variables.get(name)
            );
        }

        return CommonConstants.PARENTHESE_LEFT +
            String.join(rawVariableDefinitions, CommonConstants.COMMA + getSmallIndent(pretty)) +
            CommonConstants.PARENTHESE_RIGHT +
            getSmallIndent(pretty);
    }

    private String parseFragments(GraphQLOperationNode node, Integer depth, Boolean pretty) {
        if (!node.hasFragments()) {
            return CommonConstants.EMPTY;
        }

        List<String> rawFragments = new List<String>();
        for (GraphQLFragmentNode fragment : node.fragments) {
            rawFragments.add(fragment.build(pretty));
        }
        return getLineBreakIndent(pretty) + String.join(rawFragments, getLineBreakIndent(pretty));
    }

    private String getLineBreakIndent(Boolean pretty) {
        return pretty ? CommonConstants.LINE_BREAK : CommonConstants.EMPTY;
    }
}
