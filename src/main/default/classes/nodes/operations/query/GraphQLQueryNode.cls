/**
 * @description The GraphQL query node
 */
global class GraphQLQueryNode extends GraphQLOperationNode {
    /**
     * @description Create a new instance of the GraphQL query node
     */
    global GraphQLQueryNode() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias
     * @param alias The query alias
     */
    global GraphQLQueryNode(String alias) {
        this(alias, new List<String>());
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided child node
     * @param node The child node
     */
    global GraphQLQueryNode(GraphQLNode node) {
        this(new List<GraphQLNode>{ node });
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided child fields
     * @param fields The child fields
     */
    global GraphQLQueryNode(List<String> fields) {
        this(null, fields);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided child nodes
     * @param nodes The child nodes
     */
    global GraphQLQueryNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias and child node
     * @param alias The query alias
     * @param node The child node
     */
    global GraphQLQueryNode(String alias, GraphQLNode node) {
        this(alias, new List<GraphQLNode>{ node });
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias and child fields
     * @param alias The query alias
     * @param fields The child fields
     */
    global GraphQLQueryNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias and child nodes
     * @param alias The query alias
     * @param nodes The child nodes
     */
    global GraphQLQueryNode(String alias, List<GraphQLNode> nodes) {
        super(alias, nodes);
    }

    /**
     * @description Add a child field to the current query node
     * @param field The field to add
     * @return The instance of the current `GraphQLQueryNode` class
     */
    global GraphQLQueryNode withField(String field) {
        return withFields(new List<String>{ field });
    }

    /**
     * @description Add multiple child fields to the current query node
     * @param fields The list of fields to add
     * @return The instance of the current `GraphQLQueryNode` class
     */
    global GraphQLQueryNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    /**
     * @description Add a child node to the current query node
     * @param node The node to add
     * @return The instance of the current `GraphQLQueryNode` class
     */
    global GraphQLQueryNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode>{ node });
    }

    /**
     * @description Add multiple child nodes to the current query node
     * @param nodes The list of nodes to add
     * @return The instance of the current `GraphQLQueryNode` class
     */
    global GraphQLQueryNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    /**
     * @description Add a fragment definition for the current query node
     * @param fragment The fragment definition to add
     * @return The instance of the current `GraphQLQueryNode` class
     */
    global GraphQLQueryNode withFragment(GraphQLFragmentNode fragment) {
        return withFragments(new List<GraphQLFragmentNode>{ fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current query node
     * @param fragments The list of fragment definitions to add
     * @return The instance of the current `GraphQLQueryNode` class
     */
    global GraphQLQueryNode withFragments(GraphQLFragmentNode[] fragments) {
        addFragments(fragments);
        return this;
    }

    /**
     * @description Add a variable definition for the current query node
     * @param name The variable name
     * @param typeDefinition The variable type definition
     * @return The instance of the current `GraphQLQueryNode` class
     */
    global GraphQLQueryNode withVariable(String name, String typeDefinition) {
        addVariable(name, typeDefinition);
        return this;
    }

    /**
     * @description Get the current node's operation type
     * @return `GraphQLOperation.Query` enum value
     */
    global override GraphQLOperation getOperation() {
        return GraphQLOperation.Query;
    }
}
