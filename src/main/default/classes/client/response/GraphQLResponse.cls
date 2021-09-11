global class GraphQLResponse {
    private static final String ERRORS_FIELD = 'errors';
    private static final String DATA_FIELD = 'data';

    private final Map<String, Object> responseJson;

    private List<GraphQLResponseError> errors = new List<GraphQLResponseError>();

    public GraphQLResponse(GraphQLResponseError error) {
        this(new Map<String, Object>{ ERRORS_FIELD => new List<GraphQLResponseError>{ error } });
    }

    private GraphQLResponse(Map<String, Object> responseJson) {
        this.responseJson = responseJson;
    }

    global Boolean hasErrors() {
        return hasField(ERRORS_FIELD);
    }

    global Boolean hasData() {
        return hasField(DATA_FIELD);
    }

    global List<GraphQLResponseError> getErrors() {
        if (hasErrors()) {
            errors = GraphQLResponseError.parseErrors(responseJson.get(ERRORS_FIELD));
        }
        return errors;
    }

    global Map<String, Object> getData() {
        return (Map<String, Object>) responseJson.get(DATA_FIELD);
    }

    global Object getDataAs(Type type) {
        return getDataAs(responseJson.get(DATA_FIELD), type);
    }

    global Object getDataNode(String nodeName) {
        return getData()?.get(nodeName);
    }

    global Object getDataNodeAs(String nodeName, Type type) {
        return getDataAs(getData()?.get(nodeName), type);
    }

    public static GraphQLResponse parse(String jsonResponse) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
            jsonResponse
        );
        if (!responseMap.containsKey(ERRORS_FIELD) && !responseMap.containsKey(DATA_FIELD)) {
            throw new JSONException(Label.InvalidGraphQLResponseError);
        }
        return new GraphQLResponse(responseMap);
    }

    private Boolean hasField(String fieldName) {
        return responseJson.containsKey(fieldName) && responseJson.get(fieldName) != null;
    }

    private Object getDataAs(Object data, Type type) {
        return serializeObject(data, type);
    }

    // Needs to be able to cast types that were serialized from Map<String, ANY>
    private Object serializeObject(Object obj, Type type) {
        return JSON.deserialize(JSON.serialize(obj), type);
    }
}
