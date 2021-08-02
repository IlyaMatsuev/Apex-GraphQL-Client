global class GraphQLHttpClient implements IGraphQLClient {
    private static final Integer DEFAULT_REQUEST_TIMEOUT = 120000;

    private final String endpoint;

    // TODO: Take a default endpoint from the Custom Metadata if it's not specified
    global GraphQLHttpClient(String endpoint) {
        this.endpoint = endpoint;
    }

    global GraphQLResponse send(GraphQLRequest request) {
        return send(new RequestWrapper(request));
    }

    global Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback) {
        return System.enqueueJob(
            new QueuableRequestWrapper(this, new RequestWrapper(request), callback)
        );
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
                    CommonConstants.LINE_BREAK +
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
        request.setMethod(HttpConstants.METHOD_POST);

        // TODO: Take from Custom Metadata
        request.setTimeout(DEFAULT_REQUEST_TIMEOUT);

        request.setHeader(
            HttpConstants.HEADER_NAME_CONTENT_TYPE,
            HttpConstants.HEADER_VALUE_MIMETYPE_JSON
        );
        request.setHeader(
            HttpConstants.HEADER_NAME_ACCEPT,
            HttpConstants.HEADER_VALUE_MIMETYPE_JSON
        );

        for (String header : gqlRequest.headers.keySet()) {
            request.setHeader(header, gqlRequest.headers.get(header));
        }

        // TODO: Configure from Custom Metadata how to send request (pretty or not)
        request.setBody(gqlRequest.body);
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

    // This wrapper is needed because of the "Processing" issue with the Queueable job
    private class RequestWrapper {
        public Map<String, String> headers;
        public String body;

        public RequestWrapper(GraphQLRequest request) {
            this.headers = request.customHeaders;
            this.body = request.toString();
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
}
