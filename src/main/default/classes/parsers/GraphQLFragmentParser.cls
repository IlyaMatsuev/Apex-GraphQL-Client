public class GraphQLFragmentParser extends GraphQLParser {
    private static final String FRAGMENT_KEYWORD = 'fragment';
    private static final String ON_TYPE_KEYWORD = 'on';

    protected override String parse(GraphQLNode node, Integer depth, Boolean pretty) {
        return parse((GraphQLFragment) node, depth, pretty);
    }

    private String parse(GraphQLFragment fragment, Integer depth, Boolean pretty) {
        if (fragment.isInline()) {
            return parseInlineFragment(fragment, depth, pretty);
        }
        return parseFragmentDefinition(fragment, depth, pretty);
    }

    private String parseInlineFragment(GraphQLFragment fragment, Integer depth, Boolean pretty) {
        String spread = GraphQLConstants.DOT.repeat(3);
        if (String.isNotBlank(fragment.type)) {
            spread += GraphQLConstants.SPACE + ON_TYPE_KEYWORD + GraphQLConstants.SPACE + fragment.type;
        }
        return getIndent(depth, pretty) +
            spread +
            parseDirectives(fragment, pretty) +
            GraphQLParser.getSmallIndent(pretty) +
            parseChildNodes(fragment, depth, pretty);
    }

    private String parseFragmentDefinition(GraphQLFragment fragment, Integer depth, Boolean pretty) {
        return FRAGMENT_KEYWORD +
            GraphQLConstants.SPACE +
            fragment.name +
            GraphQLConstants.SPACE +
            ON_TYPE_KEYWORD +
            GraphQLConstants.SPACE +
            fragment.type +
            parseDirectives(fragment, pretty) +
            GraphQLParser.getSmallIndent(pretty) +
            parseChildNodes(fragment, depth, pretty);
    }
}
