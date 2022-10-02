/**
 * @description Represents the GraphQL response error entry for the client
 */
global class GraphQLResponseError {
    /**
     * @description Message from the error
     */
    global final String message;

    /**
     * @description The error locations
     */
    global final List<Location> locations;

    /**
     * @description The error path
     */
    global final List<Object> path;

    /**
     * @description The error extensions
     */
    global final Map<String, Object> extensions;

    public GraphQLResponseError(String message) {
        this.message = message;
    }

    private GraphQLResponseError(
        String message,
        List<Location> locations,
        List<Object> path,
        Map<String, Object> extensions
    ) {
        this.message = message;
        this.locations = locations;
        this.path = path;
        this.extensions = extensions;
    }

    /**
     * @description Get the error extension as the provided type
     * @param type The type of the error extension to deserialize to
     * @return The deserialized error extension
     */
    global Object getExtensionsAs(Type type) {
        return JSON.deserialize(JSON.serialize(extensions), type);
    }

    // Need to do this thick because cannot deserialize the instance if there are Object fields in the class
    public static List<GraphQLResponseError> parseErrors(Object errorsObj) {
        List<GraphQLResponseError> errors = new List<GraphQLResponseError>();
        List<Object> errorsList = (List<Object>) JSON.deserializeUntyped(JSON.serialize(errorsObj));
        for (Object errorObj : errorsList) {
            Map<String, Object> errorFields = (Map<String, Object>) errorObj;
            errors.add(
                new GraphQLResponseError(
                    (String) errorFields.get('message'),
                    convertLocations(errorFields.get('locations')),
                    (List<Object>) errorFields.get('path'),
                    (Map<String, Object>) errorFields.get('extensions')
                )
            );
        }
        return errors;
    }

    private static List<Location> convertLocations(Object locationsObj) {
        if (locationsObj == null) {
            return null;
        }

        List<Location> locations = new List<Location>();
        for (Object locationObj : (List<Object>) locationsObj) {
            Map<String, Object> locationFields = (Map<String, Object>) locationObj;
            locations.add(new Location((Integer) locationFields.get('line'), (Integer) locationFields.get('column')));
        }
        return locations;
    }

    global class Location {
        global Integer line;
        global Integer column;

        private Location(Integer line, Integer column) {
            this.line = line;
            this.column = column;
        }
    }
}
