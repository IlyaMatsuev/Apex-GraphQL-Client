/**
 * @description Defines the base properties and methods for every GraphQL node
 */
global abstract class GraphQLBaseNode {
    /**
     * @description The GraphQL node name. Can be empty but cannot be `null`
     */
    global final String name;

    /**
     * @description The list of child nodes
     */
    global final List<GraphQLBaseNode> nodes = new List<GraphQLBaseNode>();

    protected GraphQLBaseNode(String name, List<String> fields) {
        this(name, new List<GraphQLNode>(), fields);
    }

    protected GraphQLBaseNode(String name, List<GraphQLNode> nodes) {
        this(name, nodes, new List<String>());
    }

    protected GraphQLBaseNode(String name, List<GraphQLNode> nodes, List<String> fields) {
        this.name = name;
        this.nodes.addAll(nodes);

        if (!fields.isEmpty()) {
            addFields(fields);
        }
    }

    /**
     * @description Check if the current node is an instance of `GraphQLNode`
     * @return `true` if the current instance is `GraphQLNode`
     */
    global Boolean isFieldNode() {
        return this instanceof GraphQLNode;
    }

    /**
     * @description Check if the current node is an instance of `GraphQLFragmentNode`
     * @return `true` if the current instance is `GraphQLFragmentNode`
     */
    global Boolean isFragmentNode() {
        return this instanceof GraphQLFragmentNode;
    }

    /**
     * @description Check if the provided node exists in the child nodes. Searches by the node's name
     * @param node The target GraphQL node to search for
     * @return `true` if the node with the same name is found in child nodes. `false` otherwise
     */
    global virtual Boolean hasNode(GraphQLNode node) {
        return hasNodes(new List<GraphQLNode> { node });
    }

    /**
     * @description Check if one of the provided nodes exist in the child nodes. Searches by the nodes` names
     * @param nodes The target list of GraphQL node to search for
     * @return `true` if one of the nodes with the same name is found in child nodes. `false` otherwise
     */
    global virtual Boolean hasNodes(GraphQLNode[] nodes) {
        for (GraphQLBaseNode existingNode : this.nodes) {
            for (GraphQLNode node : nodes) {
                if (existingNode.name == node.name) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * @description Check if there are any child nodes
     * @return `true` if the child nodes list is not empty. `false` otherwise
     */
    global Boolean hasNodes() {
        return !nodes.isEmpty();
    }

    /**
     * @description Parse the node as a string
     * @return String representation of the node
     */
    global String build() {
        return build(false);
    }

    /**
     * @description Parse the node as a string
     * @param pretty Prettify the output if the value is `true`
     * @return String representation of the node
     */
    global String build(Boolean pretty) {
        return getParser().parse(this, pretty);
    }

    /**
     * @description Get the parser for this particular node type
     * @return Implementation of the `IGraphQLParser` interface
     */
    global abstract IGraphQLParser getParser();

    protected virtual GraphQLBaseNode addFields(String[] fields) {
        List<GraphQLNode> nodes = new List<GraphQLNode>();
        for (String field : fields) {
            nodes.add(new GraphQLNode(field));
        }
        return addNodes(nodes);
    }

    protected virtual GraphQLBaseNode addNodes(GraphQLNode[] nodes) {
        for (GraphQLNode node : nodes) {
            if (!hasNode(node)) {
                this.nodes.add(node);
            }
        }
        return this;
    }

    protected virtual GraphQLBaseNode addFragments(String[] fragmentNames) {
        List<String> fields = new List<String>();
        for (String fragmentName : fragmentNames) {
            fields.add(GraphQLConstants.DOT.repeat(3) + fragmentName);
        }
        return addFields(fields);
    }

    protected virtual GraphQLBaseNode addInlineFragments(GraphQLFragmentNode[] fragments) {
        for (GraphQLFragmentNode fragment : fragments) {
            if (!fragment.isInline()) {
                throw new GraphQLBaseNodeException('Not possible to add non-inline fragment: ' + fragment.name);
            }
        }
        nodes.addAll(fragments);
        return this;
    }

    @TestVisible
    private class GraphQLBaseNodeException extends Exception {}
}
