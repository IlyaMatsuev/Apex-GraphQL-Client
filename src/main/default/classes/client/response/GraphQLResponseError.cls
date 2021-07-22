global class GraphQLResponseError {
    global String message;
    global List<Location> locations;
    global List<String> path;

    global class Location {
        global Integer line;
        global Integer column;
    }
}
