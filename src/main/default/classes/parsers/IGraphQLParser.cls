/**
 * @description Defines the GraphQL node parser interface that can be used to create your own implementation of any GraphQL node parser
 */
global interface IGraphQLParser {
    /**
     * @description Parse the GraphQL node to string
     * @param node The instance of the `GraphQLBaseNode` node to parse
     * @param pretty Flag defining whether the node should be parsed pretty or not
     * @return The string representation of the GraphQL node
     */
    String parse(GraphQLBaseNode node, Boolean pretty);
}
