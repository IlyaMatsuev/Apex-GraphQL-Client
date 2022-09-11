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

        Test.setMock(HttpCalloutMock.class, new CalloutMock());
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

        Test.setMock(HttpCalloutMock.class, new CalloutMock().withInvalidFormat());
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

        Test.setMock(HttpCalloutMock.class, new CalloutMock());
        Test.startTest();
        Id jobId = client.sendAsync(request, new AsyncResponseCallback());
        Test.stopTest();

        System.assert(jobId != null);
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

    private class CalloutMock implements HttpCalloutMock {
        private final Map<String, Object> responseBody = new Map<String, Object>{
            'data' => new Map<String, Object>{
                'hero' => new Map<String, Object>{
                    'name' => 'R2-D2',
                    'heroFriends' => new List<Object>{
                        new Map<String, Object>{ 'id' => '1000', 'name' => 'Luke Skywalker' },
                        new Map<String, Object>{ 'id' => '1003', 'name' => 'Leia Organa' }
                    }
                }
            }
        };

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody(JSON.serialize(responseBody));
            response.setStatusCode(200);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }

        public CalloutMock withInvalidFormat() {
            responseBody.clear();
            responseBody.put('message', 'Error. Not Found');
            return this;
        }
    }
}
