@isTest
public class myNewClassTest {
    
    @isTest
    public static void helloFuncTest() {
        //Data Arange
        //
        //Call
		myNewClass myClass = new myNewClass();
		String returnVal = myClass.helloFunc();
        //Assertions
        System.assertEquals('Hello', returnVal);
    }
    
    @isTest
    public static void helloFuncWithNameTest() {
        //Data Arange
        String Name = 'Himansh';
        //Call
		myNewClass myClass = new myNewClass();
		String returnVal = myClass.helloFunc(Name);
        //Assertions
        System.assertEquals('Hello Himansh', returnVal);
    }
}