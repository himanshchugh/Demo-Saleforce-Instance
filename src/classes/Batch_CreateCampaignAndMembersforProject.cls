global class Batch_CreateCampaignAndMembersforProject implements Database.Batchable<sObject>
{
    public static Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator('select id,Name,(select id,rdcc__Primary_Contact__c from R00N40000001LLaZEAW__r where rdcc__Primary_Contact__c!=null),(select id,rdcc__Contact__c,rdcc__Insight_Contact__c,rdcc__Insight_Role__c,rdcc__Contact__r.Name,rdcc__Insight_Contact__r.Name,rdcc__Insight_Role__r.Name from R00N40000001LLaaEAG__r) from rdcc__ReedProject__c where Campaign_Created__c = FALSE LIMIT 50000');
    }
    global void execute(Database.BatchableContext bc, List<rdcc__ReedProject__c> records)
    {
        Map<Id,Map<String,List<Id>>> mapOfProjectAndRolesAndContacts = new Map<Id,Map<String,List<Id>>>();
        List<Project> projects = new List<Project>();
        for(rdcc__ReedProject__c prj : records)
        {
            Project pr = new Project();
            Map<String,List<Id>> mapOfRolesAndContacts = new Map<String,List<Id>>();
            Map<String,List<Id>> mapOfRolesAndInsightContacts = new Map<String,List<Id>>();
            List<String> namesOfPrimaryContacts = new List<String>();
            for(rdcc__ProjectCompanyRole__c cr : prj.R00N40000001LLaZEAW__r)
            {
                if(String.isNotBlank(cr.rdcc__Primary_Contact__c))
                {
                    namesOfPrimaryContacts.add(cr.rdcc__Primary_Contact__c);
                }
            }
            for(rdcc__ProjectContactRole__c conRoles : prj.R00N40000001LLaaEAG__r)
            {
                if(String.isNotBlank(conRoles.rdcc__Contact__c))
                {
                    for(String primaryContact : namesOfPrimaryContacts)
                    {
                        if(primaryContact.equalsIgnoreCase(conRoles.rdcc__Contact__r.Name))
                        {
                            if(mapOfRolesAndContacts.containsKey(conRoles.rdcc__Insight_Role__r.Name))
                            {
                                List<Id> listOfCon = mapOfRolesAndContacts.get(conRoles.rdcc__Insight_Role__r.Name);
                                listOfCon.add(conRoles.rdcc__Contact__c);
                            }
                            else
                            {
                                List<Id> listOfCon = new List<Id>();
                                listOfCon.add(conRoles.rdcc__Contact__c);
                                mapOfRolesAndContacts.put(conRoles.rdcc__Insight_Role__r.Name,listOfCon);
                            }
                            break;
                        }
                    }
                }
                else
                {
                    for(String primaryContact : namesOfPrimaryContacts)
                    {
                        if(primaryContact.equalsIgnoreCase(conRoles.rdcc__Insight_Contact__r.Name))
                        {
                            if(mapOfRolesAndInsightContacts.containsKey(conRoles.rdcc__Insight_Role__r.Name))
                            {
                                List<Id> listOfCon = mapOfRolesAndInsightContacts.get(conRoles.rdcc__Insight_Role__r.Name);
                                listOfCon.add(conRoles.rdcc__Insight_Contact__c);
                            }
                            else
                            {
                                List<Id> listOfCon = new List<Id>();
                                listOfCon.add(conRoles.rdcc__Insight_Contact__c);
                                mapOfRolesAndInsightContacts.put(conRoles.rdcc__Insight_Role__r.Name,listOfCon);
                            }
                            break;
                        }
                    }
                }
            } 
            
            pr.mapOfRolesAndContact = mapOfRolesAndContacts;
            pr.mapOfRolesAndInsightContact = mapOfRolesAndInsightContacts;
            pr.proj_id = prj.Id;
            pr.proj_name = prj.Name;
            projects.add(pr);
        }
        System.debug('Project>>>'+projects);
        List<Id> allInsightContacts = new List<id>();
        for(Project p : projects)
        {
            List<Id> insCons = new List<id>();
            for(List<Id> insConts : p.mapOfRolesAndInsightContact.values())
            {
                insCons.addAll(insConts);                
            }
            allInsightContacts.addAll(insCons);
        }
        System.debug('allInsightContacts>>>'+allInsightContacts);
        List<rdcc__Insight_Contact__c> allInsightContactsRecords = [select id,OwnerId,rdcc__CMD_Comapany_Id__c,rdcc__Contact_ID__c,rdcc__Email__c,rdcc__Fax__c,rdcc__First_Name__c,rdcc__Insight_Company__c,rdcc__Insight_Company__r.name,rdcc__Is_Company_Converted__c,rdcc__Last_Name__c,rdcc__Lead_Source__c,rdcc__Linked_In_Profile__c,rdcc__Mailing_City__c,rdcc__Mailing_Country__c,rdcc__Mailing_Postal_Code__c,rdcc__Mailing_State__c,rdcc__Mailing_Street__c,rdcc__Phone__c,rdcc__Type__c,rdcc__URL__c from rdcc__Insight_Contact__c where id=: allInsightContacts];
        List<String> allInsComIds = new List<String>();
        for(rdcc__Insight_Contact__c insCon : allInsightContactsRecords)
        {
            allInsComIds.add(insCon.rdcc__CMD_Comapany_Id__c);
        }
        List<rdcc__Insight_Company__c> insComps = new List<rdcc__Insight_Company__c>([select id from rdcc__Insight_Company__c where rdcc__Company_ID__c =: allInsComIds]);
        Map<String,Id> convertedAccountId = convertAccount(allInsComIds);
        System.debug('convertedAccountId>>>'+convertedAccountId);
        List<Contact> finalListOfContacts = new List<Contact>();
        for(rdcc__Insight_Contact__c insConRec : allInsightContactsRecords)
        {
            Contact c = mapContactFields(insConRec,convertedAccountId.get(insConRec.rdcc__CMD_Comapany_Id__c));
            finalListOfContacts.add(c);
        }
        System.debug('finalListOfContacts>>>>'+finalListOfContacts);
        Schema.SObjectField f = Contact.Fields.rdcc__Contact_ID__c;
        List<Database.UpsertResult> result = Database.upsert(finalListOfContacts,f,false);
        //insert ;
        Map<String,Contact> insConIdConMap = new Map<String,Contact>();
        Map<Id,Id> insightContactIdAndContactId = new Map<Id,Id>();
        Map<Id,Contact> mapOfIdAndContact = new Map<Id,Contact>();
        for(rdcc__Insight_Contact__c insCon : allInsightContactsRecords)
        {
            for(Contact con : finalListOfContacts)
            {
                if(insCon.rdcc__Contact_ID__c.equalsIgnoreCase(con.rdcc__Contact_ID__c))
                {
                    insightContactIdAndContactId.put(insCon.Id,con.Id);
                    mapOfIdAndContact.put(con.Id,con);
                }
            }
        }
        for(Contact con : finalListOfContacts)
        {
            insConIdConMap.put(con.rdcc__Contact_ID__c,con); 
        }
        Map<string,List<rdcc__ProjectContactRole__c>> conRoleMap = new Map<string,List<rdcc__ProjectContactRole__c>>();
        for(rdcc__Insight_Contact__c conl: [select id,rdcc__CMD_Comapany_Id__c,rdcc__Contact_ID__c, (select id, rdcc__CMD_Contact_Id__c,rdcc__Contact__c,rdcc__Account__c,rdcc__Insight_Contact__c from rdcc__Contact_Roles__r) from rdcc__Insight_Contact__c where id IN: insightContactIdAndContactId.keySet()])
        {            
            if(!conl.rdcc__Contact_Roles__r.isEmpty())
                conRoleMap.put(conl.rdcc__Contact_ID__c,conl.rdcc__Contact_Roles__r);
        }
        
        if(!insConIdConMap.isEmpty()){
            system.debug('conRoleMap $$$ '+conRoleMap);
            CreateCampaignAndMembersforProjectHelper.updateConRole(conRoleMap,insConIdConMap);
        }
        
        CreateCampaignAndMembersforProjectHelper.afterCompanyConversion(insComps,convertedAccountId);
        
        //DataConversionHelper.updateConRole();
        if(!allInsightContactsRecords.isEmpty()){
            //rdcc.InsightContactTriggerHelperClass.isSelfDelete = TRUE;
            //delete allInsightContactsRecords;
            //rdcc.InsightContactTriggerHelperClass.isSelfDelete = FALSE;
        }
        //delete allInsightContactsRecords;
        System.debug('Projects Final 1>>>>'+projects);
        
        //This loop is for adding converted insight contacts to salesforce contact list in the wrapper objects.
        for(Project p : projects)
        {
            for(String role : p.mapOfRolesAndInsightContact.keySet())
            {
                //List<Id> allInsightContact = p.mapOfRolesAndInsightContact.get(role);
                for(Id idOfInsightContact : p.mapOfRolesAndInsightContact.get(role))
                {
                    if(insightContactIdAndContactId.containsKey(idOfInsightContact))
                    {
                        if(!p.mapOfRolesAndContact.isEmpty() && p.mapOfRolesAndContact != NULL)
                        {
                            if(p.mapOfRolesAndContact.containsKey(role))
                            {
                                //few doubts in this from line 154 to 169
                                System.debug('Map of roles and contacts>>>'+p.mapOfRolesAndContact);
                                List<Id> listOfContacts = p.mapOfRolesAndContact.get(role);
                                listOfContacts.add(insightContactIdAndContactId.get(idOfInsightContact));	//has to uncomment this line
                            }
                            else
                            {
                                List<Id> listOfContacts = new List<Id>();
                                listOfContacts.add(insightContactIdAndContactId.get(idOfInsightContact));
                                p.mapOfRolesAndContact.put(role,listOfContacts);
                            }
                        }
                        else
                        {
                            List<Id> listOfContacts = new List<Id>();
                            listOfContacts.add(insightContactIdAndContactId.get(idOfInsightContact));
                            p.mapOfRolesAndContact.put(role,listOfContacts);
                        }
                    }
                }
                
            }
        }
        //loop ends
        System.debug('Projects Final 2>>>>'+projects);
        
        Map<Id,Map<String,List<CampaignMember>>> projCampaignAndMembers = new Map<Id,Map<String,List<CampaignMember>>>();
        List<Campaign> totalCampaigns = new List<Campaign>();
        for(Project proj : projects)
        {
            Map<String,List<CampaignMember>> campaignAndMembers = new Map<String,List<CampaignMember>>();
            for(String role : proj.mapOfRolesAndContact.keySet())
            {
                Campaign camp = new Campaign();
                camp.Name = proj.proj_name+'-'+role;
                List<CampaignMember> caimpaignMembers = new List<CampaignMember>();
                for(Id idOfContact : proj.mapOfRolesAndContact.get(role))
                {
                	Contact con = mapOfIdAndContact.get(idOfContact);
                    CampaignMember cm= New CampaignMember();
                    cm.ContactId = idOfContact;
                    cm.Status = 'Sent';
                    caimpaignMembers.add(cm);
                }
                //System.debug('Cam Mem'+caimpaignMembers);
                campaignAndMembers.put(proj.proj_name+'-'+role,caimpaignMembers);
                System.debug('CamAnd Mem>>>'+campaignAndMembers);
                totalCampaigns.add(camp);
            }
            projCampaignAndMembers.put(proj.proj_id,campaignAndMembers);
        }
        System.debug('Project Camp MemberS 1>>>>'+projCampaignAndMembers);
        insert totalCampaigns;
        //insert projCampaignAndMembers.values().keySet();
        System.debug('Project Camp MemberS 2>>>>'+projCampaignAndMembers);
        List<CampaignMember> totalCampaignMembers = new List<CampaignMember>();
        for(Campaign cmp : totalCampaigns)
        {
            for(Map<String,List<CampaignMember>> campMembers : projCampaignAndMembers.values())
            {
                for(String camName : campMembers.keySet())
                {
                    if(cmp.Name.equalsIgnoreCase(camName))
                    {
                        for(CampaignMember listOfCamMember : campMembers.get(camName))
                        {
                            listOfCamMember.CampaignId = cmp.Id;
                            totalCampaignMembers.add(listOfCamMember);
                        }
                    }
                }
            }
        }
        
        /*
        
        
        for(Map<String,List<CampaignMember>> campMembers : projCampaignAndMembers.values())
        {
            for(String camName : campMembers.keySet())
            {
                if(campMembers.containsKey(camName))
                {
                    for(CampaignMember listOfCamMember : campMembers.get(cam))
                    {
                        listOfCamMember.CampaignId = cam.Id;
                        totalCampaignMembers.add(listOfCamMember);
                    }
                }
            }
        }
		*/
        insert totalCampaignMembers;
        
        for(rdcc__ReedProject__c prj : records)
        {
            prj.Campaign_Created__c = TRUE;
        }
        update records;
    }
    global void finish(Database.BatchableContext bc)
    {
        // execute any post-processing operations
    }  
    
    public static contact mapContactFields(rdcc__Insight_Contact__c insCon, string accountId)
    {
        String insightUpdatesValue = 'Yes';
        rdcc__Configurable_Settings__c config = accessConfigurableSettings();
        // map contact fields
        Contact contact=new Contact();
        
        if(insCon == null){
            return contact;
        }
        contact.OwnerId = insCon.ownerId;
        contact.FirstName=insCon.rdcc__First_Name__c;
        contact.LastName=insCon.rdcc__Last_Name__c;
        contact.rdcc__Contact_ID__c=insCon.rdcc__Contact_ID__c;
        contact.LeadSource=insCon.rdcc__Lead_Source__c;
        contact.Phone=insCon.rdcc__Phone__c;
        contact.Fax=insCon.rdcc__Fax__c;
        contact.Email=insCon.rdcc__Email__c;
        contact.rdcc__URL__c=insCon.rdcc__URL__c;
        contact.MailingStreet=insCon.rdcc__Mailing_Street__c;
        
        contact.MailingPostalCode=insCon.rdcc__Mailing_Postal_Code__c;
        contact.MailingCity=insCon.rdcc__Mailing_City__c;
        //contact.MailingCountry=insCon.rdcc__Mailing_Country__c;
        contact.rdcc__Linked_In_Profile__c = insCon.rdcc__Linked_In_Profile__c;
        contact.AccountId=accountId;
        if(insightUpdatesValue!= null && insightUpdatesValue =='Yes') {                
            contact.rdcc__Allow_Future_ConstructConnect_Updates__c= true;
        }else{
            contact.rdcc__Allow_Future_ConstructConnect_Updates__c = false;
        }
        
        if(isStateCountryPicklistEnabled()){
            if(getCountryName(insCon.rdcc__Mailing_Country__c) != 'NOT FOUND'){
                contact.put('MailingCountryCode',getCountryName(insCon.rdcc__Mailing_Country__c));
                if(getStateName(insCon.rdcc__Mailing_State__c) != 'NOT FOUND'){                    
                    contact.put('MailingStateCode',getStateName(insCon.rdcc__Mailing_State__c));
                }else{
                    //addMessageToPage('ERROR', 'State is Invalid');
                }
            }else{
                //UtilityClass.addMessageToPage('ERROR', 'Country is Invalid');
            }
        }else{
            contact.MailingCountry = insCon.rdcc__Mailing_Country__c;
            contact.MailingState = insCon.rdcc__Mailing_State__c;
        }
        
        if(config.rdcc__Contact_Record_Type__c != null && config.rdcc__Contact_Record_Type__c != ''){
            List<SelectOption> recTypes = getRecordTypeMap('Contact');
            Set<id> recordTypeIds = getAllowedRecordTypeIds('Contact');
            if(recTypes.size()>1){
                if(recordTypeIds.contains(config.rdcc__Contact_Record_Type__c))
                    contact.put('recordTypeId',config.rdcc__Contact_Record_Type__c);
            }  
        }
        return contact;
    }
    
    public Map<String,Id> convertAccount(List<String> allInsComIds){
        List<Account> accList=new List<Account>();
        List<Account> accListFoundInSystem = new List<Account>([select id,rdcc__Company_ID__c,OwnerId, name from account where rdcc__Company_ID__c =: allInsComIds]);
        List<rdcc__Insight_Company__c> companies = new List<rdcc__Insight_Company__c>([select id,OwnerId, rdcc__Is_Converted__c,rdcc__Last_Updated__c,name,rdcc__Company_ID__c,rdcc__Fax__c,rdcc__Parent_Role__c,rdcc__Phone__c,rdcc__Role__c,rdcc__Shipping_City__c,rdcc__Shipping_Country__c,rdcc__Shipping_County__c,rdcc__Shipping_Postal_Code__c,rdcc__Shipping_State__c,rdcc__Shipping_Street__c,rdcc__Type__c,rdcc__URL__c from rdcc__Insight_Company__c where rdcc__Company_ID__c =: allInsComIds]);
        Map<String,Id> accIdCompId = new Map<String,Id>();
        String insightUpdatesValue = 'Yes';
        Map<String,String> accountCustomMandatoryFieldMap = getMandatoryFields('Account');
        //rdcc.UtilityClass.getMandatoryFields('Account');
        for(Account acc : accListFoundInSystem)
        {
            accIdCompId.put(acc.rdcc__Company_ID__c,acc.Id);
        }
        if(accIdCompId.size() == allInsComIds.size())
        {
            return accIdCompId;
        }
        else
        {
            for(rdcc__Insight_Company__c insCom : companies)
            {
                Account a = mapAccountFields(insCom, insightUpdatesValue);
                accList.add(a);
            }
        }
        
        if(!accList.isEmpty())
        {          
            Database.DMLOptions dml=new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave=true;            
            Database.SaveResult[] srList = Database.insert(accList);
            for(Account a : accList)
            {
                accIdCompId.put(a.rdcc__Company_ID__c,a.Id);
            }            
        }
        //System.debug('*****Inside Convert Account Method******');
        return accIdCompId;
    }
    
    public static Account mapAccountFields(rdcc__Insight_Company__c insComp, String insightUpdatesValue)
    {
        rdcc__Configurable_Settings__c config = accessConfigurableSettings();
        Account a=new Account();
        if(insComp == null){
            return a;
        }
        
        a.Name=insComp.Name; 
        a.OwnerId = insComp.ownerId;
        a.rdcc__Company_ID__c=insComp.rdcc__Company_ID__c;
        a.rdcc__URL__c=insComp.rdcc__URL__c;
        a.Fax=insComp.rdcc__Fax__c;
        a.Phone=insComp.rdcc__Phone__c;
        a.BillingCity=insComp.rdcc__Shipping_City__c;
        a.ShippingCity=insComp.rdcc__Shipping_City__c;
        
        //Changed for CRM-163
        //a.Type=insComp.rdcc__Type__c;
        a.rdcc__Construct_Connect_Type__c = insComp.rdcc__Type__c;
        
        
        if(isStateCountryPicklistEnabled()){            
            if(getCountryName(insComp.rdcc__Shipping_Country__c) != 'NOT FOUND'){                
                a.put('BillingCountryCode',getCountryName(insComp.rdcc__Shipping_Country__c));                
                a.put('ShippingCountryCode',getCountryName(insComp.rdcc__Shipping_Country__c));
                if(getStateName(insComp.rdcc__Shipping_State__c) != 'NOT FOUND'){
                    a.put('BillingStateCode',getStateName(insComp.rdcc__Shipping_State__c));
                    a.put('ShippingStateCode',getStateName(insComp.rdcc__Shipping_State__c));
                }else{
                    //rdcc.UtilityClass.addMessageToPage('ERROR', 'State is Invalid');
                }
            }else{
                //rdcc.UtilityClass.addMessageToPage('ERROR', 'Country is Invalid');
            }
        }else{
            a.BillingCountry=insComp.rdcc__Shipping_Country__c;
            a.BillingState=insComp.rdcc__Shipping_State__c;
            a.shippingCountry=insComp.rdcc__Shipping_Country__c;
            a.shippingState=insComp.rdcc__Shipping_State__c;
        }
        
        a.BillingStreet=insComp.rdcc__Shipping_Street__c;
        a.shippingStreet=insComp.rdcc__Shipping_Street__c;
        a.BillingPostalCode=insComp.rdcc__Shipping_Postal_Code__c;
        a.ShippingPostalCode=insComp.rdcc__Shipping_Postal_Code__c;
        a.rdcc__Billing_County__c=insComp.rdcc__Shipping_County__c;
        
        if(insightUpdatesValue!= null && insightUpdatesValue =='Yes'){
            a.rdcc__Allow_Future_ConstructConnect_Updates__c= true;
        }
        else if(config.rdcc__Allow_Future_Updates_to_Account_Contact__c != null && config.rdcc__Allow_Future_Updates_to_Account_Contact__c == 'Yes')
        {
            a.rdcc__Allow_Future_ConstructConnect_Updates__c = TRUE;
        }
        else{
            a.rdcc__Allow_Future_ConstructConnect_Updates__c = false;
        }
        
        if(config.rdcc__Account_Record_Type__c != null && config.rdcc__Account_Record_Type__c != '' && config.rdcc__Account_Record_Type__c != '--NONE--'){
            List<SelectOption> recTypes = getRecordTypeMap('Account');
            Set<id> recordTypeIds = getAllowedRecordTypeIds('Account');
            if(recTypes.size()>1){
                if(recordTypeIds.contains(config.rdcc__Account_Record_Type__c))
                    a.put('recordTypeId',config.rdcc__Account_Record_Type__c);
            }
        }
        return a;
    }
    
    
    class Project
    {
        public Id proj_id{get;set;}
        public String proj_name{get;set;}
        public Map<String,List<Id>> mapOfRolesAndContact{get;set;}
        public Map<String,List<Id>> mapOfRolesAndInsightContact{get;set;}
    }
    
    //Utility class 
    public static boolean isStateCountryPicklistEnabled(){
        boolean isStateCountryPicklistEnabled;
        if(isStateCountryPicklistEnabled == null){
            isStateCountryPicklistEnabled = getFieldMap('Account').containsKey('billingstatecode');
        }
        return isStateCountryPicklistEnabled;
    }
    
    
    public static String getCountryName(String country){
        String NOTFOUND = 'NOT FOUND';
        Map<String,String> countryMap;
        if(countryMap == null ){            
            countryMap =  new Map<String,String>();
            Map<String,Schema.SObjectField> objMap = getFieldMap('Account');            
            Schema.DescribeFieldResult fieldResult;
            if(objMap.get('billingcountrycode')!=null)
            {
                fieldResult = objMap.get('billingcountrycode').getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();            
                for( Schema.PicklistEntry f : ple){                
                    countryMap.put(f.getLabel().toUpperCase(),f.getValue().toUpperCase());
                }      
            }            
        }
        
        if(countryMap != null && countryMap.containsKey(country.toUpperCase() )){
            return countryMap.get(country.toUpperCase());
        }else if(countryMap != null && new Set<String>(countryMap.values()).contains(country.toUpperCase())){            
            return country;            
        }
        return NOTFOUND;        
    }
    
    public static Set<Id> getAllowedRecordTypeIds(string obj)
    {
        Set<Id> recIds = new Set<Id>();
        for(RecordTypeInfo info: schemaMap.get(obj).getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable()) {
                recIds.add(info.getRecordTypeId());
            }
        }
        return recIds;
    }
    
    public static List<SelectOption> getRecordTypeMap(String obj){        
        List<SelectOption> recordTypeList = new List<SelectOption>();
        recordTypeList.add(new SelectOption('','--NONE--'));
        List<Schema.RecordTypeInfo> recordTypes = schemaMap.get(obj).getDescribe().getRecordTypeInfos();
        if(recordTypes != null && !recordTypes.isEmpty()){
            for(Schema.RecordTypeInfo eachRT:recordTypes){ 
                if(!eachRT.isMaster()){
                    recordTypeList.add(new SelectOption(eachRT.getRecordTypeId(), eachRT.getName()));
                }
            }                      
        }
        return recordTypeList; 
    }
    public static Map<String,String> getMandatoryFields(String sObjectName){
        
        Map<String,String> fieldApiNmLabelMap = new Map<String,String>();       
        for(Schema.SObjectField objField:getFieldMap(sObjectName).values()){
            Schema.DescribeFieldResult dfr = objField.getDescribe();
            if(!dfr.isNillable() && dfr.isCustom() && dfr.getType().name() != 'Boolean' && !dfr.isAutoNumber() && !dfr.isCalculated()){
                fieldApiNmLabelMap.put(dfr.getName(), dfr.getLabel());
            }
        }
        return fieldApiNmLabelMap;
    }
    
    public static String getStateName(String state){
        String NOTFOUND = 'NOT FOUND';
        Map<String,String> stateMap;        
        if(stateMap == null ){
            stateMap =  new Map<String,String>();
            Schema.DescribeFieldResult fieldResult;
            Map<String,Schema.SObjectField> objMap1 = getFieldMap('Account');
            if(getFieldMap('Account').get('billingstatecode')!=null)
            {
                fieldResult = objMap1.get('billingstatecode').getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();            
                for( Schema.PicklistEntry f : ple){                
                    stateMap.put(f.getLabel().toUpperCase() ,f.getValue().toUpperCase());
                    //System.debug(f.getLabel()+'-->'+f.getValue());
                }    
            }
            
        }
        //System.debug('***state'+state);
        if(stateMap.containsKey(state.toUpperCase())){
            //System.debug('stateMap.get(state.toUpperCase())'+stateMap.get(state.toUpperCase()));
            return stateMap.get(state.toUpperCase());
        }else if(new Set<String>(stateMap.values()).contains(state.toUpperCase())){            
            return state;            
        }
        return NOTFOUND;
    }
    public static Map<String,Schema.SObjectField> getFieldMap(String sObj){       
        return schemaMap.get(sObj).getDescribe().fields.getMap();
    }
    
    public static rdcc__Configurable_Settings__c  accessConfigurableSettings(){        
        String SobjectApiName = 'rdcc__Configurable_Settings__c';
        List<rdcc__Configurable_Settings__c> cs =  (List<rdcc__Configurable_Settings__c>)queryAllFields(SobjectApiName);
        if(cs!= null && !cs.isEmpty()){
            return cs[0];
        }
        return new rdcc__Configurable_Settings__c();
    }
    
    
    //query all fields of accepted sobject.
    public static List<SObject> queryAllFields(String SobjectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        try{
            String commaSepratedFields = '';
            for(String fieldName : fieldMap.keyset()){
                if(fieldName.endsWith('__c')){
                    if(commaSepratedFields == null || commaSepratedFields == ''){
                        commaSepratedFields = fieldName;
                    }else{
                        commaSepratedFields = commaSepratedFields + ', ' + fieldName;
                    }
                }
            }        
            String query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Limit 1';        
            List<SObject> config = Database.query(query); 
            
            return config;  
        }Catch(Exception e){
            System.debug('***Error Message:'+e.getMessage());
            //UtilityClass.addMessageToPage(e.getMessage(),'ERROR');
            return null;
        }
    } 
    //Utility class ends
    
}