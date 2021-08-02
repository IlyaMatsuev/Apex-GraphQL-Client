global class GraphQLResponseError {
    global String message;
    global List<Location> locations;
    global List<String> path;
    // TODO: Try to find workaround to use Map<String, Object>
    global Map<String, String> extensions;

    public GraphQLResponseError(String message) {
        this.message = message;
    }

    global class Location {
        global Integer line;
        global Integer column;
    }
}
