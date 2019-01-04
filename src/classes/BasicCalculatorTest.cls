@istest
public class BasicCalculatorTest {
    @istest static void addingPositiveNumbersTest() {
        Integer sum = BasicCalculator.sum(5, 6);
        System.assertEquals(sum, 11);
    }
    
    @istest static void addingNegativeNumbersTest() {
        Integer sum = BasicCalculator.sum(6, -5);
        System.assertEquals(sum, 1);
    }
    
    @istest static void differenceWithlargestNumberFirstTest() {
        Integer diff = BasicCalculator.difference(14, 9);
        System.assertEquals(diff, 5);
    }
    
    @istest static void differenceWithSmallestNumberFirstTest() {
        Integer diff = BasicCalculator.difference(9, 14);
        System.assertEquals(diff, 5);
    }
}