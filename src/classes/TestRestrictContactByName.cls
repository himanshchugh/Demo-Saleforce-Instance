@istest
public class TestRestrictContactByName {
    
    @istest static void testInsertionOfInvalidLastName() {
        Contact con = new Contact(FirstName = 'XYZ', LastName = 'INVALIDNAME');
        Test.startTest();
        Database.SaveResult result = Database.insert(con, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "'+con.LastName+'" is not allowed for DML',
                             result.getErrors()[0].getMessage());
    }
}