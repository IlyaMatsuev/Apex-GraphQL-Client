/*
mutation CreateCountry($country: NewCountryInput!) {
  createCountry(country: $country) {
    id
    name
  }
}
*/

GraphQLNode createCountryNode = new GraphQLNode('createCountry')
    // Point the argument to the $country variable
    .withArgument('country', '$country')
    .withField('id')
    .withField('name');

GraphQLMutationNode mutation = new GraphQLMutationNode('CreateCountry', createCountryNode)
    // Define variable for the mutation
    .withVariable('country', 'NewCountryInput!');

// Create our input object
Country country = new Country();
country.name = 'Belarus';
country.capital = 'Minsk';
country.population = 9000000;

GraphQLRequest request = mutation.buildRequest()
    // You can add additional HTTP headers if you need
    .withHeader('Authorization', 'Bearer token')
    // Set value for the variable in the request
    .withVariable('country', country);

// Provide GraphQL endpoint to the client constructor
IGraphQLClient client = new GraphQLHttpClient('https://simple-gql-server.herokuapp.com/gql');

GraphQLResponse response = client.send(request);

if (response.hasErrors()) {
    System.debug('First error: ' + response.getErrors().get(0).message);
} else {
    // We can get data or data node
    Map<String, Object> dataMap = response.getData();
    Map<String, Object> createCountryMap = (Map<String, Object>) response.getDataNode('createCountry');

    // We can also get data as a wrapper
    DataWrapper data = (DataWrapper) response.getDataAs(DataWrapper.class);

    // Or get data node as a wrapper
    Country country = (Country) response.getDataNodeAs('createCountry', Country.class);
}

// ***************************************** //

public class DataWrapper {
    public Country createCountry;
}

public class Country {
    public Integer id;
    public String name;
    public Long population;
    public String capital;
}
