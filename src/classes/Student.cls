public with sharing class Student {
    string name; 
    string schoolName; 
    
    public void displayInfo() {
        System.debug('Student name: ' + name);
        System.debug('School name: ' + schoolName);   
    }
    // lets create a constructor
    public Student(String n, String s) {
        name  = n;
        schoolName = s; 
    }

    // create no argeuement cosntructor
    public Student() {
        name = 'Dug';
        schoolName = 'Happy Days';    
    }
}