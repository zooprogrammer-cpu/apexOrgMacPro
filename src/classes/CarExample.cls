public with sharing class CarExample {
    public String model;
    public Integer speed;

    public void displayCarInfo() {
        System.debug('The model of the car is: ' + model);
        System.debug('The Speed is: ' + speed);
    }

    private integer increaseSpeed() {
        speed += 10; 
        return speed;     
    }

    public void displayNewCarSpeed() {
        integer newCarSpeed = increaseSpeed();
        System.debug('New Car Speed: ' + newCarSpeed);   
    }
}