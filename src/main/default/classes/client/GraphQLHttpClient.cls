global class GraphQLHttpClient implements IGraphQLClient {
    private static final Integer DEFAULT_REQUEST_TIMEOUT = 120;

    private final String endpoint;

    // TODO: Take a default endpoint from the Custom Metadata if it's not specified
    private GraphQLHttpClient() {
    }

    global GraphQLHttpClient(String endpoint) {
        this.endpoint = endpoint;
    }

    global GraphQLResponse send(GraphQLRequest request) {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(endpoint);
        httpRequest.setMethod(HttpConstants.METHOD_POST);
        // TODO: Take from Custom Metadata
        httpRequest.setTimeout(DEFAULT_REQUEST_TIMEOUT);
        httpRequest.setHeader(
            HttpConstants.HEADER_NAME_CONTENT_TYPE,
            HttpConstants.HEADER_VALUE_JSON
        );
        httpRequest.setBody(request.toString());
        // TODO: Add an opportunity to add custom headers

        HttpResponse httpResponse = new Http().send(httpRequest);
        if (httpResponse.getStatusCode() != HttpConstants.STATUS_CODE_SUCCESS) {
            // TODO: Handle non 200 status code responses
            throw new CalloutException('Received status code different from 200');
        }

        return GraphQLResponse.parse(httpResponse.getBody());
    }
}
