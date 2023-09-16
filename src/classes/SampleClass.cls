public with sharing class SampleClass {
    public static Integer instanceCount; 
    // by default access modifier is private. Can inly be accessed inside the class
    // If System.debug(SampleClass.mySecret), then you get an error Variable is not visible
    public static String mySecret = 'Classified'; 
    public static final String NEVER_CHANGES = 'This cannot change'; 
    Integer myInt = 5; 
    String myString = 'Ash'; 
    Boolean myBool = TRUE; 
  

    public static String sayHello(String firstName) {
        return 'Hello' + firstName; 
    }

    // Can reuse method name if the types of argeuements are different 
    // or no. of  arguements are different.
    // Can even have a different return type 
    public static String sayHello(String name1, String name2) {
        return 'Hello' + name1 + ' and ' + name2;
    }

    public static String sayHello() {
        return sayHello('there');    
    }

    public void showResults() {
        System.debug(myInt + myString + myBool);
    }
 
}