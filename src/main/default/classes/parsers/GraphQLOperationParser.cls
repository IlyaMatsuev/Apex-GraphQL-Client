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

        return operationNameAndVars.trim().normalizeSpace() +
            GraphQLParser.getSmallIndent(pretty) +
            parseChildNodes(node, depth, pretty) +
            parseFragmentDefinitions(node, pretty);
    }

    private String parseOperation(GraphQLOperation node) {
        return node.getOperation().name().toLowerCase();
    }

    private String parseName(GraphQLOperation node, Boolean pretty) {
        return String.isNotBlank(node.name)
            ? (GraphQLConstants.SPACE + node.name)
            : GraphQLParser.getSmallIndent(pretty);
    }

    private String parseVariableDefinitions(GraphQLOperation node, Boolean pretty) {
        if (!node.hasVariables()) {
            return GraphQLConstants.EMPTY;
        }

        List<String> rawVariables = new List<String>();
        for (GraphQLVariable variable : node.variables) {
            rawVariables.add(variable.toString(pretty));
        }

        return GraphQLConstants.PARENTHESE_LEFT +
            String.join(rawVariables, GraphQLConstants.COMMA + GraphQLParser.getSmallIndent(pretty)) +
            GraphQLConstants.PARENTHESE_RIGHT +
            GraphQLParser.getSmallIndent(pretty);
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
