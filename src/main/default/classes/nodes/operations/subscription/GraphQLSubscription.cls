/**
 * @description The GraphQL subscription node
 */
global class GraphQLSubscription extends GraphQLOperation {
    /**
     * @description Create a new instance of the GraphQL subscription node
     */
    global GraphQLSubscription() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias
     * @param alias The subscription alias
     */
    global GraphQLSubscription(String alias) {
        this(alias, new List<String>());
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided child node
     * @param fieldNode The child node
     */
    global GraphQLSubscription(GraphQLField fieldNode) {
        this(new List<GraphQLField> { fieldNode });
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided child fields
     * @param fields The child fields
     */
    global GraphQLSubscription(List<String> fields) {
        this(null, fields);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided child nodes
     * @param fieldNodes The child nodes
     */
    global GraphQLSubscription(List<GraphQLField> fieldNodes) {
        this(null, fieldNodes);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias and child node
     * @param alias The subscription alias
     * @param fieldNode The child node
     */
    global GraphQLSubscription(String alias, GraphQLField fieldNode) {
        this(alias, new List<GraphQLField> { fieldNode });
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias and child fields
     * @param alias The subscription alias
     * @param fields The child fields
     */
    global GraphQLSubscription(String alias, List<String> fields) {
        super(alias, fields);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias and child nodes
     * @param alias The subscription alias
     * @param fieldNodes The child nodes
     */
    global GraphQLSubscription(String alias, List<GraphQLField> fieldNodes) {
        super(alias, fieldNodes);
    }

    /**
     * @description Add a child field to the current subscription node
     * @param field The field to add
     * @return The instance of the current `GraphQLSubscription` class
     */
    global GraphQLSubscription withField(String field) {
        return withFields(new List<String> { field });
    }

    /**
     * @description Add multiple child fields to the current subscription node
     * @param fields The list of fields to add
     * @return The instance of the current `GraphQLSubscription` class
     */
    global GraphQLSubscription withFields(String[] fields) {
        return (GraphQLSubscription) addFields(fields);
    }

    /**
     * @description Add a child node to the current subscription node
     * @param fieldNode The node to add
     * @return The instance of the current `GraphQLSubscription` class
     */
    global GraphQLSubscription withField(GraphQLField fieldNode) {
        return withFields(new List<GraphQLField> { fieldNode });
    }

    /**
     * @description Add multiple child nodes to the current subscription node
     * @param nodes The list of nodes to add
     * @return The instance of the current `GraphQLSubscription` class
     */
    global GraphQLSubscription withFields(GraphQLField[] fieldNodes) {
        return (GraphQLSubscription) addFields(fieldNodes);
    }

    /**
     * @description Add a fragment definition for the current subscription node
     * @param fragment The fragment definition to add
     * @throws GraphQLOperationException If the provided fragment is inline
     * @return The instance of the current `GraphQLSubscription` class
     */
    global GraphQLSubscription defineFragment(GraphQLFragment fragment) {
        return defineFragments(new List<GraphQLFragment> { fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current subscription node
     * @param fragments The list of fragment definitions to add
     * @throws GraphQLOperationException If some of the provided fragments are inline
     * @return The instance of the current `GraphQLSubscription` class
     */
    global GraphQLSubscription defineFragments(GraphQLFragment[] fragments) {
        return (GraphQLSubscription) addFragments(fragments);
    }

    /**
     * @description Add a variable definition for the current subscription node
     * @param name The variable name
     * @param typeDefinition The variable type definition
     * @return The instance of the current `GraphQLSubscription` class
     */
    global GraphQLSubscription defineVariable(String name, String typeDefinition) {
        return (GraphQLSubscription) addVariable(name, typeDefinition);
    }

    /**
     * @description Create a GraphQL request from the current subscription node
     * @throws GraphQLOperationException The subscription requests are not supported yet
     * @return The instance of the `GraphQLRequest` class
     */
    global override GraphQLRequest asRequest() {
        throw new GraphQLOperationException('The subscription requests are not supported yet');
    }

    /**
     * @description Get the current node's operation type
     * @return `GraphQLOperationType.Subscription` enum value
     */
    global override GraphQLOperationType getOperation() {
        return GraphQLOperationType.Subscription;
    }
}
