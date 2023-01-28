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

GraphQLField countriesNode = new GraphQLField('countries')
    .withArgument('filter', 'Bel')
    .withField('name')
    .withNode(new GraphQLField('capital', new List<String> { 'id', 'name' }));

GraphQLField citiesNode = new GraphQLField('cities').withArgument('limit', 10).withField('name');

GraphQLField rootNode = new GraphQLField(new List<GraphQLField> { countriesNode, citiesNode });

// Will output a well-formatted node like on the example at the top of the file
System.debug(rootNode.build(true));
