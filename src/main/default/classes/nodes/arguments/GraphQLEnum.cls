/**
 * @description Represents an enum value used in arguments and variables
 */
global class GraphQLEnum {
    /**
     * @description The enum value
     */
    global final String value;

    /**
     * @description Creates an instance of GraphQL enum by the provided enum value
     * @param value The enum value
     */
    global GraphQLEnum(String value) {
        this.value = value;
    }

    public override String toString() {
        return value;
    }
}
