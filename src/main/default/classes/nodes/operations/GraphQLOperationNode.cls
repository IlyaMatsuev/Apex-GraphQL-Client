/**
 * @description The GraphQL operation node, eathier Query, Mutation or Subscription
 */
global abstract class GraphQLOperationNode extends GraphQLBaseNode {
    /**
     * @description The Map of defined variables for the operation
     */
    global final Map<String, String> variables = new Map<String, String>();

    /**
     * @description The list of defined fragments for the operation
     */
    global final List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode>();

    protected GraphQLOperationNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    protected GraphQLOperationNode(String alias, List<GraphQLNode> nodes) {
        super(alias, nodes);
    }

    /**
     * @description Check the current operation node has any defined variables
     * @return `true` if there are any variable definitions. `false` otherwise
     */
    global Boolean hasVariables() {
        return !variables.isEmpty();
    }

    /**
     * @description Check the current operation node has any defined fragments
     * @return `true` if there are any fragment definitions. `false` otherwise
     */
    global Boolean hasFragments() {
        return !fragments.isEmpty();
    }

    /**
     * @description Get the parser for the operation node
     * @return The instance of the `GraphQLOperationNodeParser` class
     */
    global override IGraphQLParser getParser() {
        return new GraphQLOperationNodeParser();
    }

    /**
     * @description Create a GraphQL request from the current operation node
     * @return The instance of the `GraphQLRequest` class
     */
    global virtual GraphQLRequest asRequest() {
        return new GraphQLRequest(this);
    }

    /**
     * @description Get the GraphQL operation type of the current node
     * @return The instance of the `GraphQLOperation` enum
     */
    global abstract GraphQLOperation getOperation();

    protected GraphQLOperationNode addFragments(List<GraphQLFragmentNode> fragments) {
        this.fragments.addAll(fragments);
        return this;
    }

    protected virtual GraphQLOperationNode addVariable(String name, String typeDefinition) {
        this.variables.put(name, typeDefinition);
        return this;
    }

    public class GraphQLOperationNodeException extends Exception {}
}
