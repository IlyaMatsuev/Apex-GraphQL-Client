# Documentation

## Examples

Please take a look at the [examples folder](examples) to know what is possible to do with this package, and how to do it.

## Changelog

Check out the [changelog](changelog) to see the latest changes in the project.

## Type Definitions

All classes available for use can be found [here](types). There is also a short description of their purpose and class members.

## Package Configuration

Configuration capabilities are provided by using the Custom Metadata Type `GraphQLClientConfig__mdt`. Each record represents a piece of configuration. All existing records are described in the table below:

| Label                               | Name                           | Default Value       | Type    | Description                                                                             |
| ----------------------------------- | ------------------------------ | ------------------- | ------- | --------------------------------------------------------------------------------------- |
| Date Argument Format                | DateArgumentFormat             | MM/dd/yyyy          | String  | The format of the date arguments, passed to a query                                     |
| DateTime Argument Format            | DateTimeArgumentFormat         | yyyy-MM-dd HH:mm:ss | String  | The format of the date-time arguments, passed to a query                                |
| Max Query Depth                     | MaxQueryDepth                  | 10                  | Integer | The number of depth levels each node or query can have                                  |
| Query Indent Size                   | QueryIndentSize                | 2                   | Integer | The number of spaces that will be used as indent for pretty-formatted nodes and queries |
| Send Pretty Query                   | SendPrettyQuery                | false               | Boolean | Whether to send well-formatted GraphQL queries to the endpoint or not                   |
| Suppress Nulls For Object Arguments | SupressNullsForObjectArguments | true                | Boolean | Whether to suppress null values for the object arguments in nodes or not                |

You can change each of these settings but do not change their names (`DeveloperName` field), it can lead to issues working with the package.
