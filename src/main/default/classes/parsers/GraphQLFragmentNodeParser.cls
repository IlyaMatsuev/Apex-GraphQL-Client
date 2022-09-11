public class GraphQLFragmentNodeParser extends GraphQLParser {
    private static final String FRAGMENT_KEYWORD = 'fragment';
    private static final String ON_TYPE_KEYWORD = 'on';

    public override String parse(GraphQLBaseNode node, Integer depth, Boolean pretty) {
        return parse((GraphQLFragmentNode) node, depth, pretty);
    }

    private String parse(GraphQLFragmentNode fragment, Integer depth, Boolean pretty) {
        return FRAGMENT_KEYWORD +
            GraphQLConstants.SPACE +
            fragment.name +
            GraphQLConstants.SPACE +
            ON_TYPE_KEYWORD +
            GraphQLConstants.SPACE +
            fragment.type +
            parseChildNodes(fragment, depth, pretty);
    }
}
