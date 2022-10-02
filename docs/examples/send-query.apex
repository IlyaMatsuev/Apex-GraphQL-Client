/*
query CountriesQuery($limit: Int) {
  countries(filter: "Bel") {
    name
    capital {
      id
      name
    }
  }
  cities(limit: $limit) {
    name
  }
}
*/

GraphQLNode countriesNode = new GraphQLNode('countries')
    .withArgument('filter', 'Bel')
    .withField('name')
    .withNode(new GraphQLNode('capital', new List<String> { 'id', 'name' }));

GraphQLNode citiesNode = new GraphQLNode('cities')
    // Point the argument to the $limit variable
    .withArgument('limit', '$limit')
    .withField('name');

GraphQLQueryNode query = new GraphQLQueryNode('CountriesQuery', new List<GraphQLNode> { countriesNode, citiesNode })
    // Define variable for the query
    .withVariable('limit', 'Int');

GraphQLRequest request = query.asRequest()
    // You can add additional HTTP headers if you need
    .withHeader('Authorization', 'Bearer token')
    // Set value for the variable in the request
    .withVariable('limit', 10);

// Provide GraphQL endpoint to the client constructor
IGraphQLClient client = new GraphQLHttpClient('https://simple-gql-server.herokuapp.com/gql');

GraphQLResponse response = client.send(request);

if (response.hasErrors()) {
    System.debug('First error: ' + response.getErrors().get(0).message);
} else {
    // We can get data or data node
    Map<String, Object> dataMap = response.getData();
    List<Object> cities = (List<Object>) response.getDataNode('cities');

    // We can also get data as a wrapper
    DataWrapper data = (DataWrapper) response.getDataAs(DataWrapper.class);

    // Or get data node as a wrapper
    List<Country> countries = (List<Country>) response.getDataNodeAs('countries', List<Country>.class);
}

// ***************************************** //

public class DataWrapper {
    public List<Country> countries;
    public List<City> cities;
}

public class Country {
    public String name;
    public City capital;
}

public class City {
    public Integer id;
    public String name;
}
