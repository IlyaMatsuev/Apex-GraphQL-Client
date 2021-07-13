public class GraphQLRequest {

    public GraphQLOperation operation { get; private set; }

    private GraphQLNode root;

    private String stringRequest {
        get;
        set {
            if (String.isNotBlank(value)) {
                GraphQLRequest request = parser.fromString(stringRequest);
                this.operation = request?.operation;
                this.root = request?.root;
            }
        }
    }

    private GraphQLRequestParser parser {
        get {
            if (parser == null) {
                parser = new GraphQLRequestParser(root);
            }
            return parser;
        }
        set;
    }

    public GraphQLRequest(String stringRequest) {
        this.stringRequest = stringRequest;
    }

    public GraphQLRequest(GraphQLOperation operation, GraphQLNode root) {
        this.operation = operation == null ? GraphQLOperation.Query : operation;
        this.root = root;
    }

    public GraphQLNode asNode() {
        return root;
    }

    public String asString() {
        return asString(false);
    }

    public String asString(Boolean pretty) {
        if (String.isNotBlank(stringRequest)) {
            return stringRequest;
        }
        return parser.toString(pretty);
    }
}
