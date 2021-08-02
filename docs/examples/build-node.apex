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

GraphQLNode countriesNode = new GraphQLNode('countries')
    .withArgument('filter', 'Bel')
    .withField('name')
    .withNode(new GraphQLNode('capital', new List<String> { 'id', 'name' }));

GraphQLNode citiesNode = new GraphQLNode('cities')
    .withArgument('limit', 10)
    .withField('name');

GraphQLNode rootNode = new GraphQLNode(
    new List<GraphQLNode> { countriesNode, citiesNode }
);

// Will output a well-formatted node like on the example at the top of the file
System.debug(rootNode.build(true));
