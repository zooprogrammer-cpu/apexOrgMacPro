/**
 * 
 */

public with sharing class HelloWorldAction {
    // Can have only one invocable methods in a class
    @InvocableMethod(Label='Say Hello' Description='It says hello to the user')
    public static List<String> sayHello(List<String> inputs) {
       List<String> results = new List<String>();
        for(String input : inputs) {
            results.add(generateGreeting(input));
        }
        return results;
    }

    public static String generateGreeting(String input) {
        return 'Hello ' + input;
    }



}