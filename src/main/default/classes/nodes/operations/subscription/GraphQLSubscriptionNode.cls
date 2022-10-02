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
    global GraphQLSubscriptionNode(GraphQLNode node) {
        this(new List<GraphQLNode> { node });
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
    global GraphQLSubscriptionNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    /**
     * @description Create a new instance of the GraphQL subscription node with the provided alias and child node
     * @param alias The subscription alias
     * @param node The child node
     */
    global GraphQLSubscriptionNode(String alias, GraphQLNode node) {
        this(alias, new List<GraphQLNode> { node });
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
    global GraphQLSubscriptionNode(String alias, List<GraphQLNode> nodes) {
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
        addFields(fields);
        return this;
    }

    /**
     * @description Add a child node to the current subscription node
     * @param node The node to add
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode> { node });
    }

    /**
     * @description Add multiple child nodes to the current subscription node
     * @param nodes The list of nodes to add
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    /**
     * @description Add a fragment definition for the current subscription node
     * @param fragment The fragment definition to add
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withFragment(GraphQLFragmentNode fragment) {
        return withFragments(new List<GraphQLFragmentNode> { fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current subscription node
     * @param fragments The list of fragment definitions to add
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withFragments(GraphQLFragmentNode[] fragments) {
        addFragments(fragments);
        return this;
    }

    /**
     * @description Add a variable definition for the current subscription node
     * @param name The variable name
     * @param typeDefinition The variable type definition
     * @return The instance of the current `GraphQLSubscriptionNode` class
     */
    global GraphQLSubscriptionNode withVariable(String name, String typeDefinition) {
        addVariable(name, typeDefinition);
        return this;
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
