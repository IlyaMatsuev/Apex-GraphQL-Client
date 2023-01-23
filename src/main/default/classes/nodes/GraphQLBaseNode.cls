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

    /**
     * @description The list of directives attached to the node
     */
    global final List<GraphQLDirective> directives = new List<GraphQLDirective>();

    protected GraphQLBaseNode(String name, List<String> fields) {
        this(name, new List<GraphQLFieldNode>(), fields);
    }

    protected GraphQLBaseNode(String name, List<GraphQLFieldNode> nodes) {
        this(name, nodes, new List<String>());
    }

    protected GraphQLBaseNode(String name, List<GraphQLFieldNode> nodes, List<String> fields) {
        this.name = name;
        this.nodes.addAll(nodes);

        if (!fields.isEmpty()) {
            addFields(fields);
        }
    }

    /**
     * @description Check if the current node is an instance of `GraphQLFieldNode`
     * @return `true` if the current instance is `GraphQLFieldNode`
     */
    global Boolean isFieldNode() {
        return this instanceof GraphQLFieldNode;
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
    global virtual Boolean hasNode(GraphQLFieldNode node) {
        return hasNodes(new List<GraphQLFieldNode> { node });
    }

    /**
     * @description Check if one of the provided nodes exist in the child nodes. Searches by the nodes` names
     * @param nodes The target list of GraphQL node to search for
     * @return `true` if one of the nodes with the same name is found in child nodes. `false` otherwise
     */
    global virtual Boolean hasNodes(GraphQLFieldNode[] nodes) {
        for (GraphQLBaseNode existingNode : this.nodes) {
            for (GraphQLFieldNode node : nodes) {
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
     * @description Check if the current node contains any directives
     * @return `true` if there are any directives. `false` otherwise
     */
    global Boolean hasDirectives() {
        return !directives.isEmpty();
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

    public virtual GraphQLParser getParser() {
        throw new GraphQLBaseNodeException('No parser implementation found for this node');
    }

    protected virtual GraphQLBaseNode addFields(String[] fields) {
        List<GraphQLFieldNode> nodes = new List<GraphQLFieldNode>();
        for (String field : fields) {
            nodes.add(new GraphQLFieldNode(field));
        }
        return addNodes(nodes);
    }

    protected virtual GraphQLBaseNode addNodes(GraphQLFieldNode[] nodes) {
        for (GraphQLFieldNode node : nodes) {
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

    protected virtual GraphQLBaseNode addDirective(GraphQLDirective directive) {
        directives.add(directive);
        return this;
    }

    @TestVisible
    private class GraphQLBaseNodeException extends Exception {}
}
