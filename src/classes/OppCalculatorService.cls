/**
 * 
 */

public with sharing class OppCalculatorService {
    private static Map<String, Type> userTypeToCalculatorImpl = new Map<String, Type>{
        'CTO' => OppCalculatorService_CTO.class,
        'Sales Associate' => OppCalculatorService_SalesAssoc.class,
        'Manager' => OppCalculatorService_Managers.class
    };
    // When someone calls calculateOpps method and passes a userType,
    // look at the map and get the appropriate class to run
    // and create a new instance of the class
    // and because we know this class implements
    // the OppCalculator_Interface, we don't need to initialize them as
    // OppCalculatorService_CTO, etc/
    // OppCalculator_Interface requires these classes to implement the calculateOpps() method
    public static void calculateOpps(String userType) {
        OppCalculator_Interface oppCalculator = (OppCalculator_Interface)userTypeToCalculatorImpl.get(userType).newInstance();
        oppCalculator.calculateOpps();

    }

}