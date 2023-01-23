/*
{
  countries(filter: "Bel") {
    name
    capital {
      id
      name
    }
  }
  cities(limit: 10) {
    name
  }
}
*/

GraphQLFieldNode countriesNode = new GraphQLFieldNode('countries')
    .withArgument('filter', 'Bel')
    .withField('name')
    .withNode(new GraphQLFieldNode('capital', new List<String> { 'id', 'name' }));

GraphQLFieldNode citiesNode = new GraphQLFieldNode('cities').withArgument('limit', 10).withField('name');

GraphQLFieldNode rootNode = new GraphQLFieldNode(new List<GraphQLFieldNode> { countriesNode, citiesNode });

// Will output a well-formatted node like on the example at the top of the file
System.debug(rootNode.build(true));
