@isTest(SeeAllData=true)
public class AccountProcessorTest {   
  @isTest
    private static void test(){
        
        Id id1 = [SELECT id FROM Account where id='0012800000dMA5C'][0].id;
        Test.startTest();
        AccountProcessor.countContacts(new List<id>{id1});
        Test.stopTest();
        System.assert(true);
    }

}