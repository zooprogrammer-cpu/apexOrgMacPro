public with sharing class Teacher {
   public string name; 
   public Integer age; 
   public static String schoolName;  

   public void display() {
    System.debug('Teacher Name is: ' + name);
    System.debug('Teacher age is: ' + age);
    System.debug('School Name is: ' + schoolName);     
   }
}