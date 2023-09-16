public with sharing class TemperatureConverter {
  public static Decimal convertFahrenheitToCelsius(Decimal f) {
    Decimal celsius; 
    celsius = (f -32)*0.55;
    System.debug('The temperature in celsius is: ' + celsius.setScale(2));
    return celsius.setScale(2);
  }
}