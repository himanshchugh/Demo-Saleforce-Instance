public class StringArrayTest {

    public static list<String> generateStringArray(Integer n) {
        list<String> arrayString = new list<String>();
        for (Integer i = 0; i<n; i++) {
            String newString = 'Test ' + i;
            arrayString.add(newString);
            System.debug(newString);
        }
        
        return arrayString;
    }
    
    public static void testFunc() {
        list<Account> acc = [select Name from Account where Name like 'SFDC%'];
        System.debug(acc[0]);
    }
}