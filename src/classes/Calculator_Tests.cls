@isTest
public with sharing class Calculator_Tests {
    @TestSetup
    static void makeData(){
        // Integer a = 5; 
        // Integer b = 2; 
        
    }

    @isTest
    static void additionTest() {
        //positive testing
        //Calculator calc = new Calculator();
        //Calculator.addition( a, b);
        Decimal add = Calculator.addition(5,2);
        System.assertEquals(7, add, 'The addition is not correct');
        System.assert(7 == add);
        // new Assert class for Winer '23'
        Assert.areEqual(7, add);
        Assert.isTrue( 7 == add);

        //negative testing
        try {
            Decimal addNeg = Calculator.addition(8,3); 
        } catch (Exception ex) {
            Assert.areEqual (ex, MathException.class);
        }
    }
    @isTest
    static void subtractTest() {
        Decimal sub = Calculator.subtraction(5, 2); 
        Assert.areEqual(3,sub);

    }

    @isTest
    static void multiplyTest() {
        Boolean exceptionOccurred = false; 
        Decimal mult = Calculator.multiply(3, 2);
        Assert.areEqual(6,mult);

        // Test le you multiply by zero 
        try {
            Decimal mult2 = Calculator.multiply(0, 2);

        } catch (Exception ex) {
            exceptionOccurred = true; 
        }

        System.assertEquals(true, exceptionOccurred, 'It let you multiply by zero');
    }

    @isTest
    static void divideTest() {
        Boolean exceptionOccurred1 = false; 
        Decimal div = Calculator.divide(6, 3);
        Assert.areEqual(2,div);

        // Test let you divide by zero
        try {
            Decimal div2 = Calculator.divide(6,0);

        } catch (Exception ex) {
            exceptionOccurred1 = true; 
        }

        System.assertEquals(true, exceptionOccurred1, 'It let you divide by zero');

        // Cannot use negative values
        Boolean exceptionOccurred2 = false; 
        try{
            Decimal div3 = Calculator.divide(-89989,2); //need to have large number 
            // otherwise salesforce rounds up -0.5 to 0
           
        }
        catch (Calculator.CalculatorException ex) {
            exceptionOccurred2 = true; 
        }
        System.assertEquals(true, exceptionOccurred2, 'Let you use a negative number to divide');
    }
}