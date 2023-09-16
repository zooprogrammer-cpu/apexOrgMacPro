@isTest
public class TemperatureConverterTest {
    @isTest
    public static void testWarmTemp() {
        Decimal celsius = TemperatureConverter.convertFahrenheitToCelsius(70);
        System.assertEquals(20.90, celsius, 'The warm temp test is not working');
    }

    @isTest
    public static void testFreezingPoint(){
        Decimal celsius = TemperatureConverter.convertFahrenheitToCelsius(32);
        System.assertEquals(0, celsius, 'The freezing temperature is not working');
    }

    @isTest
    public static void testBoilingPoint() {
        Decimal celsius = TemperatureConverter.convertFahrenheitToCelsius(212);
        System.assertEquals(99, celsius, 'The boiling temperature is not working');    
    }

    @isTest
    public static void negativeTemperature() {
        Decimal celsius = TemperatureConverter.convertFahrenheitToCelsius(-100);
        System.assertEquals(-72.60, celsius, 'The negative temperature is not working');    
    }
}