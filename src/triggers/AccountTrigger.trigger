trigger AccountTrigger on Account (before insert, after insert,before update, before delete) {
    
        TriggerFactory.createHandler(Account.sObjectType);
}