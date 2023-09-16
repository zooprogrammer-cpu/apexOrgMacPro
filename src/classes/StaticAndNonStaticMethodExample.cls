public with sharing class StaticAndNonStaticMethodExample {

    static Integer num1= 10;
    Integer num2 = 2; 
   public void nonStaticMethod(){
    System.debug('I am a non static method. You need a object of the class first to call me.');
    System.debug(num1);
    System.debug(num2);
   }

   public static void staticMethod() {
    System.debug('I am a static method. You don\'t need an object of the class first to call me.');
    System.debug(num1);
    //System.debug(num2); //this results in error since static method cannot call non-static varaible
   }
}