public class ContactSearch {
    public static list<Contact> searchForContacts(String lastName, String mailingCode) {
       return [select Name from Contact where LastName = :lastName AND MailingPostalCode = :mailingCode];
    }
}