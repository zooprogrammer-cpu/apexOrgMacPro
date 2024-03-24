public class SubscriptionProduct extends Product {
    public Integer durationMonths; // Duration of the subscription in months

    // Constructor
    public SubscriptionProduct(String name, Decimal price, Integer durationMonths) {
        super(name, price); // Call the parent class constructor
        this.durationMonths = durationMonths;
    }

    // Override the calculateTotalPrice method for subscription products
    public override Decimal calculateTotalPrice(Decimal price, Integer quantity) {
        // Assuming a simple model where each month of subscription gives a 5% discount,
        // capped at 25% for simplicity.
        Decimal discountRate = 0.05 * Math.min(durationMonths, 5);
        Decimal discountedPrice = price * (1 - discountRate);
        Decimal totalPrice = discountedPrice * quantity;

        System.debug('The total price for the subscription product is: ' + totalPrice);
        return totalPrice;
    }

    // Additional methods specific to SubscriptionProduct can be added here
    // For example, a method to extend the subscription, apply different pricing strategies, etc.
}