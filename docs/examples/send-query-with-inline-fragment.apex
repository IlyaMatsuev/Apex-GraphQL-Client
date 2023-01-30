/*
query CountriesQuery {
  countries {
    name
    capital {
      ... on City {
        id
        name
      }
    }
  }
}
*/

// Create fragment instance passing the type name it's referring to. If we don't provide fragment name it's evaluated as inline fragment
GraphQLFragment cityFieldsFragment = new GraphQLFragment('City').withField('id').withField('name');

GraphQLField countriesNode = new GraphQLField('countries')
    .withField('name')
    // Use inline fragment fields for the capital node
    .withField(new GraphQLField('capital').withInlineFragment(cityFieldsFragment));

GraphQLQuery query = new GraphQLQuery(new List<GraphQLField> { countriesNode, citiesNode });

GraphQLRequest request = query.asRequest();

GraphQLHttpClient client = new GraphQLHttpClient('https://simple-gql-server.herokuapp.com/gql');

GraphQLResponse response = client.send(request);

if (response.hasErrors()) {
    System.debug('First error: ' + response.getErrors().get(0).message);
} else {
    // Handling response as you wish, same as in other examples
    Map<String, Object> dataMap = response.getData();
    DataWrapper data = (DataWrapper) response.getDataAs(DataWrapper.class);
    List<Country> countries = (List<Country>) response.getDataNodeAs('countries', List<Country>.class);
}

// ***************************************** //

public class DataWrapper {
    public List<Country> countries;
}

public class Country {
    public String name;
    public City capital;
}

public class City {
    public Integer id;
    public String name;
}
