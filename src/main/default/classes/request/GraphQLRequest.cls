public class GraphQLRequest {

    public GraphQLRequestType type { get; private set; }
    private GraphQLNode root { get; set; }
    private GraphQLRequestGenerator generator {
        get {
            if (generator == null) {
                generator = new GraphQLRequestGenerator(root);
            }
            return generator;
        }
        set;
    }

    public GraphQLRequest(GraphQLRequestType type, GraphQLNode root) {
        this.type = type;
        this.root = root;
    }

    public GraphQLNode asNode() {
        return root;
    }

    public String asString() {
        return asString(false);
    }

    public String asString(Boolean pretty) {
        return generator.generate(pretty);
    }
}
