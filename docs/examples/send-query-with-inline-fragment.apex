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
private GraphQLFragmentNode cityFieldsFragment = new GraphQLFragmentNode('City').withField('id').withField('name');

private GraphQLNode countriesNode = new GraphQLNode('countries')
    .withField('name')
    // Use inline fragment fields for the capital node
    .withNode(new GraphQLNode('capital').withInlineFragment(cityFieldsFragment));

private GraphQLQueryNode query = new GraphQLQueryNode(new List<GraphQLNode> { countriesNode, citiesNode });

private GraphQLRequest request = query.asRequest();

private IGraphQLClient client = new GraphQLHttpClient('https://simple-gql-server.herokuapp.com/gql');

private GraphQLResponse response = client.send(request);

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
