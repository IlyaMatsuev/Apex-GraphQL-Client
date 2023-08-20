/**
 * @description The callback interface that is used for async requests for the client
 * @group Client
 */
global interface IGraphQLResponseCallback {
    /**
     * @description Handle the GraphQL response when it's received
     * @param response The received and parsed GraphQL response
     */
    void received(GraphQLResponse response);
}
