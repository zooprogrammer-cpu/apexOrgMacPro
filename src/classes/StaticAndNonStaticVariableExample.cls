public with sharing class StaticAndNonStaticVariableExample {

    public Integer num1; // non-sttaic varaible
    public static Integer num2;  //static variable

    public void increment() {
        num1 += 1; 
        num2 += 1;     
    }

    public void display() {
        System.debug(num1);
        System.debug(num2);
    }
}