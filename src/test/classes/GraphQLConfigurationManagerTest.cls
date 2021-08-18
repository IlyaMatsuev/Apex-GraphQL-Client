@IsTest(IsParallel=true)
private class GraphQLConfigurationManagerTest {
    @IsTest
    private static void getConfigurationPositiveTest() {
        String configName = GraphQLConfiguration.DateArgumentFormat.name();
        GraphQLClientConfiguration__mdt dateArgumentFormatConfig = [
            SELECT ConfigurationValue__c
            FROM GraphQLClientConfiguration__mdt
            WHERE DeveloperName = :configName
        ];

        String configValue = GraphQLConfigurationManager.getConfiguration(configName);

        System.assert(configValue != null);
        System.assertEquals(dateArgumentFormatConfig.ConfigurationValue__c, configValue);
    }

    @IsTest
    private static void getConfigurationNegativeTest() {
        String configName = 'FakeConfig';

        String configValue;
        Exception error;
        try {
            configValue = GraphQLConfigurationManager.getConfiguration(configName);
        } catch (Exception ex) {
            error = ex;
        }

        System.assert(configValue == null);
        System.assert(error != null);
        System.assert(error.getMessage().startsWith('There is no such configuration entry'));
    }
}
