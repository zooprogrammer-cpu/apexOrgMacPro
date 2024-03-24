public virtual class Product {
    public String name;
    public Decimal price;

    // Constructor
    public Product(String name, Decimal price) {
        this.name = name;
        this.price = price;
    }

    // Virtual method to calculate the price
    public virtual Decimal calculateTotalPrice(Decimal price, Integer quantity) {
        Decimal totalPrice = price * quantity;
        System.debug('The total price is: ' + totalPrice);
        return totalPrice;
    }
}