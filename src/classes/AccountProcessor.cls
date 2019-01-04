public class AccountProcessor {
    @future
    public static void countContacts(List<id> accountids){
        List<Contact> contactList = [SELECT id,name,accountid FROM Contact WHERE accountid ='0012800000dMA5C'];
        List<Account> accListToUpdate = [SELECT name,Number_of_Contacts__c FROM Account WHERE ID IN:accountids];
        for(Account a:accListToUpdate){
            a.Number_of_Contacts__c = 0;
            for(Contact c:contactList){
                if(a.Id == c.AccountId){
                     a.Number_of_Contacts__c++;
                }               
            }            
        }
        //update accListToUpdate;
        
    }

}