@IsTest(isParallel = true)
private class GraphQLResponseTest {
    @IsTest
    private static void responseWithErrorOnlyTest() {
        String message = 'Error!';
        GraphQLResponseError error = new GraphQLResponseError(message);
        GraphQLResponse response = new GraphQLResponse(error);
        Assert.isTrue(response.hasErrors());
        Assert.isFalse(response.hasData());
        List<GraphQLResponseError> responseErrors = response.getErrors();
        Assert.areEqual(1, responseErrors.size());
        Assert.areEqual(message, responseErrors.get(0).message);
        Assert.isNull(responseErrors.get(0).locations);
        Assert.isNull(responseErrors.get(0).path);
        Assert.isNull(responseErrors.get(0).extensions);
    }

    @IsTest
    private static void parseFromResponseJsonTest() {
        GraphQLResponse response = prepareErrorResponse();
        Assert.isTrue(response.hasErrors());
        Assert.isTrue(response.hasData());
        Map<String, Object> responseData = response.getData();
        Map<String, Object> hero = (Map<String, Object>) response.getDataNode('hero');
        List<GraphQLResponseError> responseErrors = response.getErrors();
        Assert.areEqual(1, responseErrors.size());
        Assert.isTrue(String.isNotBlank(responseErrors.get(0).message));
        Assert.areEqual(1, responseErrors.get(0).locations.size());
        Assert.areEqual(6, responseErrors.get(0).locations.get(0).line);
        Assert.areEqual(7, responseErrors.get(0).locations.get(0).column);
        Assert.areEqual(4, responseErrors.get(0).path.size());
        Assert.areEqual('hero', responseErrors.get(0).path.get(0));
        Assert.areEqual('heroFriends', responseErrors.get(0).path.get(1));
        Assert.areEqual(1, (Integer) responseErrors.get(0).path.get(2));
        Assert.areEqual('name', responseErrors.get(0).path.get(3));
        Assert.areEqual(2, responseErrors.get(0).extensions.size());
        Assert.areEqual(200, (Integer) responseErrors.get(0).extensions.get('code'));
        Assert.areEqual('Test!', responseErrors.get(0).extensions.get('customField'));
        Assert.isTrue(responseData.containsKey('hero'));
        Assert.areEqual('R2-D2', (String) hero.get('name'));
    }

    @IsTest
    private static void getErrorExtensionsAsTypeTest() {
        List<GraphQLResponseError> errors = prepareErrorResponse().getErrors();
        GraphQLResponseError firstError = errors.get(0);
        ErrorExtensionsWrapper extensions = (ErrorExtensionsWrapper) firstError
            .getExtensionsAs(ErrorExtensionsWrapper.class);
        Assert.isNotNull(extensions);
        Assert.areEqual(200, extensions.code);
        Assert.areEqual('Test!', extensions.customField);
    }

    @IsTest
    private static void getDataAsTypeTest() {
        GraphQLResponse response = prepareNoErrorsResponse();
        DataWrapper responseData = (DataWrapper) response.getDataAs(DataWrapper.class);
        Assert.isTrue(response.hasData());
        Assert.isFalse(response.hasErrors());
        Assert.areEqual(0, response.getErrors().size());
        Assert.isNotNull(responseData.hero);
        Assert.isNull(responseData.hero.id);
        Assert.areEqual('R2-D2', responseData.hero.name);
        Assert.areEqual(2, responseData.hero.heroFriends.size());
    }

    @IsTest
    private static void getDataNodeAsTypeTest() {
        GraphQLResponse response = prepareNoErrorsResponse();
        HeroWrapper hero = (HeroWrapper) response.getDataNodeAs('hero', HeroWrapper.class);
        Assert.isTrue(response.hasData());
        Assert.isFalse(response.hasErrors());
        Assert.isNotNull(hero);
        Assert.isNull(hero.id);
        Assert.areEqual('R2-D2', hero.name);
        Assert.areEqual(2, hero.heroFriends.size());
    }

    private static GraphQLResponse prepareNoErrorsResponse() {
        Map<String, Object> response = new Map<String, Object> {
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
        return GraphQLResponse.parse(JSON.serialize(response));
    }

    private static GraphQLResponse prepareErrorResponse() {
        Map<String, Object> response = new Map<String, Object> {
            'errors' => new List<Object> {
                new Map<String, Object> {
                    'message' => 'Name for character with ID 1002 could not be fetched.',
                    'locations' => new List<Object> { new Map<String, Object> { 'line' => 6, 'column' => 7 } },
                    'path' => new List<Object> { 'hero', 'heroFriends', 1, 'name' },
                    'extensions' => new Map<String, Object> { 'code' => 200, 'customField' => 'Test!' }
                }
            },
            'data' => new Map<String, Object> {
                'hero' => new Map<String, Object> {
                    'name' => 'R2-D2',
                    'heroFriends' => new List<Object> {
                        new Map<String, Object> { 'id' => '1000', 'name' => 'Luke Skywalker' },
                        null,
                        new Map<String, Object> { 'id' => '1003', 'name' => 'Leia Organa' }
                    }
                }
            }
        };
        return GraphQLResponse.parse(JSON.serialize(response));
    }

    private class DataWrapper {
        public HeroWrapper hero;
    }

    private class HeroWrapper {
        public String id;
        public String name;
        public List<HeroWrapper> heroFriends;
    }

    private class ErrorExtensionsWrapper {
        public Integer code;
        public String customField;
    }
}
