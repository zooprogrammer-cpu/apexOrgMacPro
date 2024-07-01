/**
 * 
 */

public with sharing class ClassThatDependsOnB {
    public void callMethodB() {
        ClassEverythingDependsOn megaClass = new ClassEverythingDependsOn();
        megaClass.methodB();

    }

}