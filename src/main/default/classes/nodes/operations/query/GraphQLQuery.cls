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
     * @param fieldNode The child node
     */
    global GraphQLQuery(GraphQLField fieldNode) {
        this(new List<GraphQLField> { fieldNode });
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
     * @param fieldNodes The child nodes
     */
    global GraphQLQuery(List<GraphQLField> fieldNodes) {
        this(null, fieldNodes);
    }

    /**
     * @description Create a new instance of the GraphQL query node with the provided alias and child node
     * @param alias The query alias
     * @param fieldNode The child node
     */
    global GraphQLQuery(String alias, GraphQLField fieldNode) {
        this(alias, new List<GraphQLField> { fieldNode });
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
     * @param fieldNodes The child nodes
     */
    global GraphQLQuery(String alias, List<GraphQLField> fieldNodes) {
        super(alias, fieldNodes);
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
     * @param fieldNode The node to add
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery withField(GraphQLField fieldNode) {
        return withFields(new List<GraphQLField> { fieldNode });
    }

    /**
     * @description Add multiple child nodes to the current query node
     * @param fieldNodes The list of nodes to add
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery withFields(GraphQLField[] fieldNodes) {
        return (GraphQLQuery) addFields(fieldNodes);
    }

    /**
     * @description Add a fragment definition for the current query node
     * @param fragment The fragment definition to add
     * @throws GraphQLOperationException If the provided fragment is inline
     * @return The instance of the current `GraphQLQuery` class
     */
    global GraphQLQuery defineFragment(GraphQLFragment fragment) {
        return defineFragments(new List<GraphQLFragment> { fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current query node
     * @param fragments The list of fragment definitions to add
     * @throws GraphQLOperationException If some of the provided fragments are inline
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
