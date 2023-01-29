/**
 * @description Represents a GraphQL fragment node definition. Can be used for regular and inline fragments
 */
global class GraphQLFragment extends GraphQLNode {
    /**
     * @description The referencing fragment type
     */
    global final String type;

    /**
     * @description Create an instance of an inline fragment not providing the type. Assuming the type is identical to the parent node's type
     */
    global GraphQLFragment() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create an instance of an inline fragment by the provided type
     * @param type The fragment referencing type
     */
    global GraphQLFragment(String type) {
        this(GraphQLConstants.EMPTY, type);
    }

    /**
     * @description Create an instance of a fragment by the provided name and type
     * @param name The fragment name
     * @param type The fragment referencing type
     */
    global GraphQLFragment(String name, String type) {
        this(name, type, new List<GraphQLField>());
    }

    /**
     * @description Create an instance of a fragment by the provided name, type and nodes
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param fieldNodes The child nodes to be added to the fragment
     */
    global GraphQLFragment(String name, String type, List<GraphQLField> fieldNodes) {
        this(name, type, fieldNodes, new List<String>());
    }

    /**
     * @description Create an instance of a fragment by the provided name, type and fields
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param fields The child fields to be added to the fragment
     */
    global GraphQLFragment(String name, String type, List<String> fields) {
        this(name, type, new List<GraphQLField>(), fields);
    }

    /**
     * @description Create an instance of a fragment by the provided name, type, nodes and fields
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param fieldNodes The child nodes to be added to the fragment
     * @param fields The child fields to be added to the fragment
     */
    global GraphQLFragment(String name, String type, List<GraphQLField> fieldNodes, List<String> fields) {
        super(name, fieldNodes, fields);
        this.type = type;
    }

    /**
     * @description Check if the current fragment is an inline fragment
     * @return `true` if the fragment is inline. `false` otherwise
     */
    global Boolean isInline() {
        return String.isBlank(name);
    }

    /**
     * @description Add a field to the current fragment
     * @param field The field name to be added
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment withField(String field) {
        return withFields(new List<String> { field });
    }

    /**
     * @description Add multiple fields to the current fragment
     * @param fields The list of the field names to be added
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment withFields(String[] fields) {
        return (GraphQLFragment) addFields(fields);
    }

    /**
     * @description Add a node to the current fragment
     * @param fieldNode The field node instance to be added
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment withField(GraphQLField fieldNode) {
        return withFields(new List<GraphQLField> { fieldNode });
    }

    /**
     * @description Add multiple nodes to the current fragment
     * @param fieldNodes The list of node instances to be added
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment withFields(GraphQLField[] fieldNodes) {
        return (GraphQLFragment) addFields(fieldNodes);
    }

    /**
     * @description Add another fragment reference to the current fragment
     * @param fragmentName The fragment name to be used
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment withFragment(String fragmentName) {
        return withFragments(new List<String> { fragmentName });
    }

    /**
     * @description Add other fragment references to the current fragment
     * @param fragmentNames The list of fragment names to be used
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment withFragments(String[] fragmentNames) {
        addFragments(fragmentNames);
        return this;
    }

    public override GraphQLParser getParser() {
        return new GraphQLFragmentParser();
    }

    /**
     * @description Add an inline fragment to the current fragment
     * @param fragment The instance of the `GraphQLFragment`. Should be inline fragment without a name
     * @return The current instance of `GraphQLFragment`
     * @throws GraphQLNodeException If the passed fragment is not inline
     */
    global GraphQLFragment withInlineFragment(GraphQLFragment fragment) {
        return withInlineFragments(new List<GraphQLFragment> { fragment });
    }

    /**
     * @description Add inline fragments to the current fragment
     * @param fragment The instances of the `GraphQLFragment`. Should be inline fragments without names
     * @return The current instance of `GraphQLFragment`
     * @throws GraphQLNodeException If some of the passed fragments are not inline
     */
    global GraphQLFragment withInlineFragments(GraphQLFragment[] fragments) {
        return (GraphQLFragment) addInlineFragments(fragments);
    }

    /**
     * @description Add a custom directive to the current fragment
     * @param directive The directive to be added
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment withDirective(GraphQLDirective directive) {
        return (GraphQLFragment) addDirective(directive);
    }

    /**
     * @description Add the standard `includeIf` directive to the current fragment
     * @param condition The boolean condition for the directive
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment includeIf(Boolean condition) {
        return (GraphQLFragment) addStandardDirective('include', condition);
    }

    /**
     * @description Add the standard `includeIf` directive to the current fragment
     * @param variable The variable reference for the directive. The `$` sign is not required
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment includeIf(String variable) {
        return (GraphQLFragment) addStandardDirective('include', variable);
    }

    /**
     * @description Add the standard `skipIf` directive to the current fragment
     * @param condition The boolean condition for the directive
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment skipIf(Boolean condition) {
        return (GraphQLFragment) addStandardDirective('skip', condition);
    }

    /**
     * @description Add the standard `skipIf` directive to the current fragment
     * @param variable The variable reference for the directive. The `$` sign is not required
     * @return The current instance of `GraphQLFragment`
     */
    global GraphQLFragment skipIf(String variable) {
        return (GraphQLFragment) addStandardDirective('skip', variable);
    }
}
