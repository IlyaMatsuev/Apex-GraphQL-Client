/**
 * @description The client that can be used to send and receive GraphQL requests and responses
 */
global class GraphQLHttpClient {
    private final String endpoint;

    private static final Boolean SEND_PRETTY_REQUEST = GraphQLConfigs.getBoolean(GraphQLConfigs.Option.SendPrettyQuery);

    /**
     * @description Create an instance of the client passing the GraphQL endpoint
     * @param endpoint The GraphQL endpoint
     * @throws GraphQLHttpClientException If the the provided endpoint is null or empty
     */
    global GraphQLHttpClient(String endpoint) {
        this.endpoint = endpoint;
        if (String.isBlank(endpoint)) {
            throw new GraphQLHttpClientException('GraphQL endpoint cannot be null');
        }
    }

    /**
     * @description Send GraphQL request (Query or Mutation) and wait for the response
     * @param request The instance of request to be send
     * @return The `GraphQLResponse` instance containing parsed GraphQL response
     */
    global GraphQLResponse send(GraphQLRequest request) {
        return send(new RequestWrapper(request));
    }

    /**
     * @description Send GraphQL request (Query or Mutation) without awaiting the response or passing the callback that will be executed when the response is received
     * @param request The instance of request to be send
     * @param callback The instance of `IGraphQLResponseCallback` implementing the callback method. Can be null
     * @return The id of the `Queueable` Apex job
     */
    global Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback) {
        return System.enqueueJob(new QueuableRequestWrapper(this, new RequestWrapper(request), callback));
    }

    private GraphQLResponse send(RequestWrapper request) {
        HttpResponse response = new Http().send(prepareRequest(request));
        GraphQLResponse gqlResponse;
        try {
            gqlResponse = GraphQLResponse.parse(response.getBody());
        } catch (JSONException error) {
            gqlResponse = new GraphQLResponse(
                putError(
                    error,
                    'Got invalid response format from the server' + GraphQLConstants.LINE_BREAK + response.getBody()
                )
            );
        } catch (Exception error) {
            gqlResponse = new GraphQLResponse(
                putError(error, 'Something went wrong with the client. See debug logs for details')
            );
        }

        return gqlResponse;
    }

    private HttpRequest prepareRequest(RequestWrapper gqlRequest) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setTimeout(gqlRequest.timeout);
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
            error.getMessage() + GraphQLConstants.LINE_BREAK + error.getStackTraceString()
        );
        return new GraphQLResponseError(message);
    }

    // This wrapper is needed because of the "Processing" issue with the Queueable job
    private class RequestWrapper {
        public final Map<String, String> headers;
        public final Integer timeout;
        public final String body;

        public RequestWrapper(GraphQLRequest request) {
            this.headers = request.headers;
            this.timeout = request.timeout;
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

    @TestVisible
    private class GraphQLHttpClientException extends Exception {}
}
