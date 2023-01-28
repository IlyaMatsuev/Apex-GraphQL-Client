/**
 * @description The GraphQL subscription node
 */
global class GraphQLSubscriptionNode extends GraphQLOperationNode {
    /**
     * @description Create a new instance of the GraphQL subscription node
     */
    global GraphQLSubscriptionNode() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias
     * @param alias The subscription alias
     */
    global GraphQLSubscriptionNode(String alias) {
        this(alias, new List<String>());
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided child node
     * @param node The child node
     */
    global GraphQLSubscriptionNode(GraphQLField node) {
        this(new List<GraphQLField> { node });
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided child fields
     * @param fields The child fields
     */
    global GraphQLSubscriptionNode(List<String> fields) {
        this(null, fields);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided child nodes
     * @param nodes The child nodes
     */
    global GraphQLSubscriptionNode(List<GraphQLField> nodes) {
        this(null, nodes);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias and child node
     * @param alias The subscription alias
     * @param node The child node
     */
    global GraphQLSubscriptionNode(String alias, GraphQLField node) {
        this(alias, new List<GraphQLField> { node });
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias and child fields
     * @param alias The subscription alias
     * @param fields The child fields
     */
    global GraphQLSubscriptionNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias and child nodes
     * @param alias The subscription alias
     * @param nodes The child nodes
     */
    global GraphQLSubscriptionNode(String alias, List<GraphQLField> nodes) {
        super(alias, nodes);
    }

    /**
     * @description Add a child field to the current subscription node
     * @param field The field to add
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withField(String field) {
        return withFields(new List<String> { field });
    }

    /**
     * @description Add multiple child fields to the current subscription node
     * @param fields The list of fields to add
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withFields(String[] fields) {
        return (GraphQLSubscriptionNode) addFields(fields);
    }

    /**
     * @description Add a child node to the current subscription node
     * @param node The node to add
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withNode(GraphQLField node) {
        return withNodes(new List<GraphQLField> { node });
    }

    /**
     * @description Add multiple child nodes to the current subscription node
     * @param nodes The list of nodes to add
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withNodes(GraphQLField[] nodes) {
        return (GraphQLSubscriptionNode) addNodes(nodes);
    }

    /**
     * @description Add a fragment definition for the current subscription node
     * @param fragment The fragment definition to add
     * @throws GraphQLOperationNodeException If the provided fragment is inline
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode defineFragment(GraphQLFragment fragment) {
        return defineFragments(new List<GraphQLFragment> { fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current subscription node
     * @param fragments The list of fragment definitions to add
     * @throws GraphQLOperationNodeException If some of the provided fragments are inline
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode defineFragments(GraphQLFragment[] fragments) {
        return (GraphQLSubscriptionNode) addFragments(fragments);
    }

    /**
     * @description Add a variable definition for the current subscription node
     * @param name The variable name
     * @param typeDefinition The variable type definition
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode defineVariable(String name, String typeDefinition) {
        return (GraphQLSubscriptionNode) addVariable(name, typeDefinition);
    }

    /**
     * @description Create a GraphQL request from the current subscription node
     * @throws GraphQLOperationNodeException The subscription requests are not supported yet
     * @return The instance of the `GraphQLRequest` class
     */
    global override GraphQLRequest asRequest() {
        throw new GraphQLOperationNodeException('The subscription requests are not supported yet');
    }

    /**
     * @description Get the current node's operation type
     * @return `GraphQLOperation.Subscription` enum value
     */
    global override GraphQLOperation getOperation() {
        return GraphQLOperation.Subscription;
    }
}
