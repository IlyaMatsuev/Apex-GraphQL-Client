@IsTest(isParallel = true)
private class GraphQLConfigsTest {
    @IsTest
    private static void getString_shouldReturnStringConfig() {
        GraphQLConfigs.Option config = GraphQLConfigs.Option.DateArgumentFormat;
        GraphQLConfigs.configsByName.put(
            config.name(),
            new GraphQLClientConfig__mdt(DeveloperName = config.name(), Value__c = 'MM/dd/yyyy')
        );

        String configValue = GraphQLConfigs.getString(config);

        System.assert(configValue != null);
        System.assertEquals('MM/dd/yyyy', configValue);
    }

    @IsTest
    private static void getString_configDoesntExist_shouldThrowException() {
        GraphQLConfigs.Option config = GraphQLConfigs.Option.DateArgumentFormat;
        GraphQLConfigs.configsByName.clear();

        Exception error;
        try {
            GraphQLConfigs.getString(config);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error.getMessage().startsWith('There is no such configuration entry'));
    }
}
