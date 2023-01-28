public class GraphQLConfigs {
    private static final Integer CONFIG_QUERY_LIMIT = 50;

    @TestVisible
    private static final Map<String, GraphQLClientConfig__mdt> configsByName = new Map<String, GraphQLClientConfig__mdt>();

    static {
        init();
    }

    public static Integer getInteger(Option config) {
        return Integer.valueOf(getString(config));
    }

    public static Boolean getBoolean(Option config) {
        return Boolean.valueOf(getString(config));
    }

    public static String getString(Option config) {
        return get(config?.name());
    }

    private static String get(String configName) {
        if (String.isBlank(configName) || !configsByName.containsKey(configName)) {
            throw new GraphQLConfigsException('There is no such configuration entry: ' + configName);
        }
        return configsByName.get(configName).Value__c;
    }

    private static void init() {
        List<GraphQLClientConfig__mdt> configs = [
            SELECT DeveloperName, Value__c
            FROM GraphQLClientConfig__mdt
            LIMIT :CONFIG_QUERY_LIMIT
        ];

        for (GraphQLClientConfig__mdt config : configs) {
            configsByName.put(config.DeveloperName, config);
        }
    }

    public enum Option {
        MaxQueryDepth,
        QueryIndentSize,
        SupressNullsForObjectArguments,
        DateArgumentFormat,
        DateTimeArgumentFormat,
        SendPrettyQuery
    }

    private class GraphQLConfigsException extends Exception {}
}
