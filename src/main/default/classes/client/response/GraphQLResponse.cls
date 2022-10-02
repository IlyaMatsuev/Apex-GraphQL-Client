/**
 * @description Represents the GraphQL response for the client
 */
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

    /**
     * @description Show if the response contains any errors
     * @return `true` if there are any errors in the response. `false` otherwise
     */
    global Boolean hasErrors() {
        return hasField(ERRORS_FIELD);
    }

    /**
     * @description Show if the response contains the data
     * @return `true` if there is a data field in the response. `false` otherwise
     */
    global Boolean hasData() {
        return hasField(DATA_FIELD);
    }

    /**
     * @description Get the list of errors in the response
     * @return The list of `GraphQLResponseError` instances if there are any errors. Returns an empty list otherwise
     */
    global List<GraphQLResponseError> getErrors() {
        if (hasErrors()) {
            errors = GraphQLResponseError.parseErrors(responseJson.get(ERRORS_FIELD));
        }
        return errors;
    }

    /**
     * @description Get the parsed data from the response as a Map
     * @return The data field deserialized as Map
     */
    global Map<String, Object> getData() {
        return (Map<String, Object>) responseJson.get(DATA_FIELD);
    }

    /**
     * @description Get the parsed data from the response as the provided type
     * @param type The data field type
     * @return The data field deserialized as the provided type
     */
    global Object getDataAs(Type type) {
        return getDataAs(responseJson.get(DATA_FIELD), type);
    }

    /**
     * @description Get a certain field from the parsed data in the response
     * @param nodeName The name of the data field to get
     * @return The value of the field from the data. Returns `null` if the field was not found
     */
    global Object getDataNode(String nodeName) {
        return getData()?.get(nodeName);
    }

    /**
     * @description Get a certain field from the parsed data in the response as the provided type
     * @param nodeName The name of the data field to get
     * @param type The field type
     * @return The value of the field from the data deserialized as the provided type
     */
    global Object getDataNodeAs(String nodeName, Type type) {
        return getDataAs(getData()?.get(nodeName), type);
    }

    public static GraphQLResponse parse(String jsonResponse) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        if (!responseMap.containsKey(ERRORS_FIELD) && !responseMap.containsKey(DATA_FIELD)) {
            throw new JSONException('GraphQL response must have at least "errors" or "data" fields');
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
