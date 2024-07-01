public class ServiceProduct extends Product {
    public Integer hours; // The number of hours for the service

    // Constructor
    public ServiceProduct(String name, Decimal price, Integer hours) {
        super(name, price); // Call the parent class constructor
        this.hours = hours;
    }

    // Override the calculateTotalPrice method for service products
    public override Decimal calculateTotalPrice(Decimal price, Integer quantity) {
        // Assuming the price provided is per hour, so we multiply by hours and quantity.
        // This considers that the service might be offered multiple times (quantity).
        Decimal totalPrice = price * hours * quantity;

        System.debug('The total price for the service product is: ' + totalPrice);
        return totalPrice;
    }

    // Additional methods specific to ServiceProduct can be added here
    // For example, methods to adjust the number of hours, apply discounts based on service duration, etc.
}