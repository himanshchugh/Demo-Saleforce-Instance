@isTest
public class myNewCalcTest {
    
    @isTest
    public static void subtractTest() {
        Integer num1 = 5;
        Integer num2 = 3;
        
        myNewCalc calc = new MyNewCalc();
        
        Integer difference = calc.subtract(num1, num2);
        
        System.assertEquals(2, difference);
        
       difference = calc.subtract(num2, num1);
        
        System.assertEquals(2, difference);
    }
}