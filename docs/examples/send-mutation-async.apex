/*
mutation CreateCountry {
  createCountry(country: {name: "Belarus", capital: "Minsk", population: 9000000}) {
    id
    name
  }
}
*/

Country country = new Country();
country.name = 'Belarus';
country.capital = 'Minsk';
country.population = 9000000;

GraphQLNode createCountryNode = new GraphQLNode('createCountry')
    .withArgument('country', country)
    .withField('id')
    .withField('name');

GraphQLMutationNode mutation = new GraphQLMutationNode('CreateCountry', createCountryNode);

GraphQLRequest request = mutation.asRequest()
    // You can add additional HTTP headers if you need
    .withHeader('Authorization', 'Bearer token');

// Provide GraphQL endpoint to the client constructor
IGraphQLClient client = new GraphQLHttpClient('https://simple-gql-server.herokuapp.com/gql');

// Send the request async and provide a callback implementation (can be null)
Id jobId = client.sendAsync(request, new CountryMutationCallback());

// ***************************************** //

public class CountryMutationCallback implements IGraphQLResponseCallback {
    public void received(GraphQLResponse response) {
        // Handle response as you need, just like in other examples
    }
}

// ***************************************** //

public class Country {
    public Integer id;
    public String name;
    public Long population;
    public String capital;
}
