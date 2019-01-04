public with sharing class BatchScheduler implements Schedulable  {
	public void execute(SchedulableContext SC) {
		AccountToLeadConveterController BC = new AccountToLeadConveterController();
		Database.executeBatch(BC);
	}
	
	public static void scheduleMe(){
		BatchScheduler BC = new BatchScheduler();
		String sch = '0 31 19 * * ?';
		String jobID = system.schedule('Batch Schedule', sch, BC);
	}
	    
}