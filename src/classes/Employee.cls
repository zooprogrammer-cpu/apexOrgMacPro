public class Employee {
    String firstName;
    public String lastName;
    public Integer salary; 
    public Integer age;
    public Integer startYear {get; private set;}

    public void EmployeeInformation(){
        System.debug('First Name: ' + firstName);
        System.debug('Salary: ' + salary);
        System.debug('Age: ' + age);
        employeePrivateMethod();
    }

    private void employeePrivateMethod() {
        System.debug('I am a private method')  ;  
    }

    public Employee (String firstName, Integer startYear) {
        this.firstName = firstName;
        this.startYear = startYear;

    }

    public Integer calculateTenure(Integer currentYear) {
        Integer tenure = currentYear - this.startYear;
        return tenure;
    }

}