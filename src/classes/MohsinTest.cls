public class MohsinTest 
{
    public List<String> option1{get;set;}
    public List<String> option2{get;set;}
    public List<Test_Object__c> rec;
    public MohsinTest()
    {
        option1 = new List<String>();
        option2 = new List<String>();
        rec = [select id,Dataq__c from Test_Object__c limit 1];
        for(Integer i = 1; i<2000; i++)
        {
            option1.add(String.valueOf(i));
            option2.add(String.valueOf(i+1));
            i++;
        }
    }
    
    public void onSave()
    {
        String multiPicklistValues = ApexPages.currentPage().getParameters().get('multiselectvalues');
        rec[0].Dataq__c = multiPicklistValues;
        SYstem.debug('inside'+multiPicklistValues);
        update rec[0];
    }
}