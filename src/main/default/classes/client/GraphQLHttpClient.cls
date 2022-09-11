global class GraphQLHttpClient implements IGraphQLClient {
    private final String endpoint;

    private static final Integer REQUEST_TIMEOUT = GraphQLConfigManager.getInteger(GraphQLConfig.RequestTimeout);
    private static final Boolean SEND_PRETTY_REQUEST = GraphQLConfigManager.getBoolean(GraphQLConfig.SendPrettyQuery);

    global GraphQLHttpClient() {
        this(GraphQLConfigManager.getString(GraphQLConfig.DefaultGraphQLEndpoint));
    }

    global GraphQLHttpClient(String endpoint) {
        this.endpoint = endpoint;
        if (String.isBlank(this.endpoint) || this.endpoint == 'null') {
            throw new GraphQLHttpClientException(Label.NoEndpointProvidedError);
        }
    }

    global GraphQLResponse send(GraphQLRequest request) {
        return send(new RequestWrapper(request));
    }

    global Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback) {
        return System.enqueueJob(new QueuableRequestWrapper(this, new RequestWrapper(request), callback));
    }

    private GraphQLResponse send(RequestWrapper request) {
        HttpResponse httpResponse = new Http().send(prepareRequest(request));
        GraphQLResponse gqlResponse;
        try {
            gqlResponse = GraphQLResponse.parse(httpResponse.getBody());
        } catch (JSONException error) {
            gqlResponse = new GraphQLResponse(
                putError(
                    error,
                    Label.UnexpectedResponseFormatError +
                    GraphQLConstants.LINE_BREAK +
                    httpResponse.getBody()
                )
            );
        } catch (Exception error) {
            gqlResponse = new GraphQLResponse(putError(error, Label.UnexpectedClientError));
        }

        return gqlResponse;
    }

    private HttpRequest prepareRequest(RequestWrapper gqlRequest) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');

        request.setTimeout(REQUEST_TIMEOUT);

        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');

        for (String header : gqlRequest.headers.keySet()) {
            request.setHeader(header, gqlRequest.headers.get(header));
        }

        request.setBody(gqlRequest.body);
        return request;
    }

    private GraphQLResponseError putError(Exception error, String message) {
        System.debug(
            LoggingLevel.ERROR,
            error.getMessage() +
            GraphQLConstants.LINE_BREAK +
            error.getStackTraceString()
        );
        return new GraphQLResponseError(message);
    }

    // This wrapper is needed because of the "Processing" issue with the Queueable job
    private class RequestWrapper {
        public Map<String, String> headers;
        public String body;

        public RequestWrapper(GraphQLRequest request) {
            this.headers = request.customHeaders;
            this.body = request.toString(SEND_PRETTY_REQUEST);
        }
    }

    private class QueuableRequestWrapper implements Queueable, Database.AllowsCallouts {
        private final GraphQLHttpClient client;
        private final RequestWrapper request;
        private final IGraphQLResponseCallback callback;

        public QueuableRequestWrapper(
            GraphQLHttpClient client,
            RequestWrapper request,
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

    private class GraphQLHttpClientException extends Exception {
    }
}
