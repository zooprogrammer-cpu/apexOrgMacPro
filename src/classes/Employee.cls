public with sharing class Employee {
    public String employeeName; 
    public Integer salary; 
    public Integer age;

    public void EmployeeInformation(){
        System.debug('Employee Name: ' + employeeName);
        System.debug('Salary: ' + salary);
        System.debug('Age: ' + age);
        employeePrivateMethod();
    }

    private void employeePrivateMethod() {
        System.debug('I am a private method')  ;  
    }

}