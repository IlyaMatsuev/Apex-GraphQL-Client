public class GraphQLFragmentNodeParser extends GraphQLParser {
    private static final String FRAGMENT_KEYWORD = 'fragment';
    private static final String ON_TYPE_KEYWORD = 'on';

    public override String parse(GraphQLNodeBase node, Integer depth, Boolean pretty) {
        return parse((GraphQLFragmentNode) node, depth, pretty);
    }

    private String parse(GraphQLFragmentNode fragment, Integer depth, Boolean pretty) {
        return FRAGMENT_KEYWORD +
            CommonConstants.SPACE +
            fragment.name +
            CommonConstants.SPACE +
            ON_TYPE_KEYWORD +
            CommonConstants.SPACE +
            fragment.type +
            parseChildNodes(fragment, depth, pretty);
    }
}
