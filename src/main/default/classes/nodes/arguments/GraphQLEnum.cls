/**
 * @description Represents an enum value used in arguments and variables
 */
global class GraphQLEnum {
    /**
     * @description The enum value
     */
    global final String value;

    // This field is required to be able to identify the `GraphQLEnum` instance when an argument is JSON-serialized
    private final String classType;

    /**
     * @description Creates an instance of GraphQL enum by the provided enum value
     * @param value The enum value
     */
    global GraphQLEnum(String value) {
        this.value = value;
        this.classType = GraphQLEnum.class.getName();
    }

    public override String toString() {
        return value;
    }
}
