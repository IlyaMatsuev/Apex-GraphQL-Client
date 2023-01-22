/**
 * @description The GraphQL node that can be a part of a GraphQL operation
 */
global class GraphQLNode extends GraphQLBaseNode {
    /**
     * @description The alias of the GraphQL node. Can be null
     */
    global String alias { get; private set; }

    /**
     * @description The Map of node arguments with the names as keys
     */
    global final Map<String, GraphQLArgument> arguments = new Map<String, GraphQLArgument>();

    /**
     * @description Create an instance of `GraphQLNode` with the empty name
     */
    global GraphQLNode() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create an instance of `GraphQLNode` with the provided name
     * @param name The new node's name
     */
    global GraphQLNode(String name) {
        this(name, new List<String>());
    }

    /**
     * @description Create an instance of `GraphQLNode` with an empty name and child nodes
     * @param nodes The list of the child nodes
     */
    global GraphQLNode(List<GraphQLNode> nodes) {
        this(GraphQLConstants.EMPTY, nodes);
    }

    /**
     * @description Create an instance of `GraphQLNode` with an empty name and child fields
     * @param fields The list of the child fields
     */
    global GraphQLNode(List<String> fields) {
        this(GraphQLConstants.EMPTY, fields);
    }

    /**
     * @description Create an instance of `GraphQLNode` with the provided name and child nodes
     * @param nodes The list of the child nodes
     */
    global GraphQLNode(String name, List<GraphQLNode> nodes) {
        super(name, nodes);
    }

    /**
     * @description Create an instance of `GraphQLNode` with the provided name and child fields
     * @param fields The list of the child fields
     */
    global GraphQLNode(String name, List<String> fields) {
        super(name, fields);
    }

    /**
     * @description Check if the current node contains any arguments
     * @return `true` if there are any arguments. `false` otherwise
     */
    global Boolean hasArguments() {
        return !arguments.isEmpty();
    }

    /**
     * @description Add an alias to the current node
     * @param alias The node's alias name
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode byAlias(String alias) {
        this.alias = alias;
        return this;
    }

    /**
     * @description Add a child field to the current node
     * @param field The field name to be added
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withField(String field) {
        return withFields(new List<String> { field });
    }

    /**
     * @description Add multiple child fields to the current node
     * @param fields The list of field names to be added
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withFields(String[] fields) {
        addFields(fields);
        return this;
    }

    /**
     * @description Add a child node to the current node
     * @param node The node to be added
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withNode(GraphQLNode node) {
        return withNodes(new List<GraphQLNode> { node });
    }

    /**
     * @description Add multiple child nodes to the current node
     * @param nodes The nodes to be added
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withNodes(GraphQLNode[] nodes) {
        return (GraphQLNode) addNodes(nodes);
    }

    /**
     * @description Add a fragment use to the current node
     * @param fragmentName The name of the fragment to be used
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withFragment(String fragmentName) {
        return withFragments(new List<String> { fragmentName });
    }

    /**
     * @description Add multiple fragment uses to the current node
     * @param fragmentNames The list of names of the fragments to be used
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withFragments(String[] fragmentNames) {
        return (GraphQLNode) addFragments(fragmentNames);
    }

    /**
     * @description Add an inline fragment to the current node
     * @param fragment The instance of the `GraphQLFragmentNode`. Should be inline fragment without a name
     * @return The current instance of `GraphQLNode`
     * @throws GraphQLBaseNodeException If the passed fragment is not inline
     */
    global GraphQLNode withInlineFragment(GraphQLFragmentNode fragment) {
        return withInlineFragments(new List<GraphQLFragmentNode> { fragment });
    }

    /**
     * @description Add inline fragments to the current node
     * @param fragment The instances of the `GraphQLFragmentNode`. Should be inline fragments without names
     * @return The current instance of `GraphQLNode`
     * @throws GraphQLBaseNodeException If some of the passed fragments are not inline
     */
    global GraphQLNode withInlineFragments(GraphQLFragmentNode[] fragments) {
        return (GraphQLNode) addInlineFragments(fragments);
    }

    /**
     * @description Add an argument to the current node
     * @param key The argument name
     * @param value The argument value. Use string with the `$` sign for variable referencing
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withArgument(String key, Object value) {
        return withArgument(new GraphQLArgument(key, value));
    }

    /**
     * @description Add an argument to the current node
     * @param argument The argument to be added
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withArgument(GraphQLArgument argument) {
        return withArguments(new List<GraphQLArgument> { argument });
    }

    /**
     * @description Add multiple arguments to the current node
     * @param arguments The list of arguments to be added
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode withArguments(GraphQLArgument[] arguments) {
        for (GraphQLArgument argument : arguments) {
            this.arguments.put(argument.key, argument);
        }
        return this;
    }

    /**
     * @description Add the standard `includeIf` directive to the current node
     * @param condition The boolean condition for the directive
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode includeIf(Boolean condition) {
        return (GraphQLNode) addDirective(new GraphQLDirective(GraphQLDirectiveType.Include, condition));
    }

    /**
     * @description Add the standard `includeIf` directive to the current node
     * @param variable The variable reference for the directive. The `$` sign is not required
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode includeIf(String variable) {
        return (GraphQLNode) addDirective(new GraphQLDirective(GraphQLDirectiveType.Include, variable));
    }

    /**
     * @description Add the standard `skipIf` directive to the current node
     * @param condition The boolean condition for the directive
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode skipIf(Boolean condition) {
        return (GraphQLNode) addDirective(new GraphQLDirective(GraphQLDirectiveType.Skip, condition));
    }

    /**
     * @description Add the standard `skipIf` directive to the current node
     * @param variable The variable reference for the directive. The `$` sign is not required
     * @return The current instance of `GraphQLNode`
     */
    global GraphQLNode skipIf(String variable) {
        return (GraphQLNode) addDirective(new GraphQLDirective(GraphQLDirectiveType.Skip, variable));
    }

    /**
     * @description Convert the current node to the Query node. The arguments and directives are not transferred to the new node
     * @return The new `GraphQLQueryNode` instance
     */
    global GraphQLQueryNode asQuery() {
        return new GraphQLQueryNode(name, getFieldNodes());
    }

    /**
     * @description Convert the current node to the Mutation node. The arguments and directives are not transferred to the new node
     * @return The new `GraphQLMutationNode` instance
     */
    global GraphQLMutationNode asMutation() {
        return new GraphQLMutationNode(name, getFieldNodes());
    }

    /**
     * @description Convert the current node to the Subscription node. The arguments and directives are not transferred to the new node
     * @return The new `GraphQLSubscriptionNode` instance
     */
    global GraphQLSubscriptionNode asSubscription() {
        return new GraphQLSubscriptionNode(name, getFieldNodes());
    }

    /**
     * @description Get GraphQL node parser
     * @return The instance of the `GraphQLNodeParser` class
     */
    global override IGraphQLParser getParser() {
        return new GraphQLNodeParser();
    }

    private List<GraphQLNode> getFieldNodes() {
        List<GraphQLNode> fieldNodes = new List<GraphQLNode>();
        for (GraphQLBaseNode node : this.nodes) {
            if (node.isFieldNode()) {
                fieldNodes.add((GraphQLNode) node);
            }
        }
        return fieldNodes;
    }
}
