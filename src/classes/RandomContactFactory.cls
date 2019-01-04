public class RandomContactFactory {

    public static List<Contact> generateRandomContacts(Integer num, String last_name){
        List<Contact> contacts = new List<Contact>();
        
        for( Integer i=0; i<num; i++ ) {
            Contact newCon = new Contact(FirstName = 'User'+i, LastName = last_name);
            contacts.add(newCon);
        }
        
        return contacts;
    }    
}