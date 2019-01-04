trigger UserTrigger on User (before insert, before update) {
    String companyURL = 'www.google.com';
    for (User u : Trigger.new){
        String UserSignature = u.Signature;
        if (!u.signature.contains(companyURL)){
            u.signature+=('\nCompany Website: '+companyURL);
        }
    }
}