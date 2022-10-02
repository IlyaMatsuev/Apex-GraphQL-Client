@IsTest(IsParallel = true)
private class GraphQLConfigManagerTest {
    @IsTest
    private static void getString_shouldReturnStringConfig() {
        GraphQLConfig config = GraphQLConfig.DateArgumentFormat;
        GraphQLConfigManager.configsByName.put(
            config.name(),
            new GraphQLClientConfig__mdt(DeveloperName = config.name(), Value__c = 'MM/dd/yyyy')
        );

        String configValue = GraphQLConfigManager.getString(config);

        System.assert(configValue != null);
        System.assertEquals('MM/dd/yyyy', configValue);
    }

    @IsTest
    private static void getString_configDoesntExist_shouldThrowException() {
        GraphQLConfig config = GraphQLConfig.DateArgumentFormat;
        GraphQLConfigManager.configsByName.clear();

        Exception error;
        try {
            GraphQLConfigManager.getString(config);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(error != null);
        System.assert(error.getMessage().startsWith('There is no such configuration entry'));
    }
}
