@istest
public class TestVerifyDate {
    @istest static void verifyWithPastDateTest(){
        Date finalDate = VerifyDate.CheckDates(Date.newInstance(2016, 06, 24), Date.newInstance(2016, 05, 12));
        System.assertEquals(finalDate, Date.newInstance(2016, 06, 30));
    }
    
    @istest static void verifyWithDateWithinThirtyDaysTest(){
        Date finalDate = VerifyDate.CheckDates(Date.newInstance(2016, 06, 24), Date.newInstance(2016, 07, 03));
        System.assertEquals(finalDate, Date.newInstance(2016, 07, 03));
    }
}