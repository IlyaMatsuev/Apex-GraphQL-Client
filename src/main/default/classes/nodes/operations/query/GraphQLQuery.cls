/**
 * @description The GraphQL query node
 */
global class GraphQLQuery extends GraphQLOperation {
    /**
     * @description Create a new instance of the GraphQL query node
     */
    global GraphQLQuery() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias
     * @param alias The query alias
     */
    global GraphQLQuery(String alias) {
        this(alias, new List<String>());
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided child node
     * @param node The child node
     */
    global GraphQLQuery(GraphQLField node) {
        this(new List<GraphQLField> { node });
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided child fields
     * @param fields The child fields
     */
    global GraphQLQuery(List<String> fields) {
        this(null, fields);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided child nodes
     * @param nodes The child nodes
     */
    global GraphQLQuery(List<GraphQLField> nodes) {
        this(null, nodes);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias and child node
     * @param alias The query alias
     * @param node The child node
     */
    global GraphQLQuery(String alias, GraphQLField node) {
        this(alias, new List<GraphQLField> { node });
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias and child fields
     * @param alias The query alias
     * @param fields The child fields
     */
    global GraphQLQuery(String alias, List<String> fields) {
        super(alias, fields);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias and child nodes
     * @param alias The query alias
     * @param nodes The child nodes
     */
    global GraphQLQuery(String alias, List<GraphQLField> nodes) {
        super(alias, nodes);
    }

    /**
     * @description Add a child field to the current query node
     * @param field The field to add
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery withField(String field) {
        return withFields(new List<String> { field });
    }

    /**
     * @description Add multiple child fields to the current query node
     * @param fields The list of fields to add
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery withFields(String[] fields) {
        return (GraphQLQuery) addFields(fields);
    }

    /**
     * @description Add a child node to the current query node
     * @param node The node to add
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery withNode(GraphQLField node) {
        return withNodes(new List<GraphQLField> { node });
    }

    /**
     * @description Add multiple child nodes to the current query node
     * @param nodes The list of nodes to add
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery withNodes(GraphQLField[] nodes) {
        return (GraphQLQuery) addNodes(nodes);
    }

    /**
     * @description Add a fragment definition for the current query node
     * @param fragment The fragment definition to add
     * @throws GraphQLOperationNodeException If the provided fragment is inline
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery defineFragment(GraphQLFragment fragment) {
        return defineFragments(new List<GraphQLFragment> { fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current query node
     * @param fragments The list of fragment definitions to add
     * @throws GraphQLOperationNodeException If some of the provided fragments are inline
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery defineFragments(GraphQLFragment[] fragments) {
        return (GraphQLQuery) addFragments(fragments);
    }

    /**
     * @description Add a variable definition for the current query node
     * @param name The variable name
     * @param typeDefinition The variable type definition
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery defineVariable(String name, String typeDefinition) {
        return (GraphQLQuery) addVariable(name, typeDefinition);
    }

    /**
     * @description Get the current node's operation type
     * @return `GraphQLOperationType.Query` enum value
     */
    global override GraphQLOperationType getOperation() {
        return GraphQLOperationType.Query;
    }
}
