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
     * @param fieldNode The child node
     */
    global GraphQLMutation(GraphQLField fieldNode) {
        this(new List<GraphQLField> { fieldNode });
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
     * @param fieldNodes The child nodes
     */
    global GraphQLMutation(List<GraphQLField> fieldNodes) {
        this(null, fieldNodes);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias and child node
     * @param alias The mutation alias
     * @param fieldNode The child node
     */
    global GraphQLMutation(String alias, GraphQLField fieldNode) {
        this(alias, new List<GraphQLField> { fieldNode });
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
     * @param fieldNodes The child nodes
     */
    global GraphQLMutation(String alias, List<GraphQLField> fieldNodes) {
        super(alias, fieldNodes);
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
     * @param fieldNode The node to add
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation withField(GraphQLField fieldNode) {
        return withFields(new List<GraphQLField> { fieldNode });
    }

    /**
     * @description Add multiple child nodes to the current mutation node
     * @param fieldNodes The list of nodes to add
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation withFields(GraphQLField[] fieldNodes) {
        return (GraphQLMutation) addFields(fieldNodes);
    }

    /**
     * @description Add a custom directive to the current mutation node
     * @param directive The directive to be added
     * @return The current instance of `GraphQLMutation`
     */
    global GraphQLMutation withDirective(GraphQLDirective directive) {
        return (GraphQLMutation) addDirective(directive);
    }

    /**
     * @description Add a fragment definition for the current mutation node
     * @param fragment The fragment definition to add
     * @throws GraphQLOperationException If the provided fragment is inline
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation defineFragment(GraphQLFragment fragment) {
        return defineFragments(new List<GraphQLFragment> { fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current mutation node
     * @param fragments The list of fragment definitions to add
     * @throws GraphQLOperationException If some of the provided fragments are inline
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
        return defineVariable(new GraphQLVariable(name, typeDefinition));
    }

    /**
     * @description Add a variable definition for the current mutation node
     * @param variable The variable definition to add
     * @return The instance of the current `GraphQLMutation` class
     */
    global GraphQLMutation defineVariable(GraphQLVariable variable) {
        return (GraphQLMutation) addVariable(variable);
    }

    /**
     * @description Get the current node's operation type
     * @return `GraphQLOperationType.Mutation` enum value
     */
    global override GraphQLOperationType getOperation() {
        return GraphQLOperationType.Mutation;
    }
}
