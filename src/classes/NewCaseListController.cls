public class NewCaseListController {
	
    public List<Case> getNewCases(){
       	return [select CaseNumber from Case where status = 'New'];
    }
}