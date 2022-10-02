/**
 * @description Represents a GraphQL fragment node definition
 */
global class GraphQLFragmentNode extends GraphQLBaseNode {
    /**
     * @description The referencing fragment type
     */
    global final String type;

    /**
     * @description Create an instance of a fragment by the provided name and type
     * @param name The fragment name
     * @param type The fragment referencing type
     */
    global GraphQLFragmentNode(String name, String type) {
        this(name, type, new List<GraphQLNode>());
    }

    /**
     * @description Create an instance of a fragment by the provided name, type and nodes
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param nodes The child nodes to be added to the fragment
     */
    global GraphQLFragmentNode(String name, String type, List<GraphQLNode> nodes) {
        this(name, type, nodes, new List<String>());
    }

    /**
     * @description Create an instance of a fragment by the provided name, type and fields
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param fields The child fields to be added to the fragment
     */
    global GraphQLFragmentNode(String name, String type, List<String> fields) {
        this(name, type, new List<GraphQLNode>(), fields);
    }

    /**
     * @description Create an instance of a fragment by the provided name, type, nodes and fields
     * @param name The fragment name
     * @param type The fragment referencing type
     * @param nodes The child nodes to be added to the fragment
     * @param fields The child fields to be added to the fragment
     */
    global GraphQLFragmentNode(String name, String type, List<GraphQLNode> nodes, List<String> fields) {
        super(name, nodes, fields);
        this.type = type;
    }

    /**
     * @description Add a field to the current fragment
     * @param field The field name to be added
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withField(String field) {
        return withFields(new List<String>{ field });
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
    global GraphQLFragmentNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode>{ node });
    }

    /**
     * @description Add multiple nodes to the current fragment
     * @param nodes The list of node instances to be added
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    /**
     * @description Add another fragment reference to the current fragment
     * @param fragmentName The fragment name to be used
     * @return The current instance of `GraphQLFragmentNode`
     */
    global GraphQLFragmentNode withFragment(String fragmentName) {
        return withFragments(new List<String>{ fragmentName });
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

    /**
     * @description Get the parser for the fragment node
     * @return The instance of the `GraphQLFragmentNodeParser` class
     */
    global override IGraphQLParser getParser() {
        return new GraphQLFragmentNodeParser();
    }
}
