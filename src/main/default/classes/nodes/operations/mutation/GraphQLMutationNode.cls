/**
 * @description The GraphQL mutation node
 */
global class GraphQLMutationNode extends GraphQLOperationNode implements IGraphQLRequestBuilder {
    /**
     * @description Create a new instance of the GraphQL mutation node
     */
    global GraphQLMutationNode() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias
     * @param alias The mutation alias
     */
    global GraphQLMutationNode(String alias) {
        this(alias, new List<String>());
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided child node
     * @param node The child node
     */
    global GraphQLMutationNode(GraphQLNode node) {
        this(new List<GraphQLNode>{ node });
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided child fields
     * @param fields The child fields
     */
    global GraphQLMutationNode(List<String> fields) {
        this(null, fields);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided child nodes
     * @param nodes The child nodes
     */
    global GraphQLMutationNode(List<GraphQLNode> nodes) {
        this(null, nodes);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias and child node
     * @param alias The mutation alias
     * @param node The child node
     */
    global GraphQLMutationNode(String alias, GraphQLNode node) {
        this(alias, new List<GraphQLNode>{ node });
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias and child fields
     * @param alias The mutation alias
     * @param fields The child fields
     */
    global GraphQLMutationNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    /**
     * @description Create a new instance of the GraphQL mutation node with the provided alias and child nodes
     * @param alias The mutation alias
     * @param nodes The child nodes
     */
    global GraphQLMutationNode(String alias, List<GraphQLNode> nodes) {
        super(alias, nodes);
    }

    /**
     * @description Add a child field to the current mutation node
     * @param field The field to add
     * @return The instance of the current `GraphQLMutationNode` class
     */
    global GraphQLMutationNode withField(String field) {
        return withFields(new List<String>{ field });
    }

    /**
     * @description Add multiple child fields to the current mutation node
     * @param fields The list of fields to add
     * @return The instance of the current `GraphQLMutationNode` class
     */
    global GraphQLMutationNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    /**
     * @description Add a child node to the current mutation node
     * @param node The node to add
     * @return The instance of the current `GraphQLMutationNode` class
     */
    global GraphQLMutationNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode>{ node });
    }

    /**
     * @description Add multiple child nodes to the current mutation node
     * @param nodes The list of nodes to add
     * @return The instance of the current `GraphQLMutationNode` class
     */
    global GraphQLMutationNode withNodes(GraphQLNode[] nodes) {
        addNodes(nodes);
        return this;
    }

    /**
     * @description Add a fragment definition for the current mutation node
     * @param fragment The fragment definition to add
     * @return The instance of the current `GraphQLMutationNode` class
     */
    global GraphQLMutationNode withFragment(GraphQLFragmentNode fragment) {
        return withFragments(new List<GraphQLFragmentNode>{ fragment });
    }

    /**
     * @description Add multiple fragment definitions for the current mutation node
     * @param fragments The list of fragment definitions to add
     * @return The instance of the current `GraphQLMutationNode` class
     */
    global GraphQLMutationNode withFragments(GraphQLFragmentNode[] fragments) {
        addFragments(fragments);
        return this;
    }

    /**
     * @description Add a variable definition for the current mutation node
     * @param name The variable name
     * @param typeDefinition The variable type definition
     * @return The instance of the current `GraphQLMutationNode` class
     */
    global GraphQLMutationNode withVariable(String name, String typeDefinition) {
        addVariable(name, typeDefinition);
        return this;
    }

    /**
     * @description Create a GraphQL request from the current mutation node
     * @return The instance of the `GraphQLRequest` class
     */
    global GraphQLRequest buildRequest() {
        return asRequest();
    }

    /**
     * @description Get the current node's operation type
     * @return `GraphQLOperation.Mutation` enum value
     */
    global override GraphQLOperation getOperation() {
        return GraphQLOperation.Mutation;
    }
}
