/**
 * @description The GraphQL node that can be a part of a GraphQL operation
 */
global class GraphQLField extends GraphQLNode {
    /**
     * @description The alias of the GraphQL node. Can be null
     */
    global String alias { get; private set; }

    /**
     * @description The Map of node arguments with the names as keys
     */
    global final Map<String, GraphQLArgument> arguments = new Map<String, GraphQLArgument>();

    /**
     * @description Create an instance of `GraphQLField` with the empty name
     */
    global GraphQLField() {
        this(GraphQLConstants.EMPTY);
    }

    /**
     * @description Create an instance of `GraphQLField` with the provided name
     * @param name The new node's name
     */
    global GraphQLField(String name) {
        this(name, new List<String>());
    }

    /**
     * @description Create an instance of `GraphQLField` with an empty name and child nodes
     * @param fieldNodes The list of the child nodes
     */
    global GraphQLField(List<GraphQLField> fieldNodes) {
        this(GraphQLConstants.EMPTY, fieldNodes);
    }

    /**
     * @description Create an instance of `GraphQLField` with an empty name and child fields
     * @param fields The list of the child fields
     */
    global GraphQLField(List<String> fields) {
        this(GraphQLConstants.EMPTY, fields);
    }

    /**
     * @description Create an instance of `GraphQLField` with the provided name and child nodes
     * @param fieldNodes The list of the child nodes
     */
    global GraphQLField(String name, List<GraphQLField> fieldNodes) {
        super(name, fieldNodes);
    }

    /**
     * @description Create an instance of `GraphQLField` with the provided name and child fields
     * @param fields The list of the child fields
     */
    global GraphQLField(String name, List<String> fields) {
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
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField byAlias(String alias) {
        this.alias = alias;
        return this;
    }

    /**
     * @description Add a child field to the current node
     * @param field The field name to be added
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withField(String field) {
        return withFields(new List<String> { field });
    }

    /**
     * @description Add multiple child fields to the current node
     * @param fields The list of field names to be added
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withFields(String[] fields) {
        return (GraphQLField) addFields(fields);
    }

    /**
     * @description Add a child node to the current node
     * @param fieldNode The field node to be added
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withField(GraphQLField fieldNode) {
        return withFields(new List<GraphQLField> { fieldNode });
    }

    /**
     * @description Add multiple child nodes to the current node
     * @param fieldNodes The field nodes to be added
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withFields(GraphQLField[] fieldNodes) {
        return (GraphQLField) addFields(fieldNodes);
    }

    /**
     * @description Add a fragment use to the current node
     * @param fragmentName The name of the fragment to be used
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withFragment(String fragmentName) {
        return withFragments(new List<String> { fragmentName });
    }

    /**
     * @description Add multiple fragment uses to the current node
     * @param fragmentNames The list of names of the fragments to be used
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withFragments(String[] fragmentNames) {
        return (GraphQLField) addFragments(fragmentNames);
    }

    /**
     * @description Add an inline fragment to the current node
     * @param fragment The instance of the `GraphQLFragment`. Should be inline fragment without a name
     * @return The current instance of `GraphQLField`
     * @throws GraphQLNodeException If the passed fragment is not inline
     */
    global GraphQLField withInlineFragment(GraphQLFragment fragment) {
        return withInlineFragments(new List<GraphQLFragment> { fragment });
    }

    /**
     * @description Add inline fragments to the current node
     * @param fragment The instances of the `GraphQLFragment`. Should be inline fragments without names
     * @return The current instance of `GraphQLField`
     * @throws GraphQLNodeException If some of the passed fragments are not inline
     */
    global GraphQLField withInlineFragments(GraphQLFragment[] fragments) {
        return (GraphQLField) addInlineFragments(fragments);
    }

    /**
     * @description Add an argument to the current node
     * @param key The argument name
     * @param value The argument value. Use string with the `$` sign for variable referencing
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withArgument(String key, Object value) {
        return withArgument(new GraphQLArgument(key, value));
    }

    /**
     * @description Add an argument to the current node
     * @param argument The argument to be added
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withArgument(GraphQLArgument argument) {
        return withArguments(new List<GraphQLArgument> { argument });
    }

    /**
     * @description Add multiple arguments to the current node
     * @param arguments The list of arguments to be added
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withArguments(GraphQLArgument[] arguments) {
        for (GraphQLArgument argument : arguments) {
            this.arguments.put(argument.key, argument);
        }
        return this;
    }

    /**
     * @description Add a custom directive to the current node
     * @param directive The directive to be added
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField withDirective(GraphQLDirective directive) {
        return (GraphQLField) addDirective(directive);
    }

    /**
     * @description Add the standard `includeIf` directive to the current node
     * @param condition The boolean condition for the directive
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField includeIf(Boolean condition) {
        return (GraphQLField) addStandardDirective('include', condition);
    }

    /**
     * @description Add the standard `includeIf` directive to the current node
     * @param variable The variable reference for the directive. The `$` sign is not required
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField includeIf(String variable) {
        return (GraphQLField) addStandardDirective('include', variable);
    }

    /**
     * @description Add the standard `skipIf` directive to the current node
     * @param condition The boolean condition for the directive
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField skipIf(Boolean condition) {
        return (GraphQLField) addStandardDirective('skip', condition);
    }

    /**
     * @description Add the standard `skipIf` directive to the current node
     * @param variable The variable reference for the directive. The `$` sign is not required
     * @return The current instance of `GraphQLField`
     */
    global GraphQLField skipIf(String variable) {
        return (GraphQLField) addStandardDirective('skip', variable);
    }

    /**
     * @description Convert the current node to the Query node. The arguments and directives are not transferred to the new node
     * @return The new `GraphQLQuery` instance
     */
    global GraphQLQuery asQuery() {
        return new GraphQLQuery(name, getFieldNodes());
    }

    /**
     * @description Convert the current node to the Mutation node. The arguments and directives are not transferred to the new node
     * @return The new `GraphQLMutation` instance
     */
    global GraphQLMutation asMutation() {
        return new GraphQLMutation(name, getFieldNodes());
    }

    /**
     * @description Convert the current node to the Subscription node. The arguments and directives are not transferred to the new node
     * @return The new `GraphQLSubscription` instance
     */
    global GraphQLSubscription asSubscription() {
        return new GraphQLSubscription(name, getFieldNodes());
    }

    public override GraphQLParser getParser() {
        return new GraphQLFieldParser();
    }

    private List<GraphQLField> getFieldNodes() {
        List<GraphQLField> fieldNodes = new List<GraphQLField>();
        for (GraphQLNode node : this.nodes) {
            if (node.isFieldNode()) {
                fieldNodes.add((GraphQLField) node);
            }
        }
        return fieldNodes;
    }
}
