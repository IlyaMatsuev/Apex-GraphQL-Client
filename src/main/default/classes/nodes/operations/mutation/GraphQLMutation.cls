/**
 * @description The GraphQL mutation node
 */
global class GraphQLMutation extends GraphQLOperation {
    /**
     * @description Create a new instance of the GraphQL mutation node
     */
    global GraphQLMutation() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias
     * @param alias The mutation alias
     */
    global GraphQLMutation(String alias) {
        this(alias, new List<String>());
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided child node
     * @param node The child node
     */
    global GraphQLMutation(GraphQLField node) {
        this(new List<GraphQLField> { node });
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided child fields
     * @param fields The child fields
     */
    global GraphQLMutation(List<String> fields) {
        this(null, fields);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided child nodes
     * @param nodes The child nodes
     */
    global GraphQLMutation(List<GraphQLField> nodes) {
        this(null, nodes);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias and child node
     * @param alias The mutation alias
     * @param node The child node
     */
    global GraphQLMutation(String alias, GraphQLField node) {
        this(alias, new List<GraphQLField> { node });
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias and child fields
     * @param alias The mutation alias
     * @param fields The child fields
     */
    global GraphQLMutation(String alias, List<String> fields) {
        super(alias, fields);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias and child nodes
     * @param alias The mutation alias
     * @param nodes The child nodes
     */
    global GraphQLMutation(String alias, List<GraphQLField> nodes) {
        super(alias, nodes);
    }

    /**
     * @description Add a child field to the current mutation node
     * @param field The field to add
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation withField(String field) {
        return withFields(new List<String> { field });
    }

    /**
     * @description Add multiple child fields to the current mutation node
     * @param fields The list of fields to add
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation withFields(String[] fields) {
        return (GraphQLMutation) addFields(fields);
    }

    /**
     * @description Add a child node to the current mutation node
     * @param node The node to add
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation withNode(GraphQLField node) {
        return withNodes(new List<GraphQLField> { node });
    }

    /**
     * @description Add multiple child nodes to the current mutation node
     * @param nodes The list of nodes to add
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation withNodes(GraphQLField[] nodes) {
        return (GraphQLMutation) addNodes(nodes);
    }

    /**
     * @description Add a fragment definition for the current mutation node
     * @param fragment The fragment definition to add
     * @throws GraphQLOperationNodeException If the provided fragment is inline
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation defineFragment(GraphQLFragment fragment) {
        return defineFragments(new List<GraphQLFragment> { fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current mutation node
     * @param fragments The list of fragment definitions to add
     * @throws GraphQLOperationNodeException If some of the provided fragments are inline
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation defineFragments(GraphQLFragment[] fragments) {
        return (GraphQLMutation) addFragments(fragments);
    }

    /**
     * @description Add a variable definition for the current mutation node
     * @param name The variable name
     * @param typeDefinition The variable type definition
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation defineVariable(String name, String typeDefinition) {
        return (GraphQLMutation) addVariable(name, typeDefinition);
    }

    /**
     * @description Get the current node's operation type
     * @return `GraphQLOperationType.Mutation` enum value
     */
    global override GraphQLOperationType getOperation() {
        return GraphQLOperationType.Mutation;
    }
}
