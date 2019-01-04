public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String searchStr) {
        List<List<SObject>> results = [FIND :searchStr in ALL FIELDS RETURNING Contact(FirstName, LastName), Lead(Name) ];
        return results;
    }
}