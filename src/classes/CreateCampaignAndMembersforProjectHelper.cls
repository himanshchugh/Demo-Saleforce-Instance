public class CreateCampaignAndMembersforProjectHelper 
{
	public static void afterCompanyConversion(List<rdcc__Insight_Company__c> companyList, Map<String, String> compIdAccountIdMap)
    { 
       	companyList = [select id,OwnerId, rdcc__Is_Converted__c,rdcc__Last_Updated__c,name,rdcc__Company_ID__c,rdcc__Fax__c,rdcc__Parent_Role__c,rdcc__Phone__c,rdcc__Role__c,rdcc__Shipping_City__c,rdcc__Shipping_Country__c,rdcc__Shipping_County__c,rdcc__Shipping_Postal_Code__c,rdcc__Shipping_State__c,rdcc__Shipping_Street__c,rdcc__Type__c,rdcc__URL__c ,(select id, rdcc__Primary_Contact__c,rdcc__CMD_Comapany_Id__c,rdcc__Account__c,rdcc__Insight_Company__c from rdcc__Company_Roles__r),(select id,rdcc__CMD_Comapany_Id__c,rdcc__Insight_Company__c,rdcc__Account__c from rdcc__Insight_Classifications__r),(select id,rdcc__From__c,rdcc__CMD_Comapany_Id__c,rdcc__Insight_Company__c from rdcc__Insight_Bids__r),(select id,rdcc__CMD_Comapany_Id__c,rdcc__Contact_ID__c,rdcc__Email__c,rdcc__Fax__c,rdcc__First_Name__c,rdcc__Insight_Company__c,rdcc__Insight_Company__r.name,rdcc__Is_Company_Converted__c,rdcc__Last_Name__c,rdcc__Lead_Source__c,rdcc__Linked_In_Profile__c,rdcc__Mailing_City__c,rdcc__Mailing_Country__c,rdcc__Mailing_Postal_Code__c,rdcc__Mailing_State__c,rdcc__Mailing_Street__c,rdcc__Phone__c,rdcc__Type__c,rdcc__URL__c ,Name from rdcc__Insight_Contacts__r) from rdcc__Insight_Company__c where id  IN:companyList];
        
        Map<string,List<rdcc__ProjectCompanyRole__c>> comRoleMap = new Map<string,List<rdcc__ProjectCompanyRole__c>>();
        Map<string,List<rdcc__AccountClassification__c>> classMap = new Map<string,List<rdcc__AccountClassification__c>>();
        Map<string,List<rdcc__Bid__c>> bidMap = new Map<string,List<rdcc__Bid__c>>();
        Map<string,List<rdcc__Insight_Contact__c>> insConMap = new Map<string,List<rdcc__Insight_Contact__c>>();        
        //Map<string,List<rdcc__ProjectContactRole__c>> conRoleMap = new Map<string,List<rdcc__ProjectContactRole__c>>();
        //Map<String, Contact> insConIdConMap = new Map<String, Contact>();
        Map<string,rdcc__Insight_Contact__c> conIdInsConMap = new Map<string,rdcc__Insight_Contact__c>();
        List<rdcc__ProjectCompanyRole__c> comRoleListUpdate = new List<rdcc__ProjectCompanyRole__c>();
        List<rdcc__Bid__c> bidListUpdate = new List<rdcc__Bid__c>();
        List<rdcc__AccountClassification__c> classListUpdate = new List<rdcc__AccountClassification__c>();
        List<Contact> conList = new List<Contact>();
        Set<String> insConIds = new Set<String>();
        Set<String> primaryContacts = new Set<String>();
        try
        {
            for(rdcc__Insight_Company__c record : companyList)
            {            
                if(!record.rdcc__Company_Roles__r.isEmpty())
                    comRoleMap.put(record.rdcc__Company_ID__c,record.rdcc__Company_Roles__r);
                if(!record.rdcc__Insight_Bids__r.isEmpty())
                    bidMap.put(record.rdcc__Company_ID__c,record.rdcc__Insight_Bids__r);
                if(!record.rdcc__Insight_Classifications__r.isEmpty())
                    classMap.put(record.rdcc__Company_ID__c,record.rdcc__Insight_Classifications__r);
            }
            
            for(String companyId:compIdAccountIdMap.keySet())
            {
                if(comRoleMap.containsKey(companyId))
                {
                    for(rdcc__ProjectCompanyRole__c pComRole: comRoleMap.get(companyId))
                    {
                        if(pComRole.rdcc__Primary_Contact__c != null)
                        {
                            primaryContacts.add(pComRole.rdcc__Primary_Contact__c.trim());
                        }
                        pComRole.rdcc__Account__c = compIdAccountIdMap.get(companyId);
                        pComRole.rdcc__Insight_Company__c = NULL;
                        comRoleListUpdate.add(pComRole);
                    }
                }
                
                if(bidMap.containsKey(companyId))
                {
                    for(rdcc__Bid__c bid: bidMap.get(companyId))
                    {
                        bid.rdcc__From__c = compIdAccountIdMap.get(companyId);
                        bid.rdcc__Insight_Company__c = NULL;
                        bidListUpdate.add(bid);
                    }
                }
                
                if(classMap.containsKey(companyId))
                {
                    for(rdcc__AccountClassification__c classif: classMap.get(companyId))
                    {
                        classif.rdcc__Account__c = compIdAccountIdMap.get(companyId);
                        classif.rdcc__Insight_Company__c = NULL;
                        classListUpdate.add(classif);
                    }
                }
            }  
            // updating company roles with new account
            if(!comRoleListUpdate.isEmpty())
            {
                system.debug('comRoleListUpdate $$$ '+comRoleListUpdate);
                database.update(comRoleListUpdate,false);
            }
            
            // updating bids with new account
            if(!bidListUpdate.isEmpty())
            {
                database.update(bidListUpdate,false);
            }
            
            // updating classification with new account
            if(!classListUpdate.isEmpty())
            {
                database.update(classListUpdate,false);
            }
            
            if(companyList.size() > 0)
            { 
                //rdcc__InsightCompanyTriggerHelperClass.isInsightCompanyTriggerExecuting = TRUE;          
                delete companyList;
                //rdcc__InsightCompanyTriggerHelperClass.isInsightCompanyTriggerExecuting = FALSE;
            }
        }Catch(Exception e){
            System.debug(e.getStackTraceString());
        }
    }
    
    public static void updateConRole(Map<string,List<rdcc__ProjectContactRole__c>> conRoleMap, Map<String, Contact> insConIdConMap){
        List<rdcc__ProjectContactRole__c> conRoleListUpdate = new List<rdcc__ProjectContactRole__c>();
        if(insConIdConMap != null){
            for(String conId:insConIdConMap.keySet()){
                if(conRoleMap.containsKey(conId)){
                    for(rdcc__ProjectContactRole__c pConRole: conRoleMap.get(conId)){
                        Contact myCon = insConIdConMap.get(conId);
                        pConRole.rdcc__Contact__c = myCon.Id;
                        pConRole.rdcc__Account__c = myCon.accountId;
                        pConRole.rdcc__Insight_Contact__c = NULL;
                        conRoleListUpdate.add(pConRole);
                    }
                }
            }
        }       
        
        // updating contact roles with new contact
        if(conRoleListUpdate.size()>0){
            Database.update(conRoleListUpdate,false);
        } 
    }
}