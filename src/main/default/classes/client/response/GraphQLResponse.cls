global class GraphQLResponse {
    global List<GraphQLResponseError> errors;
    global Object data;

    public static GraphQLResponse parse(String jsonResponse) {
        return (GraphQLResponse) JSON.deserialize(jsonResponse, GraphQLResponse.class);
    }
}
