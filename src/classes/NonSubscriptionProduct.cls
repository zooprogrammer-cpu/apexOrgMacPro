public class NonSubscriptionProduct extends Product {
    // Additional properties specific to non-subscription products can be added here

    // Constructor
    public NonSubscriptionProduct(String name, Decimal price) {
        super(name, price); // Call the parent class constructor
    }

    // Here, you don't necessarily need to override the calculateTotalPrice method
    // if the pricing strategy is the same as for general products.
    // But you can override it if the pricing strategy changes in the future.

    // Example of a method specific to NonSubscriptionProduct
    // This is just a placeholder for any specific behavior of non-subscription products
    public void someSpecificMethod() {
        System.debug('Specific behavior for ' + this.name);
    }

    // Override the calculateTotalPrice method if needed, for example:
    /*
    public override Decimal calculateTotalPrice(Decimal price, Integer quantity) {
        // Custom pricing logic for non-subscription products, if different
        Decimal totalPrice = super.calculateTotalPrice(price, quantity);
        // Apply any non-subscription specific adjustments here
        return totalPrice;
    }
    */
}
