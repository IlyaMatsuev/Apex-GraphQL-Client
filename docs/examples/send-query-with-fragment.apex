/*
query CountriesQuery {
  countries {
    name
    capital {
      ...CityFields
    }
  }
  cities {
    ...CityFields
  }
}
fragment CityFields on City {
    id
    name
}
*/

// Create fragment instance passing its name and type it's referring to
GraphQLFragmentNode cityFieldsFragment = new GraphQLFragmentNode('CityFields', 'City')
    .withField('id')
    .withField('name');

GraphQLNode countriesNode = new GraphQLNode('countries')
    .withField('name')
    // Use fragment fields for the capital node
    .withNode(new GraphQLNode('capital').withFragment(cityFieldsFragment.name));

GraphQLNode citiesNode = new GraphQLNode('cities')
    // Use fragment fields for the cities node
    .withFragment(cityFieldsFragment.name);

GraphQLQueryNode query = new GraphQLQueryNode(new List<GraphQLNode> { countriesNode, citiesNode })
    // Define fragment for the query
    .withFragment(cityFieldsFragment);

GraphQLRequest request = query.buildRequest();

IGraphQLClient client = new GraphQLHttpClient('https://simple-gql-server.herokuapp.com/gql');

GraphQLResponse response = client.send(request);

if (response.hasErrors()) {
    System.debug('First error: ' + response.getErrors().get(0).message);
} else {
    // Handling response as you wish, same as in other examples
    Map<String, Object> dataMap = response.getData();
    List<Object> cities = (List<Object>) response.getDataNode('cities');
    DataWrapper data = (DataWrapper) response.getDataAs(DataWrapper.class);
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
