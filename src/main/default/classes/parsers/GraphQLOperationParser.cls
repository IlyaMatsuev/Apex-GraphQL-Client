public class GraphQLOperationParser extends GraphQLParser {
    protected override String parse(GraphQLNode node, Integer depth, Boolean pretty) {
        return parse((GraphQLOperation) node, depth, pretty);
    }

    private String parse(GraphQLOperation node, Integer depth, Boolean pretty) {
        String operationNameAndVars =
            parseOperation(node) +
            parseName(node, pretty) +
            parseVariableDefinitions(node, pretty) +
            parseDirectives(node, pretty);

        if (String.isNotBlank(operationNameAndVars) && !operationNameAndVars.endsWith(GraphQLConstants.SPACE)) {
            operationNameAndVars += getSmallIndent(pretty);
        }
        return operationNameAndVars + parseChildNodes(node, depth, pretty) + parseFragmentDefinitions(node, pretty);
    }

    private String parseOperation(GraphQLOperation node) {
        return node.getOperation().name().toLowerCase();
    }

    private String parseName(GraphQLOperation node, Boolean pretty) {
        return String.isNotBlank(node.name) ? (GraphQLConstants.SPACE + node.name) : getSmallIndent(pretty);
    }

    private String parseVariableDefinitions(GraphQLOperation node, Boolean pretty) {
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

    private String parseFragmentDefinitions(GraphQLOperation node, Boolean pretty) {
        if (!node.hasFragments()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawFragments = new List<String>();
        for (GraphQLFragment fragment : node.fragments) {
            rawFragments.add(fragment.build(pretty));
        }

        return getLineBreak(pretty) + String.join(rawFragments, getLineBreak(pretty));
    }
}
