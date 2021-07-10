public virtual class GraphQLNode {

    public String name { get; private set; }
    private List<GraphQLNode> nodes { get; set; }

    public GraphQLNode(String name) {
        this(name, new List<GraphQLNode>());
    }

    public GraphQLNode(String name, GraphQLNode node) {
        this(name, new List<GraphQLNode> { node });
    }

    public GraphQLNode(String name, List<GraphQLNode> nodes) {
        this.name = name;
        this.nodes = nodes;
    }

    public GraphQLNode add(GraphQLNode node) {
        return add(new GraphQLNode[] { node });
    }

    public GraphQLNode add(GraphQLNode[] nodes) {
        for (GraphQLNode node : nodes) {
            if (!hasNode(node)) {
                this.nodes.add(node);
            }
        }
        return this;
    }

    public Boolean hasNode(GraphQLNode node) {
        return hasNodes(new GraphQLNode[] { node });
    }

    public Boolean hasNodes(GraphQLNode[] nodes) {
        for (GraphQLNode existingNode : this.nodes) {
            for (GraphQLNode node : nodes) {
                if (existingNode.name == node.name) {
                    return true;
                }
            }
        }
        return false;
    }

    public Boolean hasNodes() {
        return !this.nodes.isEmpty();
    }

    public List<GraphQLNode> asList() {
        return this.nodes;
    }
}
