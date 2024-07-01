/**
 * 
 */

public with sharing class ClassThatDependsOnA {
    public void callMethodA() {
        ClassEverythingDependsOn megaClass = new ClassEverythingDependsOn();
        megaClass.methodA();
    }

}