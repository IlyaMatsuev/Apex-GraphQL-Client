@IsTest(isParallel = true)
private class GraphQLHttpClientTest {
    private static final String TEST_GQL_ENDPOINT = 'https://test.gql.endpoint.com';

    @IsTest
    private static void createClientWithoutEndpointNegativeTest() {
        Exception error;
        try {
            new GraphQLHttpClient('');
        } catch (Exception ex) {
            error = ex;
        }

        Assert.isNotNull(error);
        Assert.isInstanceOfType(error, GraphQLHttpClient.GraphQLHttpClientException.class);
    }

    /**
     * E2E tests below
     */

    @IsTest
    private static void sendRequestSyncPositiveTest() {
        GraphQLHttpClient client = new GraphQLHttpClient(TEST_GQL_ENDPOINT);
        GraphQLField heroNode = new GraphQLField('hero', new List<String> { 'name' })
            .withField(new GraphQLField('heroFriends', new List<String> { 'id', 'name' }));

        GraphQLQuery query = new GraphQLQuery(heroNode);
        GraphQLRequest request = query.asRequest().withHeader('Authorization', 'token');

        Test.setMock(HttpCalloutMock.class, new CalloutMock());
        Test.startTest();
        GraphQLResponse response = client.send(request);
        Test.stopTest();

        Assert.isFalse(response.hasErrors());
        Assert.isTrue(response.hasData());

        HeroWrapper hero = (HeroWrapper) response.getDataNodeAs('hero', HeroWrapper.class);

        Assert.isNull(hero.id);
        Assert.areEqual('R2-D2', hero.name);
        Assert.areEqual(2, hero.heroFriends.size());
    }

    @IsTest
    private static void sendRequestSyncInvalidResponseFormatTest() {
        GraphQLHttpClient client = new GraphQLHttpClient(TEST_GQL_ENDPOINT);
        GraphQLField heroNode = new GraphQLField('hero', new List<String> { 'name' })
            .withField(new GraphQLField('heroFriends', new List<String> { 'id', 'name' }));

        GraphQLQuery query = new GraphQLQuery(heroNode);
        GraphQLRequest request = query.asRequest();

        Test.setMock(HttpCalloutMock.class, new CalloutMock().withInvalidFormat());
        Test.startTest();
        GraphQLResponse response = client.send(request);
        Test.stopTest();

        Assert.isTrue(response.hasErrors());
        Assert.isFalse(response.hasData());

        List<GraphQLResponseError> errors = response.getErrors();

        Assert.areEqual(1, errors.size());
        Assert.isTrue(errors.get(0).message.startsWith('Got invalid response format from the server'));
    }

    @IsTest
    private static void sendRequestAsyncPositiveTest() {
        GraphQLHttpClient client = new GraphQLHttpClient(TEST_GQL_ENDPOINT);
        GraphQLField heroNode = new GraphQLField('hero', new List<String> { 'name' })
            .withField(new GraphQLField('heroFriends', new List<String> { 'id', 'name' }));

        GraphQLQuery query = new GraphQLQuery(heroNode);
        GraphQLRequest request = query.asRequest().withHeader('Authorization', 'token');

        Test.setMock(HttpCalloutMock.class, new CalloutMock());
        Test.startTest();
        Id jobId = client.sendAsync(request, new AsyncResponseCallback());
        Test.stopTest();

        Assert.isNotNull(jobId);
    }

    private class HeroWrapper {
        public String id;
        public String name;
        public List<HeroWrapper> heroFriends;
    }

    private class AsyncResponseCallback implements IGraphQLResponseCallback {
        public void received(GraphQLResponse response) {
            Assert.isNotNull(response);
            Assert.isFalse(response.hasErrors());
            Assert.isTrue(response.hasData());

            HeroWrapper hero = (HeroWrapper) response.getDataNodeAs('hero', HeroWrapper.class);

            Assert.isNull(hero.id);
            Assert.areEqual('R2-D2', hero.name);
            Assert.areEqual(2, hero.heroFriends.size());
        }
    }

    private class CalloutMock implements HttpCalloutMock {
        private final Map<String, Object> responseBody = new Map<String, Object> {
            'data' => new Map<String, Object> {
                'hero' => new Map<String, Object> {
                    'name' => 'R2-D2',
                    'heroFriends' => new List<Object> {
                        new Map<String, Object> { 'id' => '1000', 'name' => 'Luke Skywalker' },
                        new Map<String, Object> { 'id' => '1003', 'name' => 'Leia Organa' }
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
