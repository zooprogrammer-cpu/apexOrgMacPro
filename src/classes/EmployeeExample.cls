public with sharing class EmployeeExample {

    String name; 
    Integer age; 
    Integer salary; 


    public void display() {
        System.debug('Name: ' + name);
        System.debug(('Age: ' + age));
        System.debug('Salary: ' + salary);    
    }

    public EmployeeExample(String n, Integer a, Integer s) {
        name = n; 
        age = a; 
        salary = s; 

    }

    public EmployeeExample(String n, Integer a) {
        name = n; 
        age = a; 
        salary = 90000; 

    }

    public EmployeeExample() {
        name  = 'Nate'; 
        age =  34 ; 
        salary = 80000; 

    }
}