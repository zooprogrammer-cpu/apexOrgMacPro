global class MethodsAndModifiers {

    private final Integer FEES = 100;

    public static Decimal updateRevenue(Decimal grossIncome, Decimal costs) {
        Decimal revenue = grossIncome - costs; 
        return revenue;     
    }

    public void calculateRevenueAndFees() {
        Decimal revenue = updateRevenue(530, 700.50) - FEES;    
        System.debug('The revenue is: ' + revenue);
    }
}