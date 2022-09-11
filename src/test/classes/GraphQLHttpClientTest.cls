@IsTest(IsParallel=true)
private class GraphQLHttpClientTest {
    private static final String TEST_GQL_ENDPOINT = 'https://test.gql.endpoint.com';

    @IsTest
    private static void createClientWithoutEndpointNegativeTest() {
        IGraphQLClient client;
        Exception error;
        try {
            client = new GraphQLHttpClient();
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(client == null);
        System.assert(error != null);
        System.assertEquals(Label.NoEndpointProvidedError, error.getMessage());
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void sendRequestSyncPositiveTest() {
        IGraphQLClient client = new GraphQLHttpClient(TEST_GQL_ENDPOINT);
        GraphQLNode heroNode = new GraphQLNode('hero', new List<String>{ 'name' })
            .withNode(new GraphQLNode('heroFriends', new List<String>{ 'id', 'name' }));

        GraphQLQueryNode query = new GraphQLQueryNode(heroNode);
        GraphQLRequest request = query.buildRequest().withHeader('Authorization', 'token');

        Test.setMock(HttpCalloutMock.class, getServerMock('GraphQLResponse_NoErrors_OneNode'));
        Test.startTest();
        GraphQLResponse response = client.send(request);
        Test.stopTest();

        System.assert(!response.hasErrors());
        System.assert(response.hasData());

        HeroWrapper hero = (HeroWrapper) response.getDataNodeAs('hero', HeroWrapper.class);

        System.assertEquals(null, hero.id);
        System.assertEquals('R2-D2', hero.name);
        System.assertEquals(2, hero.heroFriends.size());
    }

    @IsTest
    private static void sendRequestSyncInvalidResponseFormatTest() {
        IGraphQLClient client = new GraphQLHttpClient(TEST_GQL_ENDPOINT);
        GraphQLNode heroNode = new GraphQLNode('hero', new List<String>{ 'name' })
            .withNode(new GraphQLNode('heroFriends', new List<String>{ 'id', 'name' }));

        GraphQLQueryNode query = new GraphQLQueryNode(heroNode);
        GraphQLRequest request = query.buildRequest();

        Test.setMock(HttpCalloutMock.class, getServerMock('GraphQLResponse_InvalidFormat'));
        Test.startTest();
        GraphQLResponse response = client.send(request);
        Test.stopTest();

        System.assert(response.hasErrors());
        System.assert(!response.hasData());

        List<GraphQLResponseError> errors = response.getErrors();

        System.assertEquals(1, errors.size());
        System.assert(errors.get(0).message.startsWith(Label.UnexpectedResponseFormatError));
    }

    @IsTest
    private static void sendRequestAsyncPositiveTest() {
        IGraphQLClient client = new GraphQLHttpClient(TEST_GQL_ENDPOINT);
        GraphQLNode heroNode = new GraphQLNode('hero', new List<String>{ 'name' })
            .withNode(new GraphQLNode('heroFriends', new List<String>{ 'id', 'name' }));

        GraphQLQueryNode query = new GraphQLQueryNode(heroNode);
        GraphQLRequest request = query.buildRequest().withHeader('Authorization', 'token');

        Test.setMock(HttpCalloutMock.class, getServerMock('GraphQLResponse_NoErrors_OneNode'));
        Test.startTest();
        Id jobId = client.sendAsync(request, new AsyncResponseCallback());
        Test.stopTest();

        System.assert(jobId != null);
    }

    private static StaticResourceCalloutMock getServerMock(String responseBodyFileName) {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(responseBodyFileName);
        mock.setStatusCode(HttpConstants.STATUS_CODE_SUCCESS);
        mock.setHeader(HttpConstants.HEADER_NAME_CONTENT_TYPE, HttpConstants.HEADER_VALUE_MIMETYPE_JSON);
        return mock;
    }

    private class HeroWrapper {
        public String id;
        public String name;
        public List<HeroWrapper> heroFriends;
    }

    private class AsyncResponseCallback implements IGraphQLResponseCallback {
        public void received(GraphQLResponse response) {
            System.assert(response != null);
            System.assert(!response.hasErrors());
            System.assert(response.hasData());

            HeroWrapper hero = (HeroWrapper) response.getDataNodeAs('hero', HeroWrapper.class);

            System.assertEquals(null, hero.id);
            System.assertEquals('R2-D2', hero.name);
            System.assertEquals(2, hero.heroFriends.size());
        }
    }
}
