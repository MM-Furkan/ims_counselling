@isTest
public class RESTCentreCityMasterTest {

    
	public static testMethod void testschedule() {
		Test.StartTest();
		RESTCentreCityMaster testsche = new RESTCentreCityMaster();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}

}