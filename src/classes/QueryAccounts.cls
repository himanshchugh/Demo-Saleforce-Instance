public class QueryAccounts {

   public void queryAccount(){
        Account accObj = new Account();
        accObj = [Select id, name from account where name = 'Himansh Corportation'];
        system.debug('Printing Account' + accObj);
    }
    public void createAccount(){
        Account accCreate = new Account();
        accCreate.name = 'TarunKumar';
        accCreate.Phone = '1234567890';
        insert accCreate;
    }
    
    public void updateAccount(){
        Account accUpdate = [Select id, name from account where name = 'Himansh Corportation'];
        accUpdate.name = 'Himansh Corporation';
        update accUpdate;
    }
    public void deleteAccount(){
        Account accUpdate = [Select id, name from account where name = 'Himansh Corporation'];
        delete accUpdate;
    }
    
}