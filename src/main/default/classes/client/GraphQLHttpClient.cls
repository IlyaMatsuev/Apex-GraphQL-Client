global class GraphQLHttpClient implements IGraphQLClient {
    private static final Integer DEFAULT_REQUEST_TIMEOUT = 120;

    private final String endpoint;

    // TODO: Take a default endpoint from the Custom Metadata if it's not specified
    global GraphQLHttpClient(String endpoint) {
        this.endpoint = endpoint;
    }

    global GraphQLResponse send(GraphQLRequest request) {
        HttpResponse httpResponse = new Http().send(prepareRequest(request));
        GraphQLResponse gqlResponse;
        try {
            gqlResponse = GraphQLResponse.parse(httpResponse.getBody());
        } catch (JSONException error) {
            gqlResponse = new GraphQLResponse(
                putError(
                    error,
                    Label.UnexpectedResponseFormatError +
                    CommonConstants.LINE_BREAK +
                    httpResponse.getBody()
                )
            );
        } catch (Exception error) {
            gqlResponse = new GraphQLResponse(putError(error, Label.UnexpectedClientError));
        }

        return gqlResponse;
    }

    global Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback) {
        return System.enqueueJob(new QueuableRequestWrapper(this, request, callback));
    }

    private HttpRequest prepareRequest(GraphQLRequest gqlRequest) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(HttpConstants.METHOD_POST);

        // TODO: Take from Custom Metadata
        request.setTimeout(DEFAULT_REQUEST_TIMEOUT);

        request.setHeader(
            HttpConstants.HEADER_NAME_CONTENT_TYPE,
            HttpConstants.HEADER_VALUE_MIMETYPE_JSON
        );

        for (String header : gqlRequest.customHeaders.keySet()) {
            request.setHeader(header, gqlRequest.customHeaders.get(header));
        }

        // TODO: Configure from Custom Metadata how to send request (pretty or not)
        request.setBody(gqlRequest.toString());
        return request;
    }

    private GraphQLResponseError putError(Exception error, String message) {
        System.debug(
            LoggingLevel.ERROR,
            error.getMessage() +
            CommonConstants.LINE_BREAK +
            error.getStackTraceString()
        );
        return new GraphQLResponseError(message);
    }

    private class QueuableRequestWrapper implements Queueable, Database.AllowsCallouts {
        private IGraphQLClient client;
        private GraphQLRequest request;
        private IGraphQLResponseCallback callback;

        public QueuableRequestWrapper(
            IGraphQLClient client,
            GraphQLRequest request,
            IGraphQLResponseCallback callback
        ) {
            this.client = client;
            this.request = request;
            this.callback = callback;
        }

        public void execute(QueueableContext context) {
            GraphQLResponse response = client.send(request);
            if (callback != null) {
                callback.received(response);
            }
        }
    }
}
