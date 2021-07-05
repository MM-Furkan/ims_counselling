@isTest
class RESTStudentCityMasterTest {
public static testMethod void testschedule() {
		Test.StartTest();
		RESTStudentCityMaster testsche = new RESTStudentCityMaster();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}