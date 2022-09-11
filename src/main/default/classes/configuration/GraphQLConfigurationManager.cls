public class GraphQLConfigurationManager {
    private static final Integer CONFIGURATION_QUERY_LIMIT = 50;

    private static final Map<String, GraphQLClientConfiguration__mdt> configurations = new Map<String, GraphQLClientConfiguration__mdt>();

    static {
        initConfigurations();
    }

    public static String getConfiguration(GraphQLConfiguration config) {
        return getConfiguration(config.name());
    }

    public static Integer getConfigurationAsInt(GraphQLConfiguration config) {
        return Integer.valueOf(getConfiguration(config));
    }

    public static Boolean getConfigurationAsBool(GraphQLConfiguration config) {
        return Boolean.valueOf(getConfiguration(config));
    }

    public static String getConfiguration(String configName) {
        if (!configurations.containsKey(configName)) {
            throw new GraphQLConfigurationManagerException(
                Label.NoCustomMetadataConfigError.replace(CommonConstants.FIRST_FORMAT_PARAM, configName)
            );
        }
        return configurations.get(configName).ConfigurationValue__c;
    }

    private static void initConfigurations() {
        List<GraphQLClientConfiguration__mdt> configs = [
            SELECT DeveloperName, ConfigurationValue__c
            FROM GraphQLClientConfiguration__mdt
            LIMIT :CONFIGURATION_QUERY_LIMIT
        ];

        for (GraphQLClientConfiguration__mdt configuration : configs) {
            configurations.put(configuration.DeveloperName, configuration);
        }
    }

    private class GraphQLConfigurationManagerException extends Exception {
    }
}
