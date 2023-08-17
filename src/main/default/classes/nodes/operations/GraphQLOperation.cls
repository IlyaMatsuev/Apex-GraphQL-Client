/**
 * @description The GraphQL operation node, eathier Query, Mutation or Subscription
 * @group Operations
 */
global abstract class GraphQLOperation extends GraphQLNode {
    /**
     * @description The list of variable definitions added to the operation
     */
    global final List<GraphQLVariable> variables = new List<GraphQLVariable>();

    /**
     * @description The list of fragment definitions added to the operation
     */
    global final List<GraphQLFragment> fragments = new List<GraphQLFragment>();

    protected GraphQLOperation(String alias, List<String> fields) {
        super(alias, fields);
    }

    protected GraphQLOperation(String alias, List<GraphQLField> fieldNodes) {
        super(alias, fieldNodes);
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
        return new GraphQLOperationParser();
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
     * @return The instance of the `GraphQLOperationType` enum
     */
    global abstract GraphQLOperationType getOperation();

    protected GraphQLOperation addFragments(List<GraphQLFragment> fragments) {
        for (GraphQLFragment fragment : fragments) {
            if (fragment.isInline()) {
                throw new GraphQLOperationException(
                    'Not possible to add an inline fragment to the operation node: ' + fragment.name
                );
            }
            this.fragments.add(fragment);
        }
        return this;
    }

    protected virtual GraphQLOperation addVariable(GraphQLVariable variable) {
        variables.add(variable);
        return this;
    }

    public class GraphQLOperationException extends Exception {}
}
