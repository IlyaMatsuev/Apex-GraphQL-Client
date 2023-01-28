/**
 * @description The GraphQL operation node, eathier Query, Mutation or Subscription
 */
global abstract class GraphQLOperationNode extends GraphQLNode {
    /**
     * @description The Map of defined variables for the operation
     */
    global final Map<String, String> variables = new Map<String, String>();

    /**
     * @description The list of fragment definitions added to the operation
     */
    global final List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode>();

    protected GraphQLOperationNode(String alias, List<String> fields) {
        super(alias, fields);
    }

    protected GraphQLOperationNode(String alias, List<GraphQLField> nodes) {
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

    public override GraphQLParser getParser() {
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
        for (GraphQLFragmentNode fragment : fragments) {
            if (fragment.isInline()) {
                throw new GraphQLOperationNodeException(
                    'Not possible to add an inline fragment to the operation node: ' + fragment.name
                );
            }
            this.fragments.add(fragment);
        }
        return this;
    }

    protected virtual GraphQLOperationNode addVariable(String name, String typeDefinition) {
        this.variables.put(name, typeDefinition);
        return this;
    }

    public class GraphQLOperationNodeException extends Exception {}
}
