/*
query CountriesQuery($withCities: Boolean!) {
  countries {
    name
    capital {
      id
      name
    }
  }
  cities @include(if: $withCities) {
    id
    name
  }
}
*/

GraphQLNode countriesNode = new GraphQLNode('countries')
    .withField('name')
    .withNode(new GraphQLNode('capital', new List<String> { 'id', 'name' }));

GraphQLNode citiesNode = new GraphQLNode('cities', new List<String> { 'id', 'name' })
    // Indicate that we want to include this node only if the variable $withCities equals true
    // You can also use .skipIf() method
    .includeIf('withCities');

GraphQLQueryNode query = new GraphQLQueryNode(new List<GraphQLNode> { countriesNode, citiesNode })
    // Define our $withCities variable. Note that it needs to be marked as required in order to use it in directives
    .defineVariable('withCities', 'Boolean!');

GraphQLRequest request = query.asRequest()
    // Pass the $withCities variable value to the request
    .withVariable('withCities', false);

GraphQLHttpClient client = new GraphQLHttpClient('https://simple-gql-server.herokuapp.com/gql');

GraphQLResponse response = client.send(request);

if (response.hasErrors()) {
    System.debug('First error: ' + response.getErrors().get(0).message);
} else {
    // Handling response as you wish, same as in other examples
}
