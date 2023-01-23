/**
 * @description Represents a GraphQL fragment node definition. Can be used for regular and inline fragments
 */
global class GraphQLFragmentNode extends GraphQLNode {
    /**
     * @description The referencing fragment type
     */
    global final String type;

    /**
     * @description Create an instance of an inline fragment not providing the type. Assuming the type is identical to the parent node's type
     */
    global GraphQLFragmentNode() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create an instance of an inline fragment by the provided type
     * @param type The fragment referencing type
     */
    global GraphQLFragmentNode(String type) {
        this(GraphQLConstants.EMPTY, type);
    }

    /**
     * @description Create an instance of a fragment by the provided name and type
     * @param name The fragment name
     * @param type The fragment referencing type
     */
    global GraphQLFragmentNode(String name, String type) {
        this(name, type, new List<GraphQLFieldNode>());
    }

    /**
     * @description Create an instance of a fragment by the provided name, type and nodes
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param nodes The child nodes to be added to the fragment
     */
    global GraphQLFragmentNode(String name, String type, List<GraphQLFieldNode> nodes) {
        this(name, type, nodes, new List<String>());
    }

    /**
     * @description Create an instance of a fragment by the provided name, type and fields
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param fields The child fields to be added to the fragment
     */
    global GraphQLFragmentNode(String name, String type, List<String> fields) {
        this(name, type, new List<GraphQLFieldNode>(), fields);
    }

    /**
     * @description Create an instance of a fragment by the provided name, type, nodes and fields
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param nodes The child nodes to be added to the fragment
     * @param fields The child fields to be added to the fragment
     */
    global GraphQLFragmentNode(String name, String type, List<GraphQLFieldNode> nodes, List<String> fields) {
        super(name, nodes, fields);
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
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withField(String field) {
        return withFields(new List<String> { field });
    }

    /**
     * @description Add multiple fields to the current fragment
     * @param fields The list of the field names to be added
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    /**
     * @description Add a node to the current fragment
     * @param node The node instance to be added
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withNode(GraphQLFieldNode node) {
        return withNodes(new List<GraphQLFieldNode> { node });
    }

    /**
     * @description Add multiple nodes to the current fragment
     * @param nodes The list of node instances to be added
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withNodes(GraphQLFieldNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    /**
     * @description Add another fragment reference to the current fragment
     * @param fragmentName The fragment name to be used
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withFragment(String fragmentName) {
        return withFragments(new List<String> { fragmentName });
    }

    /**
     * @description Add other fragment references to the current fragment
     * @param fragmentNames The list of fragment names to be used
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withFragments(String[] fragmentNames) {
        addFragments(fragmentNames);
        return this;
    }

    public override GraphQLParser getParser() {
        return new GraphQLFragmentNodeParser();
    }

    /**
     * @description Add an inline fragment to the current fragment
     * @param fragment The instance of the `GraphQLFragmentNode`. Should be inline fragment without a name
     * @return The current instance of `GraphQLFragmentNode`
     * @throws GraphQLBaseNodeException If the passed fragment is not inline
     */
    global GraphQLFragmentNode withInlineFragment(GraphQLFragmentNode fragment) {
        return withInlineFragments(new List<GraphQLFragmentNode> { fragment });
    }

    /**
     * @description Add inline fragments to the current fragment
     * @param fragment The instances of the `GraphQLFragmentNode`. Should be inline fragments without names
     * @return The current instance of `GraphQLFragmentNode`
     * @throws GraphQLBaseNodeException If some of the passed fragments are not inline
     */
    global GraphQLFragmentNode withInlineFragments(GraphQLFragmentNode[] fragments) {
        return (GraphQLFragmentNode) addInlineFragments(fragments);
    }

    /**
     * @description Add the standard `includeIf` directive to the current fragment
     * @param condition The boolean condition for the directive
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode includeIf(Boolean condition) {
        return (GraphQLFragmentNode) addDirective(new GraphQLDirective(GraphQLDirectiveType.Include, condition));
    }

    /**
     * @description Add the standard `includeIf` directive to the current fragment
     * @param variable The variable reference for the directive. The `$` sign is not required
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode includeIf(String variable) {
        return (GraphQLFragmentNode) addDirective(new GraphQLDirective(GraphQLDirectiveType.Include, variable));
    }

    /**
     * @description Add the standard `skipIf` directive to the current fragment
     * @param condition The boolean condition for the directive
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode skipIf(Boolean condition) {
        return (GraphQLFragmentNode) addDirective(new GraphQLDirective(GraphQLDirectiveType.Skip, condition));
    }

    /**
     * @description Add the standard `skipIf` directive to the current fragment
     * @param variable The variable reference for the directive. The `$` sign is not required
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode skipIf(String variable) {
        return (GraphQLFragmentNode) addDirective(new GraphQLDirective(GraphQLDirectiveType.Skip, variable));
    }
}
