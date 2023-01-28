# Examples

## Send QraphQL Query

Let's say you want to send the query like this:

```
query CountriesQuery {
  countries {
    name
    capital {
      id
      name
    }
  }
}
```

First, you need to build the `countries` node:

```java
GraphQLField countriesNode = new GraphQLField('countries')
    .withField('name')
    // We have the child node "capital" in this example
    .withField(new GraphQLField('capital', new List<String> { 'id', 'name' }));
```

Then you should create the query instance itself:

```java
GraphQLQuery query = new GraphQLQuery('CountriesQuery', countriesNode);
```

Now you can create request and send it. In this example we use the url `https://simple-gql-server.herokuapp.com/gql`. If you try to access your own GraphQL server, please use your url.

```java
GraphQLRequest request = query.asRequest();
GraphQLHttpClient client = new GraphQLHttpClient('https://simple-gql-server.herokuapp.com/gql');
GraphQLResponse response = client.send(request);
```

After you receive the response you can handle it as you wish: you can get it as Map or convert it to an Apex class. In this example we use the second option:

```java
CountriesQueryResponse countries = (CountriesQueryResponse) response.getDataAs(CountriesQueryResponse.class);

System.debug('countries: ' + countries.countries);


// Meanwhile, these are the wrapper classes used above:

public class CountriesQueryResponse {
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
```

This is the basic example of using the package. For more complex examples please take a look at the current folder, there are different examples of using the package with query, mutation, async requests, using directives and fragments.
